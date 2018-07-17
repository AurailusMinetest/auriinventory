--Calculate Sidebar size
ainv.sidebar_width = 9
ainv.sidebar_height = 10
ainv.sidebar_inv_size = ainv.sidebar_width * ainv.sidebar_height

local xorigin = -2.0

function ainv.create_sidebar_menu(player, searchbar, recipe_fs)
	if not ainv.items_loaded then return "" end

	--Item Iterator
	local page = ainv.playerdata[player:get_player_name()].sidebar_page
	local index = page * ainv.sidebar_inv_size + 1

	--Cheat mode button
	local cheat_button =
	"image_button["..(xorigin-0.05)..",0.01;0.5,0.5;auriinventory_small_icon_06.png;togglecheat;;true;false;auriinventory_small_icon_07.png]" .. --Cheat button
	"image_button["..(xorigin+0.35)..",0.05;1.8,0.5;auriinventory_blank.png;togglecheat_label;Recipe Mode;true;false;auriinventory_blank.png]"   --Cheat label
	
	if ainv.playerdata[player:get_player_name()].cheating then
		cheat_button =
		"image_button["..(xorigin-0.05)..",0.01;0.5,0.5;auriinventory_small_icon_08.png;togglecheat;;true;false;auriinventory_small_icon_09.png]" .. --Recipe button
		"image_button["..(xorigin+0.35)..",0.05;1.8,0.5;auriinventory_blank.png;togglecheat_label;Cheat Mode;true;false;auriinventory_blank.png]"    --Recipe label
	end

	local fs = 
	"container[18,0]" .. 						    --Container
	cheat_button ..
	"image_button["..(xorigin+3.15)..",0.0;2.7,0.6;auriinventory_blank.png;togglesearch;Toggle Search;true;true;auriinventory_blank.png]" --Search button

	--Create buttons
	for j = 0, ainv.sidebar_height - 1 do
		for i = 0, ainv.sidebar_width - 1 do

			--Check if item exists
			if ainv.items[index] then

				--Get item name
				local name = ainv.items[index]

				--Make Tooltip
				local tooltip = name
				if minetest.registered_items[name].description ~= "" then
					tooltip = minetest.registered_items[name].description .. "\n(" .. name .. ")"
				end

				if ainv.playerdata[player:get_player_name()].cheating then
					tooltip = tooltip .. "\n\nClick to Spawn\nDouble-Click for Stack"
				else
					tooltip = tooltip .. "\n\nClick to view Recipe"
				end

				--Add elements
				fs = fs .. 
				--Invisible button
				"image_button[" .. (xorigin - 0.12 + i*0.65) .. "," .. (0.53 + j*0.7) .. ";0.8,0.8;" ..
				"auriinventory_blank.png;sidebar_item_" .. index .. ";;true;false;auriinventory_hover.png]" ..
				--Image for button
				"item_image[" .. (xorigin - 0.13 + i*0.65) .. "," .. (0.53 + j*0.7) .. ";0.8,0.8;" .. name .. "]" ..
				--Tooltip for button
				"tooltip[sidebar_item_" .. index .. ";" .. tooltip .. ";#33333399;#fff]"
				
				index = index + 1
			else break end

		end
	end

	--Bottom navigation
	fs = fs ..
	"image_button[" .. (xorigin - 0.1) .. ",7.46;0.75,1.0;auriinventory_recipebook_icon_6.png;sidebar_firstpage;;true;false;auriinventory_recipebook_icon_7.png]" ..
	"image_button[" .. (xorigin + 0.5) .. ",7.46;0.75,1.0;auriinventory_recipebook_icon_0.png;sidebar_prevpage;;true;false;auriinventory_recipebook_icon_1.png]" ..
	"image_button[" .. (xorigin + 1.45) .. ",7.5;2.9,1;auriinventory_blank.png;regitemslabel;Registered Items (" .. page+1 .. "/" 
		.. math.floor((ainv.itemcount-1)/ainv.sidebar_inv_size)+1 .. ");true;false;auriinventory_blank.png]" ..
	"image_button[" .. (xorigin + 4.5) .. ",7.46;0.75,1.0;auriinventory_recipebook_icon_2.png;sidebar_nextpage;;true;false;auriinventory_recipebook_icon_3.png]" ..
	"image_button[" .. (xorigin + 5.1) .. ",7.46;0.75,1.0;auriinventory_recipebook_icon_8.png;sidebar_lastpage;;true;false;auriinventory_recipebook_icon_9.png]" ..
	"container_end[]" --End container

	if player:get_inventory():get_list("recipepreview") then
		fs = fs .. ainv.gen_formspec_recipe(player)
	end

	return fs
end
