local char_val = {}
local util = require("utilities")
local stylish_var = "DUCK_PERK_STYLISH"

local stylish_mod = function(item)
  local res = 0
  if item:has_flag(JsonFlagId.new("FANCY")) then res = res + 1 end

  if item:has_flag(JsonFlagId.new("SUPER_FANCY")) then res = res + 3 end
  return res
end

char_val.stylish_update = function(params)
  local avatar
  if params == nil or params.who == nil then
    avatar = gapi.get_avatar()
  else
    avatar = params.who
  end

  local worn_items = avatar:get_worn_items()
  local stylish_count = 0

  for index, item in pairs(worn_items) do
    stylish_count = stylish_count + stylish_mod(item)
  end
  util.set_char_value_num(avatar, stylish_var, stylish_count)
end

char_val.stylish_update_exclude = function(params)
  local avatar = params.who
  local item = params.item
  char_val.stylish_update(params)

  if avatar:is_worn(item) then util.mod_char_value_num(avatar, stylish_var, -stylish_mod(item)) end
end

return char_val
