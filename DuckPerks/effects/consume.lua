local mod = game.mod_runtime[game.current_mod]
local util = require("utilities")

local perk_eating_window = PerkId.new("duck_perk_eating_window")
local last_eat_var = "DUCK_LAST_ATE"

local eating_window = function(params)
  local char = params.char
  local started_eating = util.get_char_value_num(char, last_eat_var, gapi.current_turn():to_turn())
  local eating_duration = gapi.current_turn():to_turn() - started_eating
  if eating_duration > 60 * 60 * 24 or eating_duration == 0 then
    util.set_char_value_num(char, last_eat_var, gapi.current_turn():to_turn())
    eating_duration = 0
  end
  -- If less then 6 hours
  if eating_duration < 60 * 60 * 6 then
    params.nutrition = params.nutrition * 2.5
  else
    params.nutrition = 0
  end
end

mod.on_character_try_consume = function(params)
  results = {}
  if params.char:has_perk(perk_eating_window) then results = eating_window(params) end
  return { nutrition = params.nutrition }
end
