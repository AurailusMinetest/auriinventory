local path = minetest.get_modpath("auriinventory") .. "/fragments"

auriinventory.fragments = {}

function auriinventory.append_fragment(string, fragment)
	string = string .. auriinventory.fragments[fragment]
	return string
end

auriinventory.fragments["maininv"] = [[
	label[3,3.5;Inventory]

	list[current_player;main;3,4;9,3;9]
	list[current_player;main;3,7.2;9,1;]
]]

auriinventory.fragments["trash"] = [[
	list[detached:trash;trashcan;11,3;1,1;0]
	image[11,3.03;1,1;auriinventory_btn_icon_4.png]
]]

auriinventory.fragments["tabs"] = [[
	image_button[0.5,0.5;2,1;auriinventory_tab_icon_4.png;main;          Main;false;true;auriinventory_tab_icon_5.png]
	image_button[0.5,1.6;2,1;auriinventory_tab_icon_0.png;bags;          Bags;false;true;auriinventory_tab_icon_1.png]
	image_button[0.5,2.7;2,1;auriinventory_tab_icon_10.png;teleport;            Teleport;false;true;auriinventory_tab_icon_11.png]
	image_button[0.5,3.8;2,1;auriinventory_tab_icon_6.png;messaging;             Messaging;false;true;auriinventory_tab_icon_7.png]
	image_button[0.5,4.9;2,1;auriinventory_tab_icon_12.png;skins;           Skins;false;true;auriinventory_tab_icon_13.png]
]]

auriinventory.fragments["back"] = [[
	image_button[-0.1,-0.1;1,1;auriinventory_btn_icon_0.png;main;;false;true;auriinventory_btn_icon_1.png]
]]

function auriinventory.gen_fragment_recipebook(player)
	if not player:get_attribute("rbook_page") then player:set_attribute("rbook_page", 0) end
	local cheat = player:get_attribute("cheatitems") or false

	local inv_size = 6*10
	local page = tonumber(player:get_attribute("rbook_page"))
	if page < 0 then
		player:set_attribute("rbook_page",0)
		page = 0
	end
	if page*inv_size > auriinventory.itemcount then
		page = math.floor(auriinventory.itemcount / inv_size)
		player:set_attribute("rbook_page",page)
	end
	local start_index = page * inv_size

	local ind = 1
	local fs = "label[12.6,0;Registered Items (" .. page+1 .. "/" .. math.floor(auriinventory.itemcount/inv_size)+1 .. ")]"
	for j = 0, 9 do
		for i = 0, 5 do
			if auriinventory.items[start_index + ind] then
				if cheat then
					fs = fs .. "item_image_button[" .. (12.6 + i*0.65) .. "," .. (0.45 + j*0.7) .. ";0.8,0.8;" .. auriinventory.items[start_index + ind] .. ";rbook_item_give_" .. (start_index + ind) .. ";]"
				else
					fs = fs .. "item_image_button[" .. (12.6 + i*0.65) .. "," .. (0.45 + j*0.7) .. ";0.8,0.8;" .. auriinventory.items[start_index + ind] .. ";rbook_item_recipe_" .. (start_index + ind) .. ";]"
				end
			end
			ind = ind + 1
		end
	end
	fs = fs .. "image_button[12.6,7.45;0.7,0.8;auriinventory_recipebook_icon_6.png;rbook_firstpage;;false;false;auriinventory_recipebook_icon_7.png]"
	fs = fs .. "image_button[13.1,7.45;0.7,0.8;auriinventory_recipebook_icon_0.png;rbook_prevpage;;false;false;auriinventory_recipebook_icon_1.png]"
	fs = fs .. "field[13.88,7.99;2.1,0.23;rbook_search;;]"
	fs = fs .. "image_button[15.45,7.45;0.7,0.8;auriinventory_recipebook_icon_2.png;rbook_nextpage;;false;false;auriinventory_recipebook_icon_3.png]"
	fs = fs .. "image_button[15.95,7.45;0.7,0.8;auriinventory_recipebook_icon_8.png;rbook_lastpage;;false;false;auriinventory_recipebook_icon_9.png]"
	return fs
end
