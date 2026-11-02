local mod = game.mod_runtime[game.current_mod]

local util = require("utilities")

local bp_null = BodyPartTypeId.NULL_ID():int_id()
local closetland_effect = EffectTypeId.new("duck_perk_effect_closetland_inside")

local target = TripointAbsOmt.new(0, 0, 0)

local closetland_x_var = "DUCK_CLOSETLAND_EXIT_X"
local closetland_y_var = "DUCK_CLOSETLAND_EXIT_Y"
local closetland_z_var = "DUCK_CLOSETLAND_EXIT_Z"

local store_last_pos = function(char, pos)
  util.set_char_value_num(char, closetland_x_var, pos.x)
  util.set_char_value_num(char, closetland_y_var, pos.y)
  util.set_char_value_num(char, closetland_z_var, pos.z)
end

local get_last_pos = function(char)
  local x = util.get_char_value_num(char, closetland_x_var, 0)
  local y = util.get_char_value_num(char, closetland_y_var, 0)
  local z = util.get_char_value_num(char, closetland_z_var, 0)
  return TripointAbsMs.new(x, y, z)
end

local adjacent_points = {
  PointRelMs.new( -1, -1 ),
  PointRelMs.new( -1, 0 ),
  PointRelMs.new( -1, 1 ),
  PointRelMs.new( 0, -1 ),
  PointRelMs.new( 0, 1 ),
  PointRelMs.new( 1, -1 ),
  PointRelMs.new( 1, 0 ),
  PointRelMs.new( 1, 1 ),
}

local in_closet = function(char)
  local pos = char:bub_pos()
  local map = gapi.get_map()
  for i, point in ipairs(adjacent_points) do
    local endpos = pos + point
    if not map:has_flag_at( "WALL", endpos ) and not map:has_flag_at( "DOOR", endpos ) then
      return false
    end
  end
  return true
end

mod.closetland = function(params)
  local user = params.user
  local dim_id = gapi.get_current_dimension_id()
  if dim_id == "" then
    if not in_closet(user) then return 0 end
    store_last_pos( user, user:abs_pos() )
    local entered = gapi.place_player_dimension_at({
      world_type = "duck_closetland",
      dimension_id = "duck_closetland",
      pregen_special_id = "duck_closetland",
      target_omt = target,
      bounds_min_omt = target,
      bounds_max_omt = target
    })
    if entered then
      user:add_effect(closetland_effect, TimeDuration.from_minutes(10), bp_null, 1)
    end
  elseif dim_id == "duck_closetland" then
    local entered = gapi.place_player_dimension_at({
      dimension_id = "",
      target_ms = get_last_pos( user ),
    })
    if entered then
      user:remove_effect(closetland_effect)
    end
  end
  return 0
end
  
