--Spawn items--
ainv.register_callback("*", function(player, fields)
	for field, val in pairs(fields) do
	
		if string.sub(field, 1, string.len("sidebar_item_")) == "sidebar_item_" then

			local ind = tonumber(string.sub(field, string.len("sidebar_item_") + 1,string.len(field)))
			local name = player:get_player_name()

			if ainv.playerdata[name].cheating then
				if minetest.check_player_privs(player, "give") then

					--Determine how many items to give player
					local stack = 1;

					if not ainv.playerdata[name].lastspawntime then
						ainv.playerdata[name].lastspawntime = minetest.get_us_time()/1000000.0;

					elseif ainv.playerdata[name].lastspawntime + 0.3 > minetest.get_us_time()/1000000.0 then
						
						local fcompensation = 0
						if ainv.playerdata[name].filledstack == false then
							fcompensation = 1
							ainv.playerdata[name].filledstack = true
						end
						if ainv.playerdata[name].lastspawn == ind then
							stack = minetest.registered_items[ainv.items[ind]].stack_max - fcompensation
						end
					end

					--Add items to inventory
					player:get_inventory():add_item("main", ainv.items[ind] .. " " .. stack)

					if stack == 1 then
						ainv.playerdata[name].filledstack = false
					end
					ainv.playerdata[name].lastspawn = ind
					ainv.playerdata[name].lastspawntime = minetest.get_us_time()/1000000.0;
				end
			else --Recipe mode
				ainv.playerdata[name].recipe_item = ind
				ainv.playerdata[name].recipe_index = 1

				ainv.show_recipe_preview(player)
				ainv.reloadInventory(player)
			end
			return false
		end
	end
end)

--Pagination--
ainv.register_callback("*", function(player, fields)
	if fields.togglecheat or fields.togglecheat_label then
		ainv.playerdata[player:get_player_name()].cheating = not ainv.playerdata[player:get_player_name()].cheating
		ainv.reloadInventory(player)
		return false
	end
end)

--Pagination--
ainv.register_callback("*", function(player, fields)
	if fields.sidebar_nextpage then

		local data = ainv.playerdata[player:get_player_name()]["sidebar_page"]
		ainv.playerdata[player:get_player_name()]["sidebar_page"] = 
			math.min(data + 1, math.floor((ainv.itemcount-1)/ainv.sidebar_inv_size))
		ainv.reloadInventory(player)
		return false

	elseif fields.sidebar_prevpage then

		local data = ainv.playerdata[player:get_player_name()]["sidebar_page"]
		ainv.playerdata[player:get_player_name()]["sidebar_page"] = math.max(data - 1, 0)
		ainv.reloadInventory(player)
		return false

	elseif fields.sidebar_firstpage then

		ainv.playerdata[player:get_player_name()]["sidebar_page"] = 0
		ainv.reloadInventory(player)
		return false

	elseif fields.sidebar_lastpage then

		ainv.playerdata[player:get_player_name()]["sidebar_page"] = 
			math.floor((ainv.itemcount-1)/ainv.sidebar_inv_size)
		ainv.reloadInventory(player)
		return false

	end
end)