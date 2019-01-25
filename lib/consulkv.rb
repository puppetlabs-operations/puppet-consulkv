require 'net/http'
require 'openssl'

module ConsulKV
  class PuppetFail < StandardError
  end

  def self.api(host, ssl=true)
    if ssl
      certname = Puppet.settings["certname"]
      certdir = Puppet.settings["certdir"]
      keydir = Puppet.settings["privatekeydir"]

      client_cert = File.read(File.join(certdir, "#{certname}.pem"))
      client_key = File.read(File.join(keydir, "#{certname}.pem"))

      options = {
        use_ssl: true,
        verify_mode: OpenSSL::SSL::VERIFY_PEER,
        ca_file: File.join(certdir, "ca.pem"),
        cert: OpenSSL::X509::Certificate.new(client_cert),
        key: OpenSSL::PKey::RSA.new(client_key)
      }
    end

    Net::HTTP.start(host, 8500, options) do |http|
      yield http
    end
  rescue PuppetFail => e
    call_function('fail', "consulkv[#{host}]: #{e}")
  end
end