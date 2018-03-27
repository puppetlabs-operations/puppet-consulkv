require 'json'

Puppet::Functions.create_function(:'consulkv::get_json') do
  dispatch :get_json do
    param 'String[1]', :host
    param 'String[1]', :key
    return_type 'Any'
  end

  def get_json(host, key)
    raw_value = call_function('consulkv::get', host, key)
    if raw_value.nil?
      nil
    else
      JSON.parse(raw_value)
    end
  end
end
