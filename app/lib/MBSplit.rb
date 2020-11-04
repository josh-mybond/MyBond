# https://docs.split.cash/#sandbox-testing-details

class MBSplit

  def initialize

    # TODO: change for production..
    @scopes         = "public agreements bank_accounts bank_connections contacts open_agreements payments payment_requests refunds transactions offline_access"
    @confidential   = true
    @callback_urls  = "urn:ietf:wg:oauth:2.0:oob"

    # case Rails.env.production?
    # when true
    #   @api_url        = "https://api.split.cash/"
    #   @ui_url         = "https://go.split.cash/"
    #   @valid_ips      = ["52.64.11.67", "13.238.78.114"]
    #
    #   # TODO: change these for production..
    #   @access_token   = "KEMJnZHvzOnOVkQfK5iFIpzaxOhhbPdgGNXiG09fpYc"
    #   @application_id = "GJ9OpmlOtDNz9ciyiQNlx8UFsbJh1evznb3bSqfuJVs"
    #   @secret         = "slohw7ehgH1YBUH_fFqRtG7KL20fMd0zN86lMdCpb_Q"
    #   @webhook_key    = "c9230c73f4dae4d497bfb437886b05906548a46ad65476826114e2c08fecb493"
    # when false
    #   @api_url        = "https://api.sandbox.split.cash/"
    #   @ui_url         = "https://go.sandbox.split.cash/"
    #   @valid_ips      = "13.237.142.60"
    #   @access_token   = "KEMJnZHvzOnOVkQfK5iFIpzaxOhhbPdgGNXiG09fpYc"
    #   @application_id = "GJ9OpmlOtDNz9ciyiQNlx8UFsbJh1evznb3bSqfuJVs"
    #   @secret         = "slohw7ehgH1YBUH_fFqRtG7KL20fMd0zN86lMdCpb_Q"
    #   @webhook_key    = "c9230c73f4dae4d497bfb437886b05906548a46ad65476826114e2c08fecb493"
    # end

    @api_url        = ENV['split_api_url']
    @ui_url         = ENV['split_ui_url']
    @valid_ips      = ENV['split_valid_ips']
    @access_token   = ENV['split_access_token']
    @application_id = ENV['split_application_id']
    @secret         = ENV['split_secret']
    @webhook_key    = ENV['split_webhook_key']

  end


  #
  # Webhooks
  #

  def webhook_set!(headers, request)
    # @params = params
    @headers = request.headers
    @params  = request.params
    @body    = request.raw_post
  end

  def webhook_key_challenge?
    if !@webhook_key or !@headers or !@body  then return false end
    if !@headers["Split-Request-ID"]         then return false end
    if !@headers["Split-Signature"]          then return false end

      array     = headers["Split-Signature"].split('.')
      timestamp = array[0]
      signature = array[1]

      # do we pass time tolerance test
      time_sent = Time.at(timestamp.to_i).to_datetime
      if time_sent < Time.now - 5.minutes then return false end
      if time_sent > Time.now + 5.minutes then return false end

      # Confirm digest
      signature == OpenSSL::HMAC.hexdigest("SHA256", @webhook_key, "#{timestamp}.#{body.to_s}")
  end

  def webhook_handler!(object)
    # puts "webhook_handler: 1"
    object = object.deep_symbolize_keys

    # puts object.inspect

    # sanity check
    return if !object[:data]

    element = object[:data][0]
    return if !element


    # if contract.nil?
    #   puts "#{Time.now} Split webhook unable to locate contract for: #{data.inspect}"
    #   return
    # end

    puts object[:event][:type]

    # handle webhook
    case object[:event][:type]
    when "agreement.accepted"
      return if !element[:metadata]
      return if !element[:metadata][:contract_id]

      contract = Contract.find(element[:metadata][:contract_id])
      contract.push_to_split_history!({ :data => object, :save => false })
      contract.customer_accepted!
    when "payment_request.pending_approval"
      #	Do nothing - Waiting for the authoriser to approve the PR.
    when "payment_request.unverified"
      #	Do nothing - Waiting for available funds response (only applicable when precheck_funds enabled).
    when "payment_request.approved"
      #	YaY.. we are going to get paid! - The authoriser has approved the PR.
      contract = Contract.find_by(split_authoriser_contact_id: element[:authoriser_contact_id])
      contract.push_to_split_history!({ :data => object, :save => false })
      contract.paid!
    when "payment_request.declined"
      #	Boo - The payer has declined the PR.
      # Keep the contract in application status so the client
      # can start again
      contract.push_to_split_history!({ :data => object, :save => true })
      # TODO: send email to keep the application going

    when "payment_request.cancelled"
      #	Boo - The initiator (US) has cancelled the PR.
      contract.push_to_split_history!({ :data => object, :save => false })
      contract.cancelled!
    end

  end

  #
  # Agreements
  #


  def split_agreement_parameters(contract)

    # terms - unlimited
    terms = {}
    terms["terms"]                    = false
    terms["per_payout"]               = {}
    terms["per_payout"]["min_amount"] = nil
    terms["per_frequency"]            = {}
    terms["per_frequency"]["days"]    = nil

    # agreement
    agreement = {}
    agreement["title"]             = "My Bond Agreement Title"
    agreement["email"]             = "wow@wow.com"
    agreement["single_use"]        = false
    agreement["expiry_in_seconds"] = 600 # 10 minutes
    agreement["terms"]             = terms
    agreement["metadata"] = {
      contract_id: contract.id
    }
    agreement
  end

  def split_unassigned_agreement(contract)
    body = split_agreement_parameters(contract)
    json_request("POST", "unassigned_agreements", body, headers)
  end

  def add_link_customisation(contract, customer, link)
    # Check this link for options
    # https://help.split.cash/en/articles/1777919-unassigned-agreement
    header_title = "My Bond Direct Debit Agreement"
    success_url  = "#{ENV['split_success_url']}#{contract.id}"
    failure_url  = "#{ENV['split_failure_url']}#{contract.id}"
    cancel_url   = "#{ENV['split_cancel_url']}#{contract.id}"

    # use redirect method
    "#{link}?embed=1&whitelabel=1&name=#{customer.full_name}&email=#{customer.email}&success_url=#{success_url}&failure_url=#{failure_url}&cancel_url=#{cancel_url}"

    # use javascript method window
    # "#{link}?embed=1&whitelabel=1&name=#{customer.full_name}&email=#{customer.email}&handle_success=1&handle_failure=1"
  end

  def get_unassigned_agreement(ref)
    json_request("GET", "unassigned_agreements/#{ref}", {}, headers)
    # https://api.sandbox.split.cash/unassigned_agreements/A.4k
  end

  def get_all_unassigned_agreements
    json_request("GET", "unassigned_agreements", {}, headers)
  end

  #
  # Open agreements

  def get_all_open_agreements
    json_request("GET", "open_agreements", {}, headers)
  end

  #
  # Payments
  #

  def payment_request(amount, split_authoriser_contact_id)
    data = {}
    data["description"] = "Payment to My Bond"
    data["matures_at"]  = DateTime.now.iso8601
    data["amount"]      = amount
    data["authoriser_contact_id"] = split_authoriser_contact_id
    data["precheck_funds"] = true
    json_request("POST", "payment_requests", data, headers)
  end

  private

  def headers
    headers = {}
    headers["content-type"]  = "application/json"
    headers["accept"]        = 'application/json'
    headers["authorization"] = "Bearer #{@access_token}"
    headers
  end

  def json_request(method, path, body, headers = {})
    response = http_request(method, path, body, headers)

    # puts "------------------------"
    # puts response.inspect
    # puts "------------------------"

    response.body.nil? ? {} : JSON.parse(response.body)
  end


  def http_request(method, path, body, headers = headers)
    url = "#{@api_url}#{path}"

    case method.downcase
    when "get"  then HTTParty.get(url,  { headers: headers })
    when "post" then HTTParty.post(url, { body: body.to_json, headers: headers })
    end
  end

end
