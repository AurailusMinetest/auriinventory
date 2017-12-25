function ainv.gen_formspec_main (player)
	local fs = ainv.formspec_base(player)
	fs = ainv.append_fragment(fs, "maininv")
	fs = fs .. ainv.create_tabs()

	--Armor
	if ainv.armor then
		fs = fs .. [[
			label[3,0;Armor]
			list[detached:]] .. player:get_player_name() .. [[_armor;armor;3,1;1,2;3]
			list[detached:]] .. player:get_player_name() .. [[_armor;armor;4,0.5;1,3;]
		]]

		fs = fs .. [[
			image[5.05,0.35;1.8,3.6;]] .. armor.textures[player:get_player_name()].preview .. [[]
			label[6.7,0;Crafting]

			item_image[9.5,0;1,1;]

			list[current_player;craft;6.7,0.5;3,3;]
			list[current_player;craftpreview;10,1.5;1,1;]
		]]

		if player then
			local inv = player:get_inventory()
			if inv then
				local list = inv:get_list("recipepreview")
				if list then
					fs = fs .. [[
					item_image[7.5,0.5;1,1;]] .. list[1]:get_name() .. [[]
					item_image[8.5,0.5;1,1;]] .. list[2]:get_name() .. [[]
					item_image[9.5,0.5;1,1;]] .. list[3]:get_name() .. [[]

					item_image[7.5,1.5;1,1;]] .. list[4]:get_name() .. [[]
					item_image[8.5,1.5;1,1;]] .. list[5]:get_name() .. [[]
					item_image[9.5,1.5;1,1;]] .. list[6]:get_name() .. [[]

					item_image[7.5,2.5;1,1;]] .. list[7]:get_name() .. [[]
					item_image[8.5,2.5;1,1;]] .. list[8]:get_name() .. [[]
					item_image[9.5,2.5;1,1;]] .. list[9]:get_name() .. [[]
					]]

					if not player:get_attribute("recipepreview_item") then
						player:set_attribute("recipepreview_item", "")
					end
					print("prev" .. player:get_attribute("recipepreview_item"))
					if player:get_attribute("recipepreview_item") ~= "" then
						fs = fs .. [[
							image_button[9.40,0.05;0.5,0.5;auriinventory_small_icon_0.png;recipe_prev;;true;false;auriinventory_small_icon_1.png]
							image_button[9.65,0.05;0.5,0.5;auriinventory_small_icon_2.png;recipe_next;;true;false;auriinventory_small_icon_3.png]
							image_button[10,0.027;0.5,0.5;auriinventory_small_icon_4.png;recipe_close;;true;false;auriinventory_small_icon_5.png]
						]]
					end
				end
			end
		end
	else
		-- No Armor
		fs = fs .. [[
			label[5,0;Crafting]

			list[current_player;craft;5,0.5;3,3;]
			list[current_player;craftpreview;9,1.5;1,1;]
		]]
	end
	fs = ainv.append_fragment(fs, "trash")

	-- Main Inventory
	fs = fs .. [[	
		listring[current_player;main]
		listring[current_player;craft]
	]]

	fs = fs .. ainv.formspec_base_end(player)

	return fs
end