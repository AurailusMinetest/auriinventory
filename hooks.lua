minetest.register_on_joinplayer(function (player)
	auriinventory.loadInventory(player)
	player:set_attribute("rbook_page", 0)
	player:hud_set_hotbar_itemcount(9)
	player:hud_set_hotbar_image("auriinventory_gui_hotbar.png")
end)

--Armor
if auriinventory.armor then
	armor:register_on_update(function (player)
		auriinventory.reloadInventory(player)
	end)
end
