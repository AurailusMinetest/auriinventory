--[[
Ordered table iterator, allow to iterate on the natural order of the keys of a
table.

Example:
]]

local function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

--[[
Register recipebook items
iterate through all items and return an ordered list
]]

function auriinventory.load_recipebook_and_reload()
	local titems = {}
	for key, val in orderedPairs(minetest.registered_items) do
		if key and key ~= "" and key ~= nil then
			if not val.groups.not_in_creative_inventory then
	    	table.insert(titems, key)
				auriinventory.itemcount = auriinventory.itemcount + 1
			end
  	end
	end

	auriinventory.items = titems;

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