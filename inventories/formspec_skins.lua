function auriinventory.gen_formspec_skins (player)
	local fs = [[
		size[17,8;]
		bgcolor[#222222ee;false]
		listcolors[#ffffff33;#ffffff55;#888888;#33333399;#ffffff]
	]]

	--Labels
	fs = fs .. [[
		label[7,0;Available Skins]
	]]

	local playerdata = auriskins.get_skin_data(player)
	if playerdata.preview then
		fs = fs .. "image[3.5,1;3,6;" .. playerdata.preview .. "]"
	else
		fs = fs .. "image[2.6,2.6;5,2.5;" .. playerdata.skin .. "]"
	end

	fs = fs .. "textlist[7,0.5;5,7;skinlist;"

	for i = 1, auriskins.skinsloaded do
		if auriskins.skindata[i].name then
			fs = fs .. auriskins.skindata[i].name .. " (" .. auriskins.skindata[i].author .. ")"
		else
			fs = fs .. "#ff9999Skin " .. i .. " (No Metadata)"
		end
		if i ~= auriskins.skinsloaded then
			fs = fs .. ","
		end
	end
	
	fs = fs .. "]"

	fs = auriinventory.append_fragment(fs, "tabs")
	fs = fs .. auriinventory.gen_fragment_recipebook(player)

	return fs
end