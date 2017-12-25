function ainv_homes.gen_formspec_addhome (player, home)
	local fs = [[
		bgcolor[#222222ee;false]
		listcolors[#555555;#777777;#888888;#33333399;#ffffff]
	]]

	--List Homes
	fs = fs .. [[
		field[homename;Add Home;Home ]] .. home .. [[]
	]]

	return fs
end