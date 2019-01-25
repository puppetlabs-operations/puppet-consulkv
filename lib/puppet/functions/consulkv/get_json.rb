require 'json'

Puppet::Functions.create_function(:'consulkv::get_json') do
  dispatch :get_json do
    required_param 'String[1]', :host
    required_param 'String[1]', :key
    optional_param 'Boolean', :use_ssl
    return_type 'Any'
  end

  def get_json(host, key, use_ssl = true)
    raw_value = call_function('consulkv::get', host, key, use_ssl)
    if raw_value.nil?
      nil
    else
      JSON.parse(raw_value)
    end
  end
end
