ainv_homes = {}

local path = minetest.get_modpath("ainv_homes")

dofile(path .. "/formspecs/formspec_homes.lua")
dofile(path .. "/formspecs/formspec_addhome.lua")

ainv.register_inventory_screen("homes", ainv_homes.gen_formspec_homes, {
	name = "Homes",
	image = "auriinventory_tab_icon_10.png",
	image_hover = "auriinventory_tab_icon_11.png"
})

ainv.register_callback("homes", function (player, fields)
	for i = 1, 6 do
		if fields["home" .. tostring(i)] ~= nil then
			local hashome = (player:get_attribute("home_" .. i .. "_pos") ~= nil)
			if not hashome then
				player:set_attribute("home_editing", i)
				minetest.show_formspec(player:get_player_name(), "addhome", ainv_homes.gen_formspec_addhome(player, tostring(i)))
			else
				player:set_pos(minetest.deserialize(player:get_attribute("home_" .. i .. "_pos")))
			end
			return false
		elseif fields["delhome" .. tostring(i)] ~= nil then
			player:set_attribute("home_" .. i .. "_pos", nil)
			player:set_attribute("home_" .. i .. "_name", nil)
			ainv.reloadInventory(player)
			return false
		end
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "addhome" then
		if fields.homename ~= nil then
			player:set_attribute("home_" .. player:get_attribute("home_editing") .. "_pos", minetest.serialize(player:getpos()))
			player:set_attribute("home_" .. player:get_attribute("home_editing") .. "_name", fields.homename)
		end
		ainv.reloadInventory(player)
		return
	end
end)

minetest.register_chatcommand("setmaxhomes", {
	params = "<amount>",
	description = "Set the maximum allowed homes.",
	privs = {server},
	func = function (name, param)
		if tonumber(param) then
			minetest.settings:set("maxhomes", tonumber(param))
		else
			minetest.chat_send_player(name, "Please supply a number.")
		end
	end,
})
