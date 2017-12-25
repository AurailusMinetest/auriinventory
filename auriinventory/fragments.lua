local path = minetest.get_modpath("auriinventory") .. "/fragments"

ainv.fragments = {}

function ainv.append_fragment(string, fragment)
	string = string .. ainv.fragments[fragment]
	return string
end

ainv.fragments["maininv"] = [[
	label[3,3.5;Inventory]

	list[current_player;main;3,4;8,3;8]
	list[current_player;main;3,7.2;8,1;]
]]

ainv.fragments["trash"] = [[
	list[detached:trash;trashcan;10,3;1,1;0]
	image[10,3.03;1,1;auriinventory_btn_icon_4.png]
]]

function ainv.create_tabs()
	local fs = ""
	local ind = 0
	for name,screen in pairs(ainv.screens) do
		if screen.tab then
			fs = fs .. "image_button[0.5," .. (0.5 + ind*1.1) .. ";2,1;" 
				.. screen.tab.image .. ";tab_" .. name .. ";          " .. screen.tab.name .. ";false;true;"
				.. screen.tab.image_hover .. "]"
			ind = ind + 1
		end
	end
	return fs
end

ainv.fragments["back"] = [[
	image_button[-0.1,-0.1;1,1;auriinventory_btn_icon_0.png;main;;false;true;auriinventory_btn_icon_1.png]
]]
