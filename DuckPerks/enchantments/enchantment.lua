local ench = {}

local ench_val_ranged_knockback = EnchantmentValueId.new("DUCK_RANGED_KNOCKBACK")
ench.on_shoot = function(params)
  -- Setup who as a character, return if non-character
  local who = params.shooter
  who = who:as_character()
  if who == nil then return end

  -- Setup target monster, return if none at target
  local target_pos = params.target_pos
  local target = gapi.get_creature_at(target_pos)
  if target == nil then return end

  local ench_val = who:bonus_from_enchantments(0, ench_val_ranged_knockback)
  if ench_val <= 0 then return end

  local pos_who = who:bub_pos()
  local deg = math.atan(target_pos.y - pos_who.y, target_pos.x - pos_who.x)
  gapi.fling_creature(target, Angle.from_radians(deg), ench_val, true)
end

return ench
