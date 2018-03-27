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

## Set up

All functions take a host as their first parameter. That host must be a Consul
server that uses the Puppet CA for its SSL cert.

The functions authenticate themselves with the compiler's Puppet cert.

## Reference

### `consulkv::get`

~~~ puppet
consulkv::get('consul-app.example.com', 'key/path1') == 'rawdata'
~~~

This returns the raw value of a given key as a string. If the key doesn't exist,
it returns `undef`.

### `consulkv::get_json`

~~~ puppet
consulkv::get_json('consul-app.example.com', 'key/path2') == { 'my' => 'data' }
~~~

This parses value of a given key as JSON. If the key doesn't exist,
it returns `undef`. If it can't parse the returned value, it will fail.

### `consulkv::set`

~~~ puppet
consulkv::set('consul-app.example.com', 'key/path1', 'rawdata')
~~~

This sets the value of a key to the passed string.

~~~ puppet
consulkv::set('consul-app.example.com', 'key/path1', undef)
~~~

If `undef` is passed instead of a string, the key is deleted.

### `consulkv::set_json`

~~~ puppet
consulkv::set_json('consul-app.example.com', 'key/path2', { 'my' => 'data' })
~~~

This serializes the passed object as JSON, then stores it in the key.