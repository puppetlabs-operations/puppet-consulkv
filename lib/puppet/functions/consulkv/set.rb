require File.expand_path('../../../../consulkv', __FILE__)

Puppet::Functions.create_function(:'consulkv::set') do
  dispatch :set do
    required_param 'String[1]', :host
    required_param 'String[1]', :key
    required_param 'Optional[String]', :value
    optional_param 'Boolean', :use_ssl
  end

  def set(host, key, value, use_ssl = true)
    ConsulKV.api(host, use_ssl) do |http|
      if value.nil?
        action = "Deleting"
        request = Net::HTTP::Delete.new("/v1/kv/#{key}")
      else
        action = "Setting"
        request = Net::HTTP::Put.new("/v1/kv/#{key}")
        request['Content-Type'] = 'application/octet-stream'
        request.body = value
      end

      response = http.request(request)

      if response.code == "200"
        response.body
      else
        raise ConsulKV::PuppetFail.new("${action} '#{key}' returned" +
          " '#{response.code} #{response.message}' (expected 200)")
      end
    end
  end
end
