require File.expand_path('../../../../consulkv', __FILE__)

Puppet::Functions.create_function(:'consulkv::get_service_nodes') do
  dispatch :get_service_nodes do
    required_param 'String[1]', :host
    required_param 'String[1]', :service
    return_type 'Any'
  end

  def get_service_nodes(host, service)
    ConsulKV.api(host) do |http|
      response = http.get("/v1/catalog/service/#{service}")

      if response.code == "200"
        JSON.parse(response.body)
      elsif response.code == "404"
        nil
      else
        raise ConsulKV::PuppetFail.new("Getting '#{service}' returned" +
          " '#{response.code} #{response.message}' (expected 200 or 404)")
      end
    end
  end
end
