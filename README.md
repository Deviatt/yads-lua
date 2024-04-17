# Yet Another Data Serializer
This's a Lua serializer that's both fast and compact. It encodes both primitive and complex Lua data using binary encoding.
The serializer was designed for LuaJIT, but it also supports Lua. However, 100% performance's not guaranteed.

The goal of this project's to make a faster and more compact serializer.

### API
Calls for serialization:
```lua
yads.serial(any)
yads.serialize(any)
yads.encode(any)
```

Calls for deserialization:
```lua
yads.deserial(any)
yads.deserialize(any)
yads.decode(any)
```
### [Tests](https://github.com/Deviatt/yads-lua/tree/master/tests)