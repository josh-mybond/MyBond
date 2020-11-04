require "#{Rails.root}/app/lib/MBTestBase"

class MBTestSplit < MBTestBase

  def initialize
    super

    heading "MBTestSplit is alive"

    @split = MBSplit.new

    setup_for_testing

    proposed_agreement

    request_first_payment

    request_first_payment_response
    #
    # first_payment_webhook
  end

  def setup_for_testing
    heading "setup_for_testing"

    @contract = Contract.find(101)

    if @contract.nil?
      puts "Unable to locate contract id: 101".red
      exit(0)
    end

    @contract.split_authoriser_contact_id = ""

    @contract.application!
    @contract.data["split_history"] = [@contract.data["split_history"][0]]
    @contract.save

    test_response("Contract status should be Application: #{@contract.status_to_s}", @contract.application?)
    test_response("Contract should have 1 split history: #{@contract.data["split_history"].count}", @contract.data["split_history"].count == 1)
    test_response("Contract.split_authoriser_contact_id should not blank: #{@contract.split_authoriser_contact_id}", @contract.split_authoriser_contact_id.blank?)
  end

  def proposed_agreement
    heading "proposed_agreement"

    object = {
      "data": [
        {
          "ref": "A.fy7",
          "terms": {
            "per_payout": {
              "min_amount": nil
            },
            "per_frequency": {
              "days": nil
            }
          },
          "status": "accepted",
          "metadata": {
            "contract_id": 101
          },
          "contact_id": "96ddb017-e104-4480-92f7-5f12e8636dd1",
          "created_at": "2020-11-02T19:43:05Z",
          "initiator_id": "5f128ac4-b081-4275-8b69-72d6babd834e",
          "responded_at": "2020-11-02T19:43:26Z",
          "authoriser_id": "8e0bc9f3-ca9e-4ae9-b148-5b9237822890",
          "status_reason": nil,
          "bank_account_id": "dd640aa8-1f98-4936-9522-b08f0904d782",
          "open_agreement_id": nil
        }
      ],
      "event": {
        "at": "2020-11-02T19:43:26Z",
        "who": {
          "account_id": "8e0bc9f3-ca9e-4ae9-b148-5b9237822890",
          "account_type": "AnyoneAccount"
        },
        "type": "agreement.accepted"
      }
    }

    @split.webhook_handler!(object)

    @contract.reload
    test_response("Contract status should be Customer Accepted: #{@contract.status_to_s}", @contract.customer_accepted?)
    test_response("Contract should have 2 split history: #{@contract.data["split_history"].count}", @contract.data["split_history"].count == 2)
    test_response("Contract.split_authoriser_contact_id should not be blank: #{@contract.split_authoriser_contact_id}", !@contract.split_authoriser_contact_id.blank?)
  end

  def request_first_payment
    heading "request_first_payment"

    @contract.first_payment!
    test_response("Contract status should be Payment Requested: #{@contract.status_to_s}", @contract.payment_requested?)
    test_response("Contract should have 3 split history: #{@contract.data["split_history"].count}", @contract.data["split_history"].count == 3)
  end

  def request_first_payment_response
    heading "request_first_payment_response"

    object = {
      "data": [
        {
          "ref": "PR.n6m",
          "payout": {
            "amount": 1000,
            "matures_at": "2020-11-03T03:42:21Z",
            "description": "Payment to My Bond"
          },
          "status": "approved",
          "created_at": "2020-11-03T03:42:22Z",
          "credit_ref": "C.30iu",
          "matures_at": "2020-11-03T03:42:21Z",
          "initiator_id": "b58f8aa5-f0fb-4194-9234-9723ede15bcb",
          "responded_at": "2020-11-03T03:42:22Z",
          "schedule_ref": null,
          "authoriser_id": "dd640aa8-1f98-4936-9522-b08f0904d782",
          "status_reason": null,
          "your_bank_account_id": "b58f8aa5-f0fb-4194-9234-9723ede15bcb",
          "authoriser_contact_id": "96ddb017-e104-4480-92f7-5f12e8636dd1"
        }
      ],
      "event": {
        "at": "2020-11-03T03:42:22Z",
        "who": {
          "account_id": "8e0bc9f3-ca9e-4ae9-b148-5b9237822890",
          "account_type": "AnyoneAccount",
          "bank_account_id": "dd640aa8-1f98-4936-9522-b08f0904d782",
          "bank_account_type": "BankAccount"
        },
        "type": "payment_request.approved"
      }
    }

    @split.webhook_handler!(object)
    @contract.reload
    test_response("Contract status should be Paid: #{@contract.status_to_s}", @contract.paid?)
    test_response("Contract should have 4 split history: #{@contract.data["split_history"].count}", @contract.data["split_history"].count == 4)
  end

  def first_payment_webhook
    heading "first_payment_webhook"
  end

  private

  def null
    nil
  end

end
