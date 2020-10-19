

--[[ Misusing JD markers :)
			jumpdrive.show_marker(pos,0,"red")
			jumpdrive.show_marker(sw_pos,0,"blue")
			print(string.format("Overload at %s, switch: %s old network: %.30g new network: %.30g",
				minetest.pos_to_string(pos), minetest.pos_to_string(sw_pos),
				net_id_old, net_id_new
			))

]]--- DEBUG HUD

local HUDS = {}
function DEBUGHUD(player, text)player:hud_change(HUDS[player:get_player_name()], "text", text or "")end
minetest.register_on_leaveplayer(function(player)HUDS[player:get_player_name()]=nil end)
minetest.register_on_joinplayer(function(player)
	if HUDS[player:get_player_name()] then return end
	HUDS[player:get_player_name()] = player:hud_add({
		hud_elem_type = "text",
		position  = {x = 0.5, y = 0.6},
		offset    = {x = 0, y = 0},
		text      = "DEBUG HUD",
		alignment = 0,
		scale     = { x = 300, y = 90},
		size      = { x = 100, y = 100},
		number    = 0xFF3030,
	})
end)
DEBUGHUD_CALLBACK = function(player, pos) DEBUGHUD(player, pos and minetest.get_node(pos).name or "") end
minetest.register_globalstep(function()
	for _,player in pairs(minetest.get_connected_players()) do
		local eye = vector.add(player:get_pos(), {x=0,y=player:get_properties().eye_height,z=0}) -- player:get_eye_offset()
		local look = vector.multiply(player:get_look_dir(), 4)
		ray = Raycast(eye, vector.add(eye, look), false, false)
		local thing = ray:next()
		while thing and thing.ref == player do thing = ray:next() end
		local pos = nil
		if thing and thing.under and thing.type == "node" then
			local under = minetest.get_node_or_nil(thing.under)
			if under and under.name ~= "air" then
				pos = thing.under
			end
		end
		DEBUGHUD_CALLBACK(player, pos)
	end
end)

--[[ TIMING

local t
local n
function t1(name)
	n = name
	t = minetest.get_us_time()
end

function t2()
	local d = minetest.get_us_time() - t
	print(string.format("Timeit %s Took: %dus", n, d))
	return d
end ]]--

-- BASE 36 ENCODING

local alpha = {0,1,2,3,4,5,6,7,8,9,"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
function base36(num)
	if num < 36 then return alpha[num + 1] end
	local result = ""
	while num ~= 0 do
		result = alpha[(num % 36) + 1] .. result
		num = math.floor(num / 36)
	end
	return result
end
