class Api::CallbackController < ApplicationController

  def moneyloop

    key     = "82bda9fc2529d78643835a0e5de0b1107eaa3c8375cee2f187a6929cf8ea958879d8eac0745c5b92383cbe257fb3833240c29626c9d6b53327f07dd0d6a517cf"
    time    = request.headers["time"]
    digest  = request.headers["digest"]

    if MBCrypto::valid_digest?(key, time, request.raw_post, digest)
      json = JSON.parse(request.raw_post)

      contract = Contract.find(json["api_identifier"])
      contract.update_from_callback!(json) if contract
    end

  end

end
