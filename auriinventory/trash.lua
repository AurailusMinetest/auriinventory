--Register Inventory

local bag_inv = minetest.create_detached_inventory("trash", {
	on_put = function(inv, listname, index, stack, player)
		inv:remove_item(listname, stack)
	end,
})

bag_inv:set_size("trashcan", 1)