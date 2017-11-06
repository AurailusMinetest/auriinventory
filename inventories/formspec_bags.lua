function auriinventory.gen_formspec_bags (player)
	if not minetest.get_inventory({type = "detached", name = player:get_player_name() .. "_bags"}) then
		auriinventory.gen_bag_inventories(player)
	end

	local fs = [[
		size[15,8;]
		bgcolor[#222222ee;false]
		listcolors[#ffffff33;#ffffff55;#888888;#33333399;#ffffff]
	]]

	local inv = player:get_inventory()
	if inv:get_stack("bag", 21):get_name() == "auriinventory:bag" then
		fs = fs .. [[
			label[0,0.7;Bag 1]
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;-0.1,1.2;3,7;0]
		]]
	else
		fs = fs .. [[
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;1,3.5;1,1;20]
			label[1.17,4.3;Insert]
			label[1.21,4.6;Bag]
		]]
	end

	if inv:get_stack("bag", 42):get_name() == "auriinventory:bag" then
		fs = fs .. [[
			label[4,0;Bag 2]
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;4,0.5;7,3;21]
		]]
	else
		fs = fs .. [[
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;7,1.5;1,1;41]
			label[7.17,2.3;Insert]
			label[7.21,2.6;Bag]
		]]
	end

	if inv:get_stack("bag", 63):get_name() == "auriinventory:bag" then
		fs = fs .. [[
			label[12.2,0.7;Bag 3]
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;12.1,1.2;3,7;42]
		]]
	else
		fs = fs .. [[
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;13,3.5;1,1;62]
			label[13.17,4.3;Insert]
			label[13.21,4.6;Bag]
		]]
	end

	fs = auriinventory.append_fragment(fs, "maininv")
	fs = auriinventory.append_fragment(fs, "trash")
	fs = auriinventory.append_fragment(fs, "back")

	-- ListRing
	fs = fs .. [[
		listring[current_player;main]
		listring[current_player;bag]
	]]

	return fs
end