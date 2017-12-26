function auriinventory.gen_formspec_main (player)
	local fs = [[
		size[17,8;]
		bgcolor[#222222ee;false]
		listcolors[#ffffff33;#ffffff55;#888888;#33333399;#ffffff]
	]]

	fs = auriinventory.append_fragment(fs, "tabs")

fs = fs .. [[
	label[5,0;Crafting]

	list[current_player;craft;5,0.5;3,3;]
	list[current_player;craftpreview;9,1.5;1,1;]
]]

	fs = auriinventory.append_fragment(fs, "maininv")
	fs = auriinventory.append_fragment(fs, "trash")
	fs = fs .. auriinventory.gen_fragment_recipebook(player)

	-- Main Inventory
	fs = fs .. [[	
		listring[current_player;main]
		listring[current_player;craft]
	]]

	return fs
end