function auriinventory.gen_formspec_messaging (player, index)
  local fs = [[
    size[17,8;]
    bgcolor[#222222ee;false]
    listcolors[#ffffff33;#ffffff55;#888888;#33333399;#ffffff]
  ]]

  --Labels
  fs = fs .. [[
    label[3,0;Messages]
  ]]

  local playerdata = minetest.deserialize(player:get_attribute("messages") or {})

  fs = fs .. "textlist[3,0.5;3,7.5;messages;"

  if playerdata then
    local first = true
    for k, v in pairs(playerdata) do
      if not first then fs = fs .. "," else first = false end
      if not v.read then fs = fs .. "#ff7777● " end
      fs = fs .. v.title .. "," .. "#999999From " .. v.from
      v.read = true
    end
  end
  fs = fs .. "]"

  if index then
    fs = fs .. [[
    textlist[6.5,0.5;5.5,7.5;message;]] .. playerdata[index].message .. [[;-1;true]
    image_button[11.4,0.4;0.8,0.8;auriinventory_btn_icon_2.png;delmessage_]] .. index .. [[;;true;false;auriinventory_btn_icon_3.png]
    ]]
  end

  player:set_attribute("messages", minetest.serialize(playerdata) or {})

  fs = auriinventory.append_fragment(fs, "tabs")
  fs = fs .. auriinventory.gen_fragment_recipebook(player)

  return fs
end