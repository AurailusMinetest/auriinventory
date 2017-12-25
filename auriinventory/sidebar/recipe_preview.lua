function auriinventory.show_recipe_preview(player, item)
  player:set_attribute("recipepreview_item", item)

	local recipes = minetest.get_all_craft_recipes(item)
	if recipes then
		local rind = tonumber(player:get_attribute("recipepreview_index"))
		if rind > #recipes then
			rind = #recipes
			player:set_attribute("recipepreview_index", rind)
		end
		if rind < 1 then
			player:set_attribute("recipepreview_index", 1)
			rind = 1
		end

		if recipes[rind] then
			player:get_inventory():set_stack("recipepreview", 10, item)

			if recipes[rind].width > 3 then
				--Give up on life
				return false
			end

			local grid = {}
			grid[1] = {}
			grid[2] = {}
			grid[3] = {}

			if #recipes[rind].items > 0 then
				for i, v in pairs(recipes[rind].items) do
					if v then
						if recipes[rind].width and recipes[rind].width ~= 0 then
							grid[math.ceil(i / recipes[rind].width)][(i-1) % recipes[rind].width + 1] = v
						else
							grid[math.ceil(i / 3)][(i-1) % 3 + 1] = v
						end
					end
				end
				for i = 1, 3 do
					for j = 1, 3 do
						player:get_inventory():set_stack("recipepreview", (i-1)*3 + j, grid[i][j])
					end
				end
			end
		end
	else
  	player:set_attribute("recipepreview_item", "")
		player:get_inventory():set_list("recipepreview", {})
	end
end