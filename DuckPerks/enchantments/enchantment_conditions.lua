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

return ench_cond
