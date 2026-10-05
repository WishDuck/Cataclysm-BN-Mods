local util = require("utilities")
local perk_level_var = "DUCK_PERK_LEVEL"

-- Mutation Id List
local trait_flimsy = MutationBranchId.new("FLIMSY")
local trait_flimsy2 = MutationBranchId.new("FLIMSY2")
local trait_flimsy3 = MutationBranchId.new("FLIMSY3")
local trait_glassjaw = MutationBranchId.new("GLASSJAW")

-- Skill Id Array ( Hobbyist )
local all_crafting_skills = {
  SkillId.new("fabrication"),
  SkillId.new("cooking"),
  SkillId.new("tailor"),
  SkillId.new("survival"),
  SkillId.new("electronics"),
}

-- Local Perk Id List
local perk_str_up = PerkId.new("duck_perk_str_up")
local perk_dex_up = PerkId.new("duck_perk_dex_up")
local perk_int_up = PerkId.new("duck_perk_int_up")
local perk_per_up = PerkId.new("duck_perk_per_up")
local perk_built_tough = PerkId.new("duck_perk_built_tough")
local perk_vacationer = PerkId.new("duck_perk_vacationer")
local perk_bloody_mess = PerkId.new("duck_perk_bloody_mess")
local perk_tingly = PerkId.new("duck_perk_tingly")
local perk_jumpy = PerkId.new("duck_perk_jumpy")
local perk_hobbyist = PerkId.new("duck_perk_hobbyist")
local perk_safety_net = PerkId.new("duck_perk_safety_net")
local perk_long_shot = PerkId.new("duck_perk_long_shot")

-- Helper Functions
local get_perk_level = function(character) return util.get_char_value_num(character, perk_level_var, 0) end

-- All of these perks are minor
return {
  {
    id = perk_str_up,
    condition_string = locale.gettext("Perk Level 8"),
    condition = function(character) return get_perk_level(character) >= 8 end,
  },
  {
    id = perk_dex_up,
    condition_string = locale.gettext("Perk Level 8"),
    condition = function(character) return get_perk_level(character) >= 8 end,
  },
  {
    id = perk_int_up,
    condition_string = locale.gettext("Perk Level 8"),
    condition = function(character) return get_perk_level(character) >= 8 end,
  },
  {
    id = perk_per_up,
    condition_string = locale.gettext("Perk Level 8"),
    condition = function(character) return get_perk_level(character) >= 8 end,
  },
  {
    id = perk_built_tough,
    condition_string = locale.gettext("Cannot have Flimsy, Frail, Fragile or Glass Jaw"),
    condition = function(character)
      return not character:has_trait(trait_flimsy)
        and not character:has_trait(trait_flimsy2)
        and not character:has_trait(trait_flimsy3)
        and not character:has_trait(trait_glassjaw)
    end,
    show_if_condition_false = false,
  },
  {
    id = perk_vacationer,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_bloody_mess,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_tingly,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_jumpy,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_hobbyist,
    condition_string = locale.gettext("Requires 12 levels of Crafting Skills"),
    condition = function(character)
      local all_skills = character:get_all_skills()
      local total_level = 0
      for i, id in ipairs(all_crafting_skills) do
        total_level = total_level + character:get_skill_level(id)
      end
    end,
  },
  {
    id = perk_safety_net,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_long_shot,
    condition_string = locale.gettext("Requires Perception 10"),
    condition = function(character) return character:get_per() >= 10 end,
  },
}
