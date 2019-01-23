# Use the Consul key-value store in Puppet code

This provides a simple way to set and get values from Consul's key-value store.
A simple example:

~~~ puppet
$myobject = { 'some' => 'data' }
consulkv::set_json('consul-app.example.com', 'example/object', $myobject)
~~~

~~~ puppet
notice(consulkv::get_json('consul-app.example.com', 'example/object'))
~~~

This module also allows you to get the nodes associated with a service from
Consul like so:

~~~ puppet
# get nodes providing the Consul service
$data = consulkv::get_service_nodes('consul-app.example.com', 'consul')

# Print the node name and IP of each node
$data.each |$item| {
  notice("${item['Node']} at ${item['Address']}")
}

# Print the entire JSON object returned from the API
# This is useful for seeing what properties are returned (such as 'Node' and 'Address')
notice($data.to_json_pretty)
~~~

## Set up

All functions take a host as their first parameter. That host must be a Consul
server that uses the Puppet CA for its SSL cert.

The functions authenticate themselves with the compiler's Puppet cert.

## Reference

### `consulkv::get($host, $key)`

~~~ puppet
consulkv::get('consul-app.example.com', 'key/path1') == 'rawdata'
~~~

This returns the raw value of a given key as a string. If the key doesn't exist,
it returns `undef`.

### `consulkv::get_json($host, $key)`

~~~ puppet
consulkv::get_json('consul-app.example.com', 'key/path2') == { 'my' => 'data' }
~~~

This parses value of a given key as JSON. If the key doesn't exist,
it returns `undef`. If it can't parse the returned value, it will fail.

### `consulkv::set($host, $key, $string)`

~~~ puppet
consulkv::set('consul-app.example.com', 'key/path1', 'rawdata')
~~~

This sets the value of a key to the passed string.

~~~ puppet
consulkv::set('consul-app.example.com', 'key/path1', undef)
~~~

If `undef` is passed instead of a string, the key is deleted.

### `consulkv::set_json($host, $key, $anything)`

~~~ puppet
consulkv::set_json('consul-app.example.com', 'key/path2', { 'my' => 'data' })
~~~

This serializes the passed object as JSON, then stores it in the key.

### `consulkv::get_service_nodes($host, $service)`

~~~ puppet
consulkv::get_service_nodes('consul-app.example.com', 'consul')
~~~

Returns the parsed JSON response as an array of hashes.


## _Note about SANs:_ 

If your Consul servers' certificates have a SAN of `consul.service.<your consul domain>` you can simplify the examples above like so:

~~~ puppet
# assuming your Consul domain is consul.example.com
consulkv::get_service_nodes('consul.service.consul.example.com', 'some-service-name')
~~~

The advantage of this is you don't have to hard-code your Consul app servers' names in your Puppet code. This does require either allowing anonymous read access OR setting ACL's for where your Puppet queries run.
