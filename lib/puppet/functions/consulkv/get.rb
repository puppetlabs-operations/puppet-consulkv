require File.expand_path('../../../../consulkv', __FILE__)

Puppet::Functions.create_function(:'consulkv::get') do
  dispatch :get do
    param 'String[1]', :host
    param 'String[1]', :key
    return_type 'Optional[String]'
  end

  def get(host, key)
    ConsulKV.api(host) do |http|
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
