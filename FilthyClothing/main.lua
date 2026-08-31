local mod = game.mod_runtime[game.current_mod]

local flag_FILTHY = JsonFlagId.new("FILTHY")

local flag_CLEAN = JsonFlagId.new("CLEAN")

local clean_activity = ActivityTypeId.new("ACT_CLEAN")

local clothing_morale = MoraleTypeDataId.new("morale_clothing_freshness")

local cleaning_requirement_id = "duck_cleaning_requirement"

local flesh = MaterialTypeId.new("flesh")
-- 5 minutes
local time_per_cleaning_charge = 30000

local minutes_30 = TimeDuration.from_minutes(30)

-- Item Vars
local dirty_var = "DUCK_DIRTY"

-- Enchantment values
local ench_val_DIRTY_MORALE = EnchantmentValueId.new("DUCK_CLOTHING_MORALE_DIRTY")
local ench_val_NORM_MORALE = EnchantmentValueId.new("DUCK_CLOTHING_MORALE_NORMAL")
local ench_val_CLEAN_MORALE = EnchantmentValueId.new("DUCK_CLOTHING_MORALE_CLEAN")
local ench_val_CLOTHING_DIRTY = EnchantmentValueId.new("DUCK_CLOTHING_TIME_DIRTY")

make_dirty = function(item)
  if item:has_flag(flag_CLEAN) then
    item:unset_flag(flag_CLEAN)
  else
    item:set_flag(flag_FILTHY)
  end
end

clean_morale_mod = function(ch, item)
  if item:has_flag(flag_FILTHY) then
    local base = -15
    return base + ch:bonus_from_enchantments(base, ench_val_DIRTY_MORALE)
  elseif item:has_flag(flag_CLEAN) then
    local base = 10
    return base + ch:bonus_from_enchantments(base, ench_val_CLEAN_MORALE)
  end
  local base = 0
  return base + ch:bonus_from_enchantments(base, ench_val_NORM_MORALE)
end

morale_postprocess = function(morale)
  res = math.floor(math.sqrt(math.abs(morale)) + 0.5)
  if morale < 0 then return res * -1 end
  return res
end

local reset_morale_val = function(avatar)
  local worn_items = avatar:get_worn_items()

  local morale = 0

  for index, item in pairs(worn_items) do
    morale = morale + clean_morale_mod(avatar, item)
  end

  return morale
end

mod.reset_morale_val_exclude = function(params)
  local avatar = params.who
  local item = params.item
  local morale = reset_morale_val(avatar)

  if avatar:is_worn(item) then morale = morale - clean_morale_mod(avatar, item) end

  morale = morale_postprocess(morale)

  avatar:rem_morale(clothing_morale)
  avatar:add_morale(clothing_morale, morale, morale, minutes_30, minutes_30, false)
end

mod.reset_morale_val_include = function(params)
  local avatar = params.who
  local item = params.item
  local morale = reset_morale_val(avatar)

  if not avatar:is_worn(item) then morale = morale + clean_morale_mod(avatar, item) end

  morale = morale_postprocess(morale)

  avatar:rem_morale(clothing_morale)
  avatar:add_morale(clothing_morale, morale, morale, minutes_30, minutes_30, false)
end

mod.give_morale_and_sweat = function(info)
  --gapi.add_msg("Every minute I add a message!")

  local avatar = gapi:get_avatar()

  local worn_items = avatar:get_worn_items()

  local morale = 0

  local dirty_mod = 1
  dirty_mod = dirty_mod + avatar:bonus_from_enchantments(dirty_mod, ench_val_CLOTHING_DIRTY)
  for index, item in pairs(worn_items) do
    local dirtiness = item:get_var_num(dirty_var, 0)
    if gapi.rng(24, 1024) <= dirtiness then
      make_dirty(item)
      dirtiness = 0
    else
      dirtiness = dirtiness + dirty_mod
    end
    item:set_var_num(dirty_var, dirtiness)
    morale = morale + clean_morale_mod(avatar, item)
  end

  morale = morale_postprocess(morale)

  avatar:rem_morale(clothing_morale)
  avatar:add_morale(clothing_morale, morale, morale, minutes_30, minutes_30, false)
end

mod.make_clothing_dirty = function(info)
  if info["mon"]:made_of(flesh) then
    local position = info["mon"]:get_pos_ms()
    local items = gapi.get_map():get_items_at(position):as_item_stack():items()
    for index, item in pairs(items) do
      if item:is_armor() then make_dirty(item) end
    end
  end
end

present_error = function(error, desc)
  local ui_error = UiList.new()
  ui_error:title_color(Color.c_white)
  ui_error:border_color(Color.c_white)
  ui_error:desc_enabled(true)
  ui_error:text(error)
  ui_error:add_w_desc(0, locale.gettext("Continue"), desc)
  ui_error:add_w_desc(1, locale.gettext("Quit"), desc)
  local query = ui_error:query()
  gapi.add_msg(query)
  return query
end

get_cleaning_charges = function(item) return math.ceil(item:volume(true):to_milliliter() / 500) end

get_cleaning_requirements =
  function(item) return requirements.get(cleaning_requirement_id) * get_cleaning_charges(item) end

clean_item = function(item)
  item:set_flag(flag_CLEAN)
  item:unset_flag(flag_FILTHY)
end

mod.get_cleanable_clothes = function(params)
  local item = params.item
  return item:is_armor() and ((not item:has_flag(flag_CLEAN)) or item:has_flag(flag_FILTHY))
end

mod.wash = function(params)
  local user = params.user
  local item = params.item
  local position = params.pos
  local cleaning_clothes_params = {}
  cleaning_clothes_params.title = locale.gettext("Clean What?")
  cleaning_clothes_params.failure = locale.gettext("You have nothing to clean.")
  cleaning_clothes_params.check = mod.get_cleanable_clothes

  local cleaning_time = 0
  while true do
    local to_clean = gapi.inv_map_splice(cleaning_clothes_params)

    if to_clean == nil then break end

    local cleaning_requirements = get_cleaning_requirements(item)
    local crafting_inv = user:crafting_inventory()

    if not cleaning_requirements:can_make_with_inventory(crafting_inv) then
      if
        present_error(
          locale.gettext("Insufficient cleaning supplies to clean this item"),
          cleaning_requirements:list_missing()
        ) == 1
      then
        break
      end
    else
      if user:consume_requirement(cleaning_requirements, {}) then
        cleaning_time = cleaning_time + time_per_cleaning_charge * get_cleaning_charges(item)
        clean_item(to_clean)
        user:invalidate_crafting_inventory()
      end
    end
  end
  if cleaning_time ~= 0 then user:assign_activity(clean_activity, cleaning_time, -1, -1, "") end
  return 0
end
