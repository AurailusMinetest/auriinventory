function ainv_homes.gen_formspec_homes (player)
	local fs = ainv.formspec_base(player)
	fs = ainv.append_fragment(fs, "maininv")
	fs = fs .. ainv.create_tabs()

	--Labels
	fs = fs .. [[
		label[3,0;Homes]
		label[9,0;Teleports]
	]]

	--List Homes
	local max = tonumber(minetest.settings:get("maxhomes")) or 6
	if minetest.check_player_privs(player:get_player_name(), "max_homes") then
		max = 6
	end
	if max > 6 then max = 6 end
	local top = 0
	local left = 0
	for i = 0, (max - 1) do
		if i ~= 0 and i % (max/2) == 0 then
			left = left + 3
			top = 0
		end
		top = top + 0.9

		if player:get_attribute("home_" .. (i+1) .. "_pos") and player:get_attribute("home_" .. (i+1) .. "_name") then
			fs = fs .. [[
				button[]] .. tostring(3 + left) .. [[,]] .. tostring(-0.575 + top) .. [[;2.55,1;home]] .. tostring(i + 1) .. [[;]] .. player:get_attribute("home_" .. tostring(i + 1) .. "_name") .. [[]
				image_button[]] .. tostring(5.3 + left) .. [[,]] .. tostring(-0.495 + top) .. [[;0.840,0.840;auriinventory_btn_icon_4.png;delhome]] .. tostring(i + 1) .. [[;;false;true;auriinventory_btn_icon_5.png]
			]]
		else
			fs = fs .. [[
				button[]] .. tostring(3 + left) .. [[,]] .. tostring(-0.575 + top) .. [[;3.12,1;home]] .. tostring(i + 1) .. [[;Add Home]
			]]
		end
	end

	--Temp and Death Point buttons
	if minetest.settings:get_bool("temphome") then fs = fs .. "button[9,0.325;2.05,1;temphome;Set Temp Home]" end
	if minetest.settings:get_bool("deathpoint") then fs = fs .. "button[9,1.225;2.05,1;deathpoint;Return to Death Point]" end
	if minetest.check_player_privs(player:get_player_name(), "teleport") then fs = fs .. "button[9,2.125;2.05,1;teleportto;Teleport to Player]" end

	fs = fs .. ainv.formspec_base_end(player)

	return fs
end
