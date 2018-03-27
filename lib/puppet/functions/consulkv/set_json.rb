require 'json'

Puppet::Functions.create_function(:'consulkv::set_json') do
  dispatch :set_json do
    param 'String[1]', :host
    param 'String[1]', :key
    param 'Any', :value
  end

  def set_json(host, key, value)
    call_function('consulkv::set', host, key, value.to_json())
  end
end
