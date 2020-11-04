class WebhooksController < ApplicationController

  def split
    log_header

    split = MBSplit.new

    split.webhook_set!(headers, request)

    case split.webhook_key_challenge?
    when false then @error = "Failed key challenge"
    when true
      json = JSON.parse(request.raw_post)

      event = json["event"]

      json["data"].each do |item|
      end

    end

  end

end
