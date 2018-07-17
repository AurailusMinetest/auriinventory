--Use this to get the name of the first item in a given group or list of groups, or "" if no item is found in the given group
local function get_first_item_in_group(groupname)
	local groupnametable = {}
	local lastCommaIndex = 0

	for i = 2, #groupname do
		if groupname:sub(i,i) == ',' then
			table.insert(groupnametable, groupname:sub(lastCommaIndex+1, i-1))
			lastCommaIndex = i
		end
	end
	if lastCommaIndex ~= #groupname then table.insert(groupnametable, groupname:sub(lastCommaIndex+1)) end

	for k,v in pairs(minetest.registered_items) do
		local still_in_all_groups = true

		for n,g in pairs(groupnametable) do
			if minetest.get_item_group(k, g) == 0 then
				still_in_all_groups = false
			end
		end

		if still_in_all_groups then
			return k
		end
	end

	return ""
end

function ainv.show_recipe_preview(player)
	local playerdata = ainv.playerdata[player:get_player_name()]
	local item = ainv.items[playerdata.recipe_index]
	local recipes = minetest.get_all_craft_recipes(item)

	ainv.playerdata[player:get_player_name()]["recipe_page"] = 1

	if recipes and #recipes > 0 then
		for h = 1, #recipes do
			ainv.playerdata[player:get_player_name()].recipe_items[h] = {{}, {}, {}}

			local recipe_width = recipes[h].width
			if recipes[h] then
				if recipe_width > 3 then
					--Give up on life
					return false
				end

				if #recipes[h].items > 0 then
					for i, v in pairs(recipes[h].items) do
						if v then
							if recipe_width and recipe_width ~= 0 then
								ainv.playerdata[player:get_player_name()].recipe_items[h][math.ceil(i / recipe_width)][(i-1) % recipe_width + 1] = v
							else
								ainv.playerdata[player:get_player_name()].recipe_items[h][math.ceil(i / 3)][(i-1) % 3 + 1] = v
							end
						end
					end
					
					ainv.reloadInventory(player)
				end
			end
		end
	else
	  	ainv.playerdata[player:get_player_name()].recipe_index = -1
		ainv.playerdata[player:get_player_name()].recipe_items = {}
	end
end

function ainv.gen_formspec_recipe(player)
	local recipe_index = ainv.playerdata[player:get_player_name()]["recipe_page"] or 1
	local fs = "size[3,3]"
	local player_inv = player:get_inventory()
	local recipe_to_display = ainv.playerdata[player:get_player_name()].recipe_items or {}
	local recipe_amount = #recipe_to_display

	if #recipe_to_display > 0 and recipe_to_display[recipe_index] and #recipe_to_display[recipe_index] > 0 then
		for i = 1, 3 do
			for n = 1, 3 do
				local itemname
				local item_is_group = false

				if recipe_to_display[recipe_index][i] and recipe_to_display[recipe_index][i][n] then
					itemname = recipe_to_display[recipe_index][i][n]
				else
					itemname = ""
				end
				
				--Make Tooltip
				local tooltip = itemname
				if minetest.registered_items[itemname] and minetest.registered_items[itemname].description ~= "" then
					tooltip = minetest.registered_items[itemname].description .. "\n(" .. itemname .. ")"
				end

				--minetest.log("itemname = "..itemname)

				if itemname:sub(1,6) == "group:" then
					local itemsub = itemname:sub(7)
					itemname = get_first_item_in_group(itemsub)
					item_is_group = true
				end

				--minetest.log("real item name = "..itemname)

				fs = fs.."image_button["..(n-0.5)..","..(i-1.0)..";1.0,1.0;auriinventory_emptyinventoryslot.png;recprevbutton_"..((i-1)*3+n)..";;;]"
						.."item_image["..(n-0.5)..","..(i-1.0)..";1.0,1.0;"..itemname.."]"

				if item_is_group then
					fs = fs.."image["..(n-0.5)..","..(i-1.0)..";1.0,1.0;auriinventory_group.png]"
				end

				fs = fs.."tooltip[recprevbutton_"..((i-1)*3+n)..";".. tooltip..";#33333399;#fff]"
			end
		end

		fs = fs..
			"image_button[0.5,3.0;0.75,1.0;auriinventory_recipebook_icon_0.png;recipepreview_prev;;true;false;auriinventory_recipebook_icon_1.png]"..
			"image_button[2.75,3.0;0.75,1.0;auriinventory_recipebook_icon_2.png;recipepreview_next;;true;false;auriinventory_recipebook_icon_3.png]"..
			"label[1.5,3.0;Recipe]"..
			"label[1.75,3.5;"..(recipe_index).."/"..(recipe_amount).."]"..
			"image_button[0.7,4.0;2.7,0.6;auriinventory_blank.png;quickcraft;Quick Craft;true;true;auriinventory_blank.png]"
	end

	return fs
end
