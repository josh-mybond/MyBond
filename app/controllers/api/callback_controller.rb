class Api::CallbackController < ApplicationController

  def moneyloop

    key     = "82bda9fc2529d78643835a0e5de0b1107eaa3c8375cee2f187a6929cf8ea958879d8eac0745c5b92383cbe257fb3833240c29626c9d6b53327f07dd0d6a517cf"
    time    = request.headers["time"]
    string  = request.raw_post
    digest  = request.headers["digest"]

    object = case MBCrypto::valid_digest?(key, time, string, digest)
      when true  then { success: "ok" }
      when false then { error: "true"}
      end

  end

end
