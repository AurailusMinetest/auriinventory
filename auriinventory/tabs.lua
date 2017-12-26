function ainv.create_tabs()
	local fs = ""
	for i = 1, #ainv.screens do
		local screen = ainv.screens[i]
		if screen.tab then
			fs = fs .. "image_button[0.5," .. (0.5 + (i-1)*1.1) .. ";2,1;" 
				.. screen.tab.image .. ";tab_" .. screen.name .. ";          " .. screen.tab.name .. ";false;true;"
				.. screen.tab.image_hover .. "]"
		end
	end
	return fs
end