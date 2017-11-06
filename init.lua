auriinventory = {}

local path = minetest.get_modpath("auriinventory")

auriinventory.armor = minetest.get_modpath("3d_armor") ~= nil

dofile(path .. "/hooks.lua")
dofile(path .. "/trash.lua")
dofile(path .. "/fragments.lua")
dofile(path .. "/inventories/formspec_main.lua")
dofile(path .. "/bags.lua")
dofile(path .. "/teleport.lua")
dofile(path .. "/skins.lua")
dofile(path .. "/messaging.lua")
dofile(path .. "/recipebook.lua")

auriinventory.items = {}
auriinventory.itemcount = 0

minetest.after(2, function()
	auriinventory.load_recipebook_and_reload()
end)

function auriinventory.loadInventory(player)
	local name = player:get_player_name();

	player:get_inventory():set_width("craft", 3)
	player:get_inventory():set_size("craft", 9)
	player:get_inventory():set_size("main", 9*4)

	player:get_inventory():set_list("recipepreview", {})
	player:get_inventory():set_size("recipepreview", 10)

	if auriinventory.armor then
		if armor.def[name].init_time == 0 then
			print("Armor not intitialized... delaying")
			minetest.after(0.5, auriinventory.loadInventory, player)
			return
		end
	end

	player:set_inventory_formspec(auriinventory.gen_formspec_main(player))
end

function auriinventory.reloadInventory(player)
	local attr = player:get_attribute("screen")
	if attr == "bags" then
		player:set_inventory_formspec(auriinventory.gen_formspec_bags(player))
		player:set_attribute("screen", "bags")
		return
	elseif attr == "main" then
		player:set_inventory_formspec(auriinventory.gen_formspec_main(player))
		player:set_attribute("screen", "main")
	elseif attr == "teleport" then
		player:set_inventory_formspec(auriinventory.gen_formspec_teleport(player))
		player:set_attribute("screen", "teleport")
	elseif attr == "skins" then
		player:set_inventory_formspec(auriinventory.gen_formspec_skins(player))
		player:set_attribute("screen", "skins")
	elseif attr == "messaging" then
		player:set_inventory_formspec(auriinventory.gen_formspec_messaging(player))
		player:set_attribute("screen", "messaging")
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	print(dump(fields))

	if formname == "" then
		if fields.bags then
			player:set_inventory_formspec(auriinventory.gen_formspec_bags(player))
			player:set_attribute("screen", "bags")
			return
		elseif fields.main then
			player:set_inventory_formspec(auriinventory.gen_formspec_main(player))
			player:set_attribute("screen", "main")
			return
		elseif fields.teleport then
			player:set_inventory_formspec(auriinventory.gen_formspec_teleport(player))
			player:set_attribute("screen", "teleport")
			return
		elseif fields.skins then
			player:set_inventory_formspec(auriinventory.gen_formspec_skins(player))
			player:set_attribute("screen", "skins")
			return
		elseif fields.messaging then
			player:set_inventory_formspec(auriinventory.gen_formspec_messaging(player))
			player:set_attribute("screen", "messaging")
			return
		end

		for i = 1, 6 do
			if fields["home" .. tostring(i)] ~= nil then
				local hashome = (player:get_attribute("home_" .. i .. "_pos") ~= nil)
				if not hashome then
					player:set_attribute("home_editing", i)
					minetest.show_formspec(player:get_player_name(), "addhome", auriinventory.gen_formspec_addhome(player, tostring(i)))
				else
					player:setpos(minetest.deserialize(player:get_attribute("home_" .. i .. "_pos")))
				end
				print(i)
				return
			elseif fields["delhome" .. tostring(i)] ~= nil then
				player:set_attribute("home_" .. i .. "_pos", nil)
				player:set_attribute("home_" .. i .. "_name", nil)
				auriinventory.reloadInventory(player)
				return
			end
		end

		if fields.skinlist then
			local datatable = minetest.explode_textlist_event(fields.skinlist)
			if datatable.type == "CHG" then
				auriskins.playerskins[player:get_player_name()] = datatable.index
				auriskins.update_skin(player)
				auriinventory.reloadInventory(player)
				return
			end
		end

		if fields.recipe_close then
			player:get_inventory():set_list("recipepreview", {})
  		player:set_attribute("recipepreview_item", "")
			auriinventory.reloadInventory(player)
		end

		if fields.recipe_next then
			player:set_attribute("recipepreview_index", tonumber(player:get_attribute("recipepreview_index")) + 1)
			auriinventory.show_recipe_preview(player, player:get_attribute("recipepreview_item"))
			auriinventory.reloadInventory(player)
		end

		if fields.recipe_prev then
			player:set_attribute("recipepreview_index", tonumber(player:get_attribute("recipepreview_index")) - 1)
			auriinventory.show_recipe_preview(player,  player:get_attribute("recipepreview_item"))
			auriinventory.reloadInventory(player)
		end

		for k, v in pairs(fields) do
			if string.sub(k,1,string.len("rbook_item_give_")) == "rbook_item_give_" then
				local ind = tonumber(string.sub(k,string.len("rbook_item_give_")+1,string.len(k)))
				if minetest.check_player_privs(player, "give") then
					player:get_inventory():add_item("main", auriinventory.items[ind] .. " 99")
				end
				return
			elseif string.sub(k,1,string.len("rbook_item_recipe_")) == "rbook_item_recipe_" then
				local ind = tonumber(string.sub(k,string.len("rbook_item_recipe_")+1,string.len(k)))
				player:set_attribute("recipepreview_index", 1)
				auriinventory.show_recipe_preview(player, auriinventory.items[ind])
				auriinventory.reloadInventory(player)
			end
		end

		if fields.rbook_nextpage then
			player:set_attribute("rbook_page", player:get_attribute("rbook_page") + 1)
			auriinventory.reloadInventory(player)
		end
		if fields.rbook_prevpage then
			player:set_attribute("rbook_page", player:get_attribute("rbook_page") - 1)
			auriinventory.reloadInventory(player)
		end
		if fields.rbook_lastpage then
			player:set_attribute("rbook_page", 100)
			auriinventory.reloadInventory(player)
		end
		if fields.rbook_firstpage then
			player:set_attribute("rbook_page", 0)
			auriinventory.reloadInventory(player)
		end
		
		return
	elseif formname == "addhome" then
		if fields.homename ~= nil then
			player:set_attribute("home_" .. player:get_attribute("home_editing") .. "_pos", minetest.serialize(player:getpos()))
			player:set_attribute("home_" .. player:get_attribute("home_editing") .. "_name", fields.homename)
		end
		auriinventory.reloadInventory(player)
		return
	end

end)