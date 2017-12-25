--Ordered list code, ignore
local function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end
local function orderedNext(t, state)
    local key = nil
    if state == nil then
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end
    if key then
        return key, t[key]
    end
    t.__orderedIndex = nil
    return
end
local function orderedPairs(t)
    return orderedNext, t, nil
end

--Initialize table data
ainv.items = {}
ainv.itemcount = 0;
ainv.items_loaded = false

-- Iterate through items in the game and return ordered list
function ainv.load_recipebook_and_reload()
	local temp_items = {}
	for key, val in orderedPairs(minetest.registered_items) do
		if key and key ~= "" and key ~= nil then
			if not val.groups.not_in_creative_inventory then
	    	table.insert(temp_items, key)
				ainv.itemcount = ainv.itemcount + 1
			end
        end
	end

	ainv.items = temp_items
    temp_items = {}
	print("Auriinventory Initialized with " .. ainv.itemcount .. " items.")
    ainv.items_loaded = true

	--Reload inventories
	for _,player in ipairs(minetest.get_connected_players()) do
		ainv.reloadInventory(player)
	end
end

local path = minetest.get_modpath("auriinventory") .. "/sidebar"
dofile(path .. "/create_sidebar.lua")
-- dofile(path .. "/recipe_preview.lua")
dofile(path .. "/callbacks.lua")