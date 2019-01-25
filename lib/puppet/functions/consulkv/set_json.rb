require 'json'

Puppet::Functions.create_function(:'consulkv::set_json') do
  dispatch :set_json do
    required_param 'String[1]', :host
    required_param 'String[1]', :key
    required_param 'Any', :value
    optional_param 'Boolean', :use_ssl
  end

  def set_json(host, key, value, use_ssl = true)
    call_function('consulkv::set', host, key, value.to_json(), use_ssl)
  end
end
