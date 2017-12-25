--Calculate Sidebar size
ainv.sidebar_width = 7
ainv.sidebar_height = 17
ainv.sidebar_inv_size = ainv.sidebar_width * ainv.sidebar_height

local xorigin = -0.5

function ainv.create_sidebar_menu(player, searchbar)
	if not ainv.items_loaded then return "" end

	local data = ainv.playerdata[player:get_player_name()]

	--Get current page
	if not data["sidebar_page"] then data["sidebar_page"] = 0 end
	local page = tonumber(data["sidebar_page"])

	--Item Iterator
	local index = page * ainv.sidebar_inv_size + 1

	local fs = 
	"container[18,0]" .. 						    --Container
	"box[-0.95,-2.6;6,13.3;#000000]"..  --Background
	"image_button[0.4,-2.45;2.5,0.6;auriinventory_blank.png;togglesearch;Toggle Search;true;true;auriinventory_blank.png]" --Search button

	--Create buttons
	for j = 0, ainv.sidebar_height - 1 do
		for i = 0, ainv.sidebar_width - 1 do

			--Check if item exists
			if ainv.items[index] then

				--Get item name
				local name = ainv.items[index]

				--Make Tooltip
				local tooltip = name
				if minetest.registered_items[name].description ~= "" then
					tooltip = minetest.registered_items[name].description .. "\n(" .. name .. ")"
				end
				tooltip = tooltip .. "\n\nClick to Spawn\nDouble-Click for Stack"

				--Add elements
				fs = fs .. 
				--Invisible button
				"image_button[" .. (xorigin + i*0.65) .. "," .. (-2.0 + j*0.7) .. ";0.8,0.8;" ..
				"auriinventory_blank.png;sidebar_item_" .. index .. ";;true;false;auriinventory_hover.png]" ..
				--Image for button
				"item_image[" .. (xorigin - 0.01 + i*0.65) .. "," .. (-2.02 + j*0.7) .. ";0.8,0.8;" .. name .. "]" ..
				--Tooltip for button
				"tooltip[sidebar_item_" .. index .. ";" .. tooltip .. ";#33333399;#fff]"
				
				index = index + 1
			else break end

		end
	end

	--Bottom navigation
	fs = fs ..
	"image_button[" .. xorigin .. ",9.95;0.7,0.8;auriinventory_recipebook_icon_6.png;sidebar_firstpage;;true;false;auriinventory_recipebook_icon_7.png]" ..
	"image_button[" .. (xorigin + 0.5) .. ",9.95;0.7,0.8;auriinventory_recipebook_icon_0.png;sidebar_prevpage;;true;false;auriinventory_recipebook_icon_1.png]" ..
	"image_button[" .. (xorigin + 1.2) .. ",9.86;2.5,1;auriinventory_blank.png;regitemslabel;Registered Items (" .. page+1 .. "/" .. math.floor((ainv.itemcount-1)/ainv.sidebar_inv_size)+1 .. ");true;false;auriinventory_blank.png]" ..
	"image_button[" .. (xorigin + 3.6) .. ",9.95;0.7,0.8;auriinventory_recipebook_icon_2.png;sidebar_nextpage;;true;false;auriinventory_recipebook_icon_3.png]" ..
	"image_button[" .. (xorigin + 4.1) .. ",9.95;0.7,0.8;auriinventory_recipebook_icon_8.png;sidebar_lastpage;;true;false;auriinventory_recipebook_icon_9.png]" ..
	"container_end[]" --End container

	return fs
end
