local mod = game.mod_runtime[game.current_mod]
local storage = game.mod_storage[game.current_mod]
local util = require("utilities")
local perk_level = require("level")
local debugmsg = gdebug.debugmsg
local debug_trait = MutationBranchId.new("DUCK_DEBUG_ALLTRAITS")
local menu_perk = PerkId.new("duck_perk_menu_opener")

local basic_perks = {}
local major_perks = {}

-- Perk population

-- Populate `basic_perks` and `major_perks`
-- They can be extended by other mods at any time, but for this mod they are expected to all be loaded now.

-- Perk is a perk object
-- Debug name is a string
local function finalize_perk(perk, debug_name)
  if perk.id == nil or not perk.id:is_valid() then
    debugmsg(string.format("Invalid perk given; Lacks a valid id; Perk %s from %s/%s", tostring(perk.id), game.current_mod, debug_name))
    return nil
  end
  if perk.condition_string == nil or type(perk.condition_string) ~= "string" then
    debugmsg(string.format("Invalid perk given; Lacks a condition string; Perk from %s/%s", game.current_mod, debug_name))
    return nil
  end
  if perk.condition == nil or type(perk.condition) ~= "function" then
    debugmsg(string.format("Invalid perk given; Lacks a condition string; Perk from %s/%s", game.current_mod, debug_name))
    return nil
  end
  if perk.show_if_condition_false == nil or type(perk.show_if_condition_false) ~= "boolean" then
    perk.show_if_condition_false = true
  end
  if perk.major == nil or type(perk.major) ~= "boolean" then perk.major = false end
  return perk
end

-- Perk list is a list of unfinalized perks
-- Debug name is a string used if they are maldefined
mod.add_perks = function(perk_list, debug_name)
  for _, perk in ipairs(perk_list) do
    local perk = finalize_perk(perk, debug_name)
    if perk ~= nil then
      if perk.major then
        table.insert(major_perks, perk)
      else
        table.insert(basic_perks, perk)
      end
    end
  end
end

-- The actual perk additions
mod.add_perks(require("ported/standing_storm"), "standing_storm")

-- Perk Selection UI
local perk_exp_var = "DUCK_PERK_EXP" -- EXP you have in total
local basic_perks_var = "DUCK_BASIC_PERKS" -- Number of basic perks that can be gained
local basic_perks_total_var = "DUCK_BASIC_PERKS_TOTAL" -- Number of basic perks in total
local major_perks_var = "DUCK_MAJOR_PERKS" -- Number of major perks that can be gained
local major_perks_total_var = "DUCK_MAJOR_PERKS_TOTAL" -- Number of major perks in total

-- Menu for choosing perks
mod.perk_menu = function(who)
  local keep_open = true
  while keep_open do
    local exp = util.get_char_value_num(who, perk_exp_var, 0)
    local level = perk_level.get_level(exp)
    local exp_to_next = perk_level.exp_to_next_level(exp)
    local basic_perks_left = util.get_char_value_num(who, basic_perks_var, 0)
    local basic_perks_total = util.get_char_value_num(who, basic_perks_total_var, 0)
    local major_perks_left = util.get_char_value_num(who, major_perks_var, 0)
    local major_perks_total = util.get_char_value_num(who, major_perks_total_var, 0)

    local ui = UiList.new()
    ui:title(locale.gettext("Perks"))

    local info_text = ""
      .. string.format(locale.gettext("Level: %s\n"), level)
      .. string.format(locale.gettext("Exp to next level: %s\n"), exp_to_next)
      .. string.format(locale.gettext("Basic Perks Chosen: %s/%s\n"), basic_perks_left, basic_perks_total)
      .. string.format(locale.gettext("Major Perks Chosen: %s/%s\n"), major_perks_left, major_perks_total)
    ui:text(info_text)

    local menu_items = {}

    table.insert(menu_items, {
      text = locale.gettext("Manage Basic Perks"),
      action = "basic_perks",
    })
    table.insert(menu_items, {
      text = locale.gettext("Manage Major Perks"),
      action = "major_perks",
    })
    table.insert(menu_items, {
      text = locale.gettext("Close"),
      action = "close",
    })

    for i, item_entry in ipairs(menu_items) do
      ui:add(i, item_entry.text)
    end

    local choice = ui:query()
    if choice > 0 and choice <= #menu_items then
      local chosen = menu_items[choice]
      if not chosen or chosen.action == "close" then
        break
      elseif chosen.action == "basic_perks" then
        local res = mod.select_perks(
          who,
          basic_perks,
          basic_perks_left,
          basic_perks_total,
          locale.gettext("Basic Perk Selection")
        )
        if res then util.mod_char_value_num(who, basic_perks_var, -1) end
      elseif chosen.action == "major_perks" then
        local res = mod.select_perks(
          who,
          major_perks,
          major_perks_left,
          major_perks_total,
          locale.gettext("Major Perk Selection")
        )
        if res then util.mod_char_value_num(who, major_perks_var, -1) end
      end
    end
  end
end

mod.select_perks = function(who, perk_list, perks_left, perks_total, title)
  local ui = UiList.new()
  ui:title(title)
  ui:desc_enabled(true)

  local info_text = ""
    .. string.format(locale.gettext("Perks To Chose: %s\n"), perks_left, basic_perks_total)
    .. string.format(locale.gettext("Total Perks: %s\n"), perks_total)
  ui:text(info_text)

  for i, perk in ipairs(perk_list) do
    if not who:has_perk(perk.id) then
      local passes = perk.condition(who)
      if passes or perk.show_if_condition_false then
        local desc = perk.condition_string .. "\n"
        local name = perk.id:obj():get_name()
        if passes then
          desc = util.color_good(desc)
        else
          desc = util.color_bad(desc)
          name = util.color_bad(name)
        end
        desc = desc .. perk.id:obj():get_description()
        
        ui:add_w_desc(i, name, desc)
      end
    end
  end
  local choice = ui:query()

  if choice > 0 and choice <= #perk_list then
    local chosen = perk_list[choice]
    if not chosen then return end

    if not who:has_trait(debug_trait) then
      if not chosen.condition(who) then
        util.popup(locale.gettext("You do not meet the requirements for this perk"))
        return false
      end

      if perks_left <= 0 then
        util.popup(locale.gettext("You have insufficient perk points to choose this perk"))
        return false
      end

      if who:has_perk(chosen.id) then
        util.popup(locale.gettext("You already have this perk. This should never be displayed"))
        return false
      end
    end

    who:add_perk(chosen.id)
    return true
  end
  return false
end

-- Give the perk for opening the menu
mod.on_game_load = function()
  local player = gapi.get_avatar()

  if not player:has_perk(menu_perk) then
    player:add_perk(menu_perk)
    util.popup(locale.gettext("To access the perk selection menu, hit activate, then there will be an open perk menu item. Use it!"))
  end
end

mod.open_perks_menu = function(params)
  mod.perk_menu(params.user)
  return 0
end
