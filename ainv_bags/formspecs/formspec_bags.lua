function ainv_bags.gen_formspec_bags (player)
	if not minetest.get_inventory({type = "detached", name = player:get_player_name() .. "_bags"}) then
		ainv_bags.gen_bag_inventories(player)
	end

	local fs = [[
		size[22,8;]
		bgcolor[#0005;true]
		listcolors[#cccccc55;#ffffff55;#888888;#33333399;#ffffff]
		container[2,0]
		box[-0.25,-0.25;14.3,8.7;#222222]
		box[-0.25,-0.25;14.3,8.7;#222222]
		box[-0.25,-0.25;14.3,8.7;#222222]
		box[-0.25,-0.25;14.3,8.7;#222222]
		box[-0.25,-0.25;14.3,8.7;#222222]
		box[-0.25,-0.25;14.3,8.7;#222222]
	]]

	local inv = player:get_inventory()
	if inv:get_stack("bag", 21):get_name() == "ainv_bags:bag" then
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

	if inv:get_stack("bag", 42):get_name() == "ainv_bags:bag" then
		fs = fs .. [[
			label[3,0;Bag 2]
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;3,0.5;7,3;21]
		]]
	else
		fs = fs .. [[
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;6,1.5;1,1;41]
			label[6.17,2.3;Insert]
			label[6.21,2.6;Bag]
		]]
	end

	if inv:get_stack("bag", 63):get_name() == "ainv_bags:bag" then
		fs = fs .. [[
			label[11.2,0.7;Bag 3]
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;11.1,1.2;3,7;42]
		]]
	else
		fs = fs .. [[
			list[detached:]] .. player:get_player_name() .. [[_bags;bag;12,3.5;1,1;62]
			label[12.17,4.3;Insert]
			label[12.21,4.6;Bag]
		]]
	end

	fs = ainv.append_fragment(fs, "maininv")
	fs = ainv.append_fragment(fs, "trash")
	fs = ainv.append_fragment(fs, "back")

	-- ListRing
	fs = fs .. [[
		listring[current_player;main]
		listring[current_player;bag]
	]]

	fs = fs .. ainv.formspec_base_end(player)
	return fs
end