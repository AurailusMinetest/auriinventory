function ainv.show_recipe_preview(player)
	local playerdata = ainv.playerdata[player:get_player_name()]
	local item = ainv.items[playerdata.recipe_item]

	local recipes = minetest.get_all_craft_recipes(item)
	if recipes then
		player:get_inventory():set_stack("recipepreview", 10, item)

		if recipes[playerdata.recipe_index] then

			if recipes[playerdata.recipe_index].width > 3 then
				--Give up on life
				return false
			end

			local grid = {{}, {}, {}}

			if #recipes[playerdata.recipe_index].items > 0 then
				for i, v in pairs(recipes[playerdata.recipe_index].items) do
					if v then
						if recipes[playerdata.recipe_index].width and recipes[playerdata.recipe_index].width ~= 0 then
							grid[math.ceil(i / recipes[playerdata.recipe_index].width)][(i-1) % recipes[playerdata.recipe_index].width + 1] = v
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

				minetest.show_formspec(player:get_player_name(), "recipe", ainv.gen_formspec_recipe(player))
			end
		end
	else
  	ainv.playerdata[player:get_player_name()].recipe_item = -1
		player:get_inventory():set_list("recipepreview", {})
	end
end