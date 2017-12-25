local path = minetest.get_modpath("auriinventory")

dofile(path .. "/inventories/formspec_messaging.lua")

minetest.register_chatcommand("mail", {
	params = "<player> <title> <message>",
	description = "Send a private message to a player using the Auriinventory Mailing System(tm)",
	func = function(sender, param)
		if param and string.find(param, " ", 1) and string.find(param, " ", 2) then
			local to = string.sub(param, 1, string.find(param, " ", 1) - 1)
			local title = string.sub(param, string.find(param, " ", 1) + 1, string.find(param, " ", string.find(param, " ", 1) + 1) - 1)
			local message = string.sub(param, string.find(param, " ", string.find(param, " ", 1) + 1) + 1, string.len(param))

			local player = minetest.get_player_by_name(to)
			if player and player:is_player() then
				local mtable = minetest.deserialize(player:get_attribute("messages"))
				if not mtable then mtable = {} end
				table.insert(mtable, {from = to, title = title, message = message})
				print(dump(mtable))
				player:set_attribute("messages", minetest.serialize(mtable))
			else
				minetest.chat_send_player(sender, "-!- Player doesn't exist or has never logged in before.")
			end
		else
			minetest.chat_send_player(sender, "-!- Improper Usage: /mail <player> <title> <message>")
		end
	end,
})
