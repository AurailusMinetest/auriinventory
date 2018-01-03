ainv = {}

ainv.screens = {}
function ainv.register_inventory_screen(name, gen_func, tab)
	table.insert(ainv.screens, {
		name = name,
		gen = gen_func,
		tab = tab
	})

	if tab then
		ainv.register_callback("*", function(player, fields)
			for field, val in pairs(fields) do
				if string.sub(field, 1, string.len("tab_")) == "tab_" then
					local screen = string.sub(field, string.len("tab_") + 1,string.len(field))
					ainv.playerdata[player:get_player_name()].inventory_tab = screen
					ainv.reloadInventory(player)
				end
			end
		end)		
	end
end

ainv.callbacks = {}
function ainv.register_callback(screen, func)
	table.insert(ainv.callbacks, {
		screen = screen,
		func = func
	})
end

local path = minetest.get_modpath("auriinventory")

dofile(path .. "/fragments/init.lua")
dofile(path .. "/formspecs/formspec_main.lua")
dofile(path .. "/sidebar/init.lua")

ainv.register_inventory_screen("main", ainv.gen_formspec_main, {
	name = "Main",
	image = "auriinventory_tab_icon_04.png",
	image_hover = "auriinventory_tab_icon_05.png"
})

ainv.armor = minetest.get_modpath("3d_armor") ~= nil

ainv.playerdata = {}

if ainv.armor then
	armor:register_on_update(function (player)
		ainv.reloadInventory(player)
	end)
end

--Run after all mods are loaded
minetest.after(0.001, function()
	ainv.load_recipebook_and_reload()
end)

minetest.register_on_joinplayer(function (player)
	ainv.playerdata[player:get_player_name()] = {
		sidebar_page = 0, 				--Current page in sidebar
		inventory_tab = 'main',		--Current inventory screen

		cheating = 1,							--Whether to spawn in items or recipe them
		
		lastspawntime = nil, 			--When last spawned item was, for D-Click
		lastspawn = 0, 						--Last spawned item, for D-Click
		filledstack = false,			--Determine if needed to fill existing stack on D-Click

		recipe_item = -1,					--Item to show recipe for, -1 = nothing
		recipe_index = 1,					--Current recipe to show (in case of multiple)
	}

	ainv.loadInventory(player)
end)

function ainv.gen_formspec (screen, player)
	for k,v in pairs(ainv.screens) do
		if v.name == screen then
			return v.gen(player)
		end
	end
end

function ainv.loadInventory (player)
	local name = player:get_player_name();

	player:get_inventory():set_list("recipepreview", {})
	player:get_inventory():set_size("recipepreview", 10)

	if ainv.armor then
		if armor.def[name].init_time == 0 then
			print("[AuriInventory] Armor not Initialized... Waiting")
			minetest.after(0.2, ainv.loadInventory, player)
			return
		end
	end

	player:set_inventory_formspec(ainv.gen_formspec('main', player))
	-- player:set_inventory_formspec(ainv.screens['main'].gen(player))
end

function ainv.reloadInventory(player)
	if player:is_player() and ainv.playerdata[player:get_player_name()] then
		local tab = ainv.playerdata[player:get_player_name()].inventory_tab

		player:set_inventory_formspec(ainv.gen_formspec(tab, player))
		-- player:set_inventory_formspec(ainv.screens[tab].gen(player))
	end
end

function ainv.formspec_base(player)
	local fs = [[
		size[22,8;]
		bgcolor[#0005;true]
		listcolors[#cccccc55;#ffffff55;#888888;#33333399;#ffffff]
		container[4,0]
		box[-0.25,-0.25;12,8.7;#222222]
		box[-0.25,-0.25;12,8.7;#222222]
		box[-0.25,-0.25;12,8.7;#222222]
		box[-0.25,-0.25;12,8.7;#222222]
		box[-0.25,-0.25;12,8.7;#222222]
		box[-0.25,-0.25;12,8.7;#222222]
	]]
	return fs
end

function ainv.formspec_base_end(player)
	local fs = "container_end[]"
	fs = fs .. ainv.create_sidebar_menu(player)
	return fs
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	print(dump(fields))
	
	local screen = ainv.playerdata[player:get_player_name()].inventory_tab

	if formname == "" then
		for _,table in pairs(ainv.callbacks) do
			if table.screen == screen or table.screen == "*" then
				if table.func(player, fields) == false then
					break
				end
			end
		end

		-- if fields.messages then
		-- 	local datatable = minetest.explode_textlist_event(fields.messages)
		-- 	if datatable.type == "CHG" then
		-- 		player:set_inventory_formspec(ainv.gen_formspec_messaging(player, math.ceil(datatable.index / 2)))
		-- 		return
		-- 	end
		-- end

		-- if fields.recipe_close then
		-- 	player:get_inventory():set_list("recipepreview", {})
  -- 		player:set_attribute("recipepreview_item", "")
		-- 	ainv.reloadInventory(player)
		-- end

		-- if fields.recipe_next then
		-- 	player:set_attribute("recipepreview_index", tonumber(player:get_attribute("recipepreview_index")) + 1)
		-- 	ainv.show_recipe_preview(player, player:get_attribute("recipepreview_item"))
		-- 	ainv.reloadInventory(player)
		-- end

		-- if fields.recipe_prev then
		-- 	player:set_attribute("recipepreview_index", tonumber(player:get_attribute("recipepreview_index")) - 1)
		-- 	ainv.show_recipe_preview(player,  player:get_attribute("recipepreview_item"))
		-- 	ainv.reloadInventory(player)
		-- end
	end
end)