require 'openssl'
require 'securerandom'

#
# Usage
# keys   = MBCrypto::generate_keys


class MBCrypto

  def self.generate_hmac_key
    SecureRandom.hex(64)
  end

  def self.generate_keys
    pair = OpenSSL::PKey::RSA.new(common[:key_length])   # create a public/private key pair for this party

    {
      :private => pair.to_pem,
      :public  => pair.public_key.to_pem
    }
  end

  def self.digest_string(time, string)
    "#{time}.#{string}"
  end

  def self.digest(key, string)
    time = Time.now.iso8601
    {
      time:  time,
      digest: OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, digest_string(time, string))
    }
  end

  def self.valid_digest?(key, time, string, digest)
    digest == OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, digest_string(time, string))
  end

  def self.encrypt(private_key, public_key, message)

    private   = OpenSSL::PKey::RSA.new(private_key)
    public    = OpenSSL::PKey::RSA.new(public_key)

    signature = private.sign(common[:digest_func], message)
    encrypted = public.public_encrypt(message)

    hmac_key = SecureRandom.hex(64)
    hmac     = OpenSSL::HMAC.hexdigest("SHA256", hmac_key, encrypted)

    {
      encrypted: encrypted,
      hmac: hmac
    }
  end

  def self.decrypt(private_key, encrypted_message)
    private   = OpenSSL::PKey::RSA.new(private_key)
    decrypted = private.private_decrypt(encrypted_message)
  end

  private

  def self.common
    {
    	:key_length  => 4096,
    	:digest_func => OpenSSL::Digest::SHA256.new
    }
  end

end
