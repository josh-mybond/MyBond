#include required libraries
		require 'uri'
		require 'net/http'
		require 'base64'
		require 'json'
		require 'open-uri'


class MBShuftiPro

  def initialize
    @url        = URI("https://shuftipro.com/api/")
    @client_id  = ENV['shuftipro_client_id']
    @secret_key = ENV['shuftipro_secret_key']
  end

end


		# verification_request = {
		# 		#your unique request reference
		# 		"reference"					 : 'Ref-'+ (0...8).map { (65 + rand(26)).chr }.join,
		# 		#URL where you will receive the webhooks from Shufti Pro
		# 		"callback_url"				 : 'https://yourdomain.com/profile/notifyCallback',
		# 		#end-user email
		# 		"email"							 : "johndoe@example.com",
		# 		#end-user country
		# 		"country"						 : "",
		# 		#URL where end-user will be redirected after verification completed
		# 		"redirect_url"					 : "https://staging-mybond.com.au/shuftipro",
		# 		#what kind of proofs will be provided to Shufti Pro for verification?
		# 		"verification_mode"		 : "image_only",
		# 		#allow end-user to upload verification proofs if the webcam is not accessible
		# 		"allow_offline"				 : "1",
		# 		#allow end user to upload real-time or already	catured proofs
		# 		"allow_online" : "1",
		# 		#privacy policy screen will be shown to end-user
		# 		"show_privacy_policy" : "1",
		# 		#verification results screen will be shown to end-user
		# 		"show_results"				 : "1",
		# 		#consent screen will be shown to end-user
		# 		"show_consent"			 : "1",
		# 		#User can send Feedback
		# 		"show_feedback_form"			 : "1"
		# }
    #
		# #face onsite verification
		# verification_request['face'] = {}
		# #document onsite verification with OCR
		# verification_request['document'] = {
		# 		'supported_types'		:	 ['id_card','driving_license','passport'],
		# 		'name'							: "",
		# 		'dob'								: "",
		# 		'gender'								: "",
		# 		'place_of_issue'								: "",
		# 		'document_number'	: "",
		# 		'expiry_date'					: "",
		# 		'issue_date'					: "",
		# 		'fetch_enhanced_data'			 : "1",
		# }
		# #document two onsite verification with OCR
		# verification_request['document_two'] = {
		# 		'supported_types'		:	 ['id_card','driving_license','passport'],
		# 		'name'							: "",
		# 		'document_number'	: "",
		# 		'fetch_enhanced_data'			 : "1",
		# }
		# #address onsite verification with OCR
		# verification_request['address'] = {
		# 		'name'								: "",
		# 		'full_address'					: "",
		# 		'address_fuzzy_match'	: '1',
		# 		'issue_date'						: "",
		# 		'supported_types'			: ['utility_bill','passport','bank_statement']
		# }
		# #consent onsite verification
		# verification_request['consent'] =	{
		# 		'text'						: 'some text for consent verificaiton',
		# 		'supported_type'	: ['handwritten','printed']
		# }
		# #background checks/AML verification with OCR
		# verification_request['background_checks'] = ""
    #
		# http = Net::HTTP.new(url.host, url.port)
		# http.use_ssl = true
		# request = Net::HTTP::Post.new(url)
		# #set BASIC AUTH
		# header_auth = Base64.strict_encode64("#{CLIENT_ID}:#{SECRET_KEY}")
    #
		# request["Content-Type"]	= "application/json"
		# request["Authorization"] = "Basic #{header_auth}"
		# request.body = verification_request.to_json
    #
		# response = http.request(request)
		# response_headers =	response.instance_variable_get("@header")
		# response_data		= response.read_body
    #
		# sp_signature		 = response_headers['signature'].join(',')
		# calculated_signature = Digest::SHA256.hexdigest response_data + SECRET_KEY
    #
		# if sp_signature == calculated_signature
		# 	 puts response_data
		# else
		# 		puts "Invalid signature"
		# end
