local function spairs(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys 
  if order then
    table.sort(keys, function(a,b) return order(t, a, b) end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], t[keys[i]]
    end
  end
end

function auriinventory.load_recipebook_and_reload()
	local titems = {}
	--Get item list oboi
	for key, val in pairs(minetest.registered_items) do
		if key and key ~= "" and key ~= nil then
			if not val.groups.not_in_creative_inventory then
	    	table.insert(titems, key)
				auriinventory.itemcount = auriinventory.itemcount + 1
			end
  	end
	end
	
	for x, y in spairs(titems, function(t, a, b) 
		return string.byte(string.sub(t[b], string.find(t[b], ":", 1)+1, string.find(t[b], ":", 1)+1)) 
		< string.byte(string.sub(t[a], string.find(t[a], ":", 1)+1, string.find(t[a], ":", 1)+1),1)
	end) do
		table.insert(auriinventory.items, y)
	end

	titems = auriinventory.items
	auriinventory.items = {}

	for x, y in spairs(titems, function(t, a, b)
		local ind = 1
		while true do
			local sA = string.sub(t[a], 1, string.find(t[a], ":", 1) - 1)
			local sB = string.sub(t[b], 1, string.find(t[b], ":", 1) - 1)

			if not string.byte(sA, ind) then return true end
			if not string.byte(sB, ind) then return false end

			if ind >= math.max(string.len(sA),string.len(sB)) then return nil end

			if string.byte(sB,ind) > string.byte(sA,ind) then
				return true
			elseif string.byte(sB,ind) < string.byte(sA,ind) then
				return false
			end

			ind = ind + 1
		end
	end) do
		table.insert(auriinventory.items, y)
	end

	print("Auriinventory Initialized with " .. auriinventory.itemcount .. " items.")

	for _,player in ipairs(minetest.get_connected_players()) do
		auriinventory.reloadInventory(player)
	end
end

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