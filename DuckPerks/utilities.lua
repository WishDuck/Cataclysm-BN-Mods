local util = {}

-- UI stuff
util.color_text = function(text, color) return string.format("<color_%s>%s</color>", color, text) end
util.color_good = function(text) return util.color_text(text, "light_green") end
util.color_bad = function(text) return util.color_text(text, "light_red") end
util.color_warning = function(text) return util.color_text(text, "yellow") end
util.color_info = function(text) return util.color_text(text, "light_cyan") end
util.color_highlight = function(text) return util.color_text(text, "white") end

-- Value getters
---@return number
util.get_char_value_num = function(who, key, default)
  local val = who:get_value(key)
  if val == "" then return default end
  return tonumber(val)
end

---@return number
util.set_char_value_num = function(who, key, value) local val = who:set_value(key, tostring(value)) end

---@return number
util.mod_char_value_num =
  function(who, key, mod) util.set_char_value_num(who, key, util.get_char_value_num(who, key, 0) + mod) end

util.popup = function(string)
  local popup = QueryPopup.new()
  popup:message(string)
  popup:allow_any_key(true)
  popup:query()
end

---@return boolean
util.has_active_mod = function(mod_id)
  for _, mod in ipairs(game["active_mods"]) do
    if mod == mod_id then return true end
  end
  return false
end

return util
