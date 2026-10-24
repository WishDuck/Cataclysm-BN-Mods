local ench_cond = {}
-- Moon Phases
-- Current moon phase enum
local moon_phase
-- Any of moon phase condition
ench_cond.add_multi_moon_phase_condition = function(id, phase_enum_list)
  local cond = {}
  cond.global = function()
    for i, phase_enum in ipairs(phase_enum_list) do
      if phase_enum == moon_phase then return true end
    end
    return false
  end
  game.add_lua_condition(id, cond)
end
-- One moon phase condition
ench_cond.add_moon_phase_condition = function(id, phase_enum)
  local cond = {}
  cond.moon_phase = moon_phase
  cond.global = function() return moon_phase == phase_enum end
  game.add_lua_condition(id, cond)
end

-- Called every 30 minutes and on every game load
ench_cond.moon_phase_update = function() moon_phase = gapi.current_turn():moon_phase() end

-- Wielded Weapon Category
local current_weapon_categories = {}

ench_cond.add_weapon_cat_condition = function(id, weapon_category)
  local cond = {}
  -- TODO: Make this character based instead of based off what the avatar is wielding
  cond.global = function()
    for i, cat in ipairs(current_weapon_categories) do
      if cat == weapon_category then return true end
    end
    return false
  end
  game.add_lua_condition(id, cond)
end

ench_cond.weapon_category_clear = function() current_weapon_categories = { "NONE" } end

ench_cond.weapon_category_update = function()
  current_weapon_categories = {}
  for i, weap in ipairs(gapi.get_avatar():wielded_items()) do
    if weap ~= nil then
      local weap_cats = weap:weapon_categories()
      for ii, cat in ipairs(weap_cats) do
        table.insert(current_weapon_categories, cat:str())
      end
    end
  end
  if current_weapon_categoires == {} then current_weapon_categories = { "NONE" } end
end

ench_cond.init_sleepy_condition = function()
  local cond = {}
  -- TODO: Make this character based instead of based off what the avatar is wielding
  cond.character = function(params)
    -- 190 is tired, give it a bit before that
    return params.guy:get_fatigue() < 150
  end
  game.add_lua_condition("duck_sleepy", cond)
end

ench_cond.init_near_elec_condition = function()
  local cond = {}
  cond.character = function(params)
    local mons = gapi.get_monsters_if({
      ["flags"] = { MonsterFlag.ELECTRIC },
      ["within_range_of"] = { ["range"] = 10, ["monsters"] = { params.guy } },
      ["limit"] = 1,
    })
    return (mons and #mons > 0)
  end
  game.add_lua_condition("duck_near_electricity", cond)
end

local current_ally_count = 0

ench_cond.ally_count_update = function()
  current_ally_count = 0
  for _, npc in ipairs(gapi.get_all_npcs()) do
    if npc:is_player_ally() then current_ally_count = current_ally_count + 1 end
  end
end

ench_cond.init_no_allies_condition = function()
  local cond = {}
  cond.character = function(params) 
    return current_ally_count == 0 end
  game.add_lua_condition("duck_no_allies", cond)
end

local stylish_count = 0

local stylish_mod = function(item)
  local res = 0
  if item:has_flag(JsonFlagId.new("FANCY")) then res = res + 1 end

  if item:has_flag(JsonFlagId.new("SUPER_FANCY")) then res = res + 3 end
  return res
end

ench_cond.stylish_update = function()
  local worn_items = gapi:get_avatar():get_worn_items()

  for index, item in pairs(worn_items) do
    stylish_count = stylish_count + stylish_mod(item)
  end
end

ench_cond.stylish_update_exclude = function(params)
  local avatar = gapi:get_avatar()
  local item = params.item
  ench_cond.stylish_update()

  if avatar:is_worn(item) then stylish_count = stylish_count - stylish_mod(item) end
end

ench_cond.init_stylish_condition = function(id, count)
  local cond = {}
  cond.character = function(params) return stylish_count >= count end
  game.add_lua_condition(id, cond)
end

return ench_cond
