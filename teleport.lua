local path = minetest.get_modpath("auriinventory")

dofile(path .. "/inventories/formspec_teleport.lua")
dofile(path .. "/formspecs/formspec_addhome.lua")

minetest.register_chatcommand("setmaxhomes", {
	params = "<amount>",
	description = "Set the maximum allowed homes.",
	privs = {server},
	func = function (name, param)
		if tonumber(param) then
			minetest.setting_set("maxhomes", tonumber(param))
		else
			minetest.chat_send_player(name, "Please supply a number.")
		end
	end,
})