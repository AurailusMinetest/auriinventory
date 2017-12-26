ainv_bags = {}

--Load bag formspec
local path = minetest.get_modpath("ainv_bags")
dofile(path .. "/formspecs/formspec_bags.lua")

--Create Bag Item
minetest.register_craftitem("ainv_bags:bag", {
	description = "Item Bag",
	groups = {bag = 1},
	inventory_image = "auriinventory_bag_inventory.png",
	stack_max = 1,
	-- on_use = function(item, player, pointed_thing)
	-- 	local bag = "uh oh"
	-- 	if item:get_metadata() ~= "" then
	-- 		bag = item:get_metadata()
	-- 	else
	-- 		bag = tostring(os.time()) .. tostring(math.random(1000))
	-- 		item:set_metadata(bag)
	-- 	end
	-- 	minetest.chat_send_player(player:get_player_name(), "This bag is " .. bag)
	-- 	return item
	-- end
})

ainv.register_inventory_screen("bags", ainv_bags.gen_formspec_bags, {
	name = "Bags",
	image = "auriinventory_tab_icon_00.png",
	image_hover = "auriinventory_tab_icon_01.png"
})

--Register Inventories
function ainv_bags.gen_bag_inventories(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()

	if not name or not player_inv or not player:getpos() then
		return false
	end

	local bag_inv = minetest.create_detached_inventory(name .. "_bags", {
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			ainv_bags.check_bags(player, index, stack)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
			ainv_bags.check_bags(player, index, stack)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local plaver_inv = player:get_inventory()
			local stack = inv:get_stack(to_list, to_index)
			player_inv:set_stack(to_list, to_index, stack)
			player_inv:set_stack(from_list, from_index, nil)
			ainv_bags.check_bags(player, to_index, stack)
			ainv_bags.check_bags(player, from_index, stack)
		end,
	})

	bag_inv:set_size("bag", 63)
	player_inv:set_size("bag", 63)

	for i = 0, 63 do
		local stack = player_inv:get_stack("bag", i)
		bag_inv:set_stack("bag", i, stack)
	end

	return true
end

function ainv_bags.check_bags(player, index, stack)
	if index == 21 or index == 42 or index == 63 then
		ainv.reloadInventory(player)
	end
end
