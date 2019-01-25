require File.expand_path('../../../../consulkv', __FILE__)

Puppet::Functions.create_function(:'consulkv::get') do
  dispatch :get do
    required_param 'String[1]', :host
    required_param 'String[1]', :key
    optional_param 'Boolean', :use_ssl
    return_type 'Optional[String]'
  end

  def get(host, key, use_ssl = true)
    ConsulKV.api(host, use_ssl) do |http|
      response = http.get("/v1/kv/#{key}?raw=true")

      if response.code == "200"
        response.body
      elsif response.code == "404"
        nil
      else
        raise ConsulKV::PuppetFail.new("Getting '#{key}' returned" +
          " '#{response.code} #{response.message}' (expected 200 or 404)")
      end
    end
  end
end
