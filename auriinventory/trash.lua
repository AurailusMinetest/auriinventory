--Register Inventory

local bag_inv = minetest.create_detached_inventory("trash", {
	on_put = function(inv, listname, index, stack, player)
		inv:remove_item(listname, stack)
	end,
})

bag_inv:set_size("trashcan", 1)

ainv.fragments["trash"] = [[
	list[detached:trash;trashcan;10,3;1,1;0]
	image[10,3.03;1,1;auriinventory_btn_icon_4.png]
]]