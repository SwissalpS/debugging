# debugging
random minetest debugging tool collection

used debughud while inspecting technic network-ng stuff, example:
```lua
DEBUGHUD_CALLBACK = function(player, pos)
       if not pos then DEBUGHUD(player, "") return end
       local node = minetest.get_node(pos)
       local net = technic.pos2network(pos)
       local swpos = net and technic.network2sw_pos(net)
       local swpos = swpos and minetest.pos_to_string(swpos) or "NO SW"
       net = net and base36(net)
       DEBUGHUD(player, string.format("%s POS: %s NET: %s SW: %s",node.name, minetest.pos_to_string(pos),net,swpos))
end
```
