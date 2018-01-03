ainv.fragments = {}

local path = minetest.get_modpath("auriinventory") .. "/fragments"

dofile(path .. "/trash.lua")
dofile(path .. "/tabs.lua")

function ainv.append_fragment(string, fragment)
	string = string .. ainv.fragments[fragment]
	return string
end

ainv.fragments["maininv"] = [[
	label[3,3.5;Inventory]

	list[current_player;main;3,4;8,3;8]
	list[current_player;main;3,7.2;8,1;]
]]

ainv.fragments["back"] = [[
	image_button[-0.1,-0.1;1,1;auriinventory_btn_icon_0.png;tab_main;;false;true;auriinventory_btn_icon_1.png]
]]
