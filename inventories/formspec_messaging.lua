function auriinventory.gen_formspec_messaging (player)
  local fs = [[
    size[17,8;]
    bgcolor[#222222ee;false]
    listcolors[#ffffff33;#ffffff55;#888888;#33333399;#ffffff]
  ]]

  --Labels
  fs = fs .. [[
    label[3,0;Messages]
  ]]

  local playerdata = minetest.deserialize(player:get_attribute("messages"))

  fs = fs .. "textlist[3,0.5;3,7.5;messages;"

  local first = true
  for k, v in pairs(playerdata) do
    if not first then fs = fs .. "," else first = false end
    if not v.read then fs = fs .. "#ff7777● " end
    fs = fs .. v.title .. "," .. "#999999From " .. v.from
    v.read = true
  end

  player:set_attribute("messages", minetest.serialize(playerdata))
  
  fs = fs .. "]textlist[6.5,0.5;5.5,7.5;message;hi,yo,hello0;-1;true]"

  fs = auriinventory.append_fragment(fs, "tabs")
  fs = fs .. auriinventory.gen_fragment_recipebook(player)

  return fs
end