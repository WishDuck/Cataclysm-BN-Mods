local perk_level = {}

perk_level.perk_exp_coeff = 2
perk_level.perk_exp_expon = 4

perk_level.get_level = function(exp) return math.floor((exp / perk_level.perk_exp_coeff) ^ (1 / perk_level.perk_exp_expon)) end

perk_level.exp_to_next_level = function(exp)
  local next_level = perk_level.get_level(exp) + 1
  return perk_level.exp_to_level(next_level) - exp
end

perk_level.exp_to_level = function(target_level)
  return perk_level.total_exp_to_level(target_level) - perk_level.total_exp_to_level(target_level - 1)
end
perk_level.total_exp_to_level = function(target_level)
  return perk_level.perk_exp_coeff * (target_level ^ perk_level.perk_exp_expon)
end

perk_level.exp_between_levels = function(low_level, high_level)
  return perk_level.total_exp_to_level(high_level) - perk_level.total_exp_to_level(low_level)
end

return perk_level
