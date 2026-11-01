local mod = game.mod_runtime[game.current_mod]
local util = require("utilities")

local perk_early_to_rise = PerkId.new("duck_perk_early_to_rise")

-- Early to rise
local early_to_rise_morale = MoraleTypeDataId.new("duck_morale_early_to_rise")
local hours_24 = TimeDuration.from_hours(24)
local early_to_rise = function(params)
  local hour = gapi.current_turn():hour_of_day()
  if hour >= 4 and hour <= 7 then params.char:add_morale(early_to_rise_morale, 10, 10, hours_24, hours_24, false) end
end

mod.on_character_wake_up = function(params)
  if params.char:has_perk(perk_early_to_rise) then early_to_rise(params) end
end
