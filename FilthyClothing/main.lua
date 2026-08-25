local mod = game.mod_runtime[game.current_mod]

local flag_FILTHY = JsonFlagId.new("FILTHY")

local flag_CLEAN = JsonFlagId.new("CLEAN")

local clean_activity = ActivityTypeId.new("ACT_CLEAN")

local clothing_morale = MoraleTypeDataId.new("morale_clothing_freshness")

local cleaning_requirement_id = "duck_cleaning_requirement"

local time_per_cleaning_charge = 1500

local minutes_30 = TimeDuration.from_minutes(30)

local dirty_var = "DUCK_DIRTY"

make_dirty = function(item)
  if item:has_flag(flag_CLEAN) then
    item:unset_flag(flag_CLEAN)
  else
    item:set_flag(flag_FILTHY)
  end
end

clean_morale_mod = function(item)
  if item:has_flag(flag_FILTHY) then
    return -15
  elseif item:has_flag(flag_CLEAN) then
    return 10
  end
  return 0
end

morale_postprocess = function(morale)
  res = math.floor(math.sqrt(math.abs(morale)) + 0.5)
  if morale < 0 then return res * -1 end
  return res
end

mod.give_morale_and_sweat = function(info)
  --gapi.add_msg("Every minute I add a message!")

  local worn_items = gapi:get_avatar():get_worn_items()

  local morale = 0

  for index, item in pairs(worn_items) do
    local dirtiness = item:get_var_num(dirty_var, 0)
    if gapi.rng(24, 1024) <= dirtiness then
      make_dirty(item)
      dirtiness = 0
    else
      dirtiness = dirtiness + 1
    end
    item:set_var_num(dirty_var, dirtiness)
    morale = morale + clean_morale_mod(item)
  end

  morale = morale_postprocess(morale)

  gapi:get_avatar():add_morale(clothing_morale, morale, morale, minutes_30, minutes_30, false)
end

mod.make_clothing_dirty = function(info)
  local position = info["mon"]:get_pos_ms()
  local items = gapi.get_map():get_items_at(position):as_item_stack():items()
  for index, item in pairs(items) do
    if item:is_armor() then make_dirty(item) end
  end
end

present_error = function(error)
  local ui_error = UiList.new()
  ui_error:title_color(Color.c_white)
  ui_error:border_color(Color.c_white)
  ui_error:desc_enabled(true)
  ui_error:text(error)
  ui_error:add(0, locale.gettext("Continue"))
  ui_error:add(1, locale.gettext("Quit"))
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
      if present_error(locale.gettext("Insufficient cleaning supplies to clean this item")) == 1 then break end
    else
      if user:consume_requirement(cleaning_requirements, {}) then
        cleaning_time = cleaning_time + time_per_cleaning_charge * get_cleaning_charges(item)
        clean_item(to_clean)
      end
    end
  end
  if cleaning_time ~= 0 then user:assign_activity(clean_activity, cleaning_time, -1, -1, "") end
  return 0
end
