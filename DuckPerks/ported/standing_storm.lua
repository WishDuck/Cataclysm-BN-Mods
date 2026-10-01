local util = require("utilities")
local perk_level_var = "DUCK_PERK_LEVEL"

-- Mutation Id List
local trait_spiritual = MutationBranchId.new("SPIRITUAL")
local trait_parkour = MutationBranchId.new("PARKOUR")
local trait_illiterate = MutationBranchId.new("ILLITERATE")
local trait_insomnia = MutationBranchId.new("INSOMNIA")
local trait_pacifist = MutationBranchId.new("PACIFIST")
local trait_gourmand = MutationBranchId.new("GOURMAND")

-- Skill Id List
local athletics_skill = SkillId.new("swimming")
local bashing_skill = SkillId.new("bashing")
local unarmed_skill = SkillId.new("unarmed")
local mechanics_skill = SkillId.new("mechanics")
local dodge_skill = SkillId.new("dodge")
local shotgun_skill = SkillId.new("shotgun")

-- Local Perk Id List
local perk_sight_beyond_sight = PerkId.new("duck_perk_sight_beyond_sight")
local perk_eagle_eyes = PerkId.new("duck_perk_eagle_eyes")
local perk_thick_skin = PerkId.new("duck_perk_thick_skin")
local perk_bellringer = PerkId.new("duck_perk_bellringer")
local perk_vengeful = PerkId.new("duck_perk_vengeful")
local perk_twice_shy = PerkId.new("duck_perk_twice_shy")
local perk_ghost_stealth = PerkId.new("duck_perk_ghost_stealth")
local perk_catfall = PerkId.new("duck_perk_catfall")
local perk_perfect_time = PerkId.new("duck_perk_perfect_time")
local perk_uncanny_dodge = PerkId.new("duck_perk_uncanny_dodge")
local perk_safety_squint = PerkId.new("duck_perk_safety_squint")
local perk_bedtime_reader = PerkId.new("duck_perk_bedtime_reader")
local perk_static_stockpile = PerkId.new("duck_perk_static_stockpile")
local perk_easy_sleeper = PerkId.new("duck_perk_easy_sleeper")
local perk_early_to_rise = PerkId.new("duck_perk_early_to_rise")
local perk_duck_and_weave = PerkId.new("duck_perk_duck_and_weave")
local perk_non_combatant = PerkId.new("duck_perk_non_combatant")
local perk_fancy_footwork = PerkId.new("duck_perk_fancy_footwork")
local perk_fish_in_water = PerkId.new("duck_perk_fish_in_water")
local perk_eating_window = PerkId.new("duck_perk_eating_window")
local perk_moonstruck = PerkId.new("duck_perk_moonstruck")
local perk_nocturnal = PerkId.new("duck_perk_nocturnal")
local perk_second_chance = PerkId.new("duck_perk_second_chance")
local perk_gunslinger = PerkId.new("duck_perk_gunslinger")
local perk_boomstick_blast = PerkId.new("duck_perk_boomstick_blast")
-- External Perk Id List
local perk_built_tough = PerkId.new("duck_perk_built_tough")
local perk_tingly = PerkId.new("duck_perk_tingly")

-- Helper Functions
local get_perk_level = function(character) return util.get_char_value_num(character, perk_level_var, 0) end

-- Working schema
-- id ( mandatory ): id of perk to give
-- condition_string ( mandatory ): readable condition
-- condition ( mandatory ): lua function taking the character; says if can give perk
-- show_if_condition_false ( optional ): defaults to true, if false remove from selection menu, as it can never be true again
-- major ( optional ): defaults to false, if true requires a playstyle perk point to choose, which are given every 5 levels.
return {
  -- Minor Perks
  {
    id = perk_sight_beyond_sight,
    condition_string = locale.gettext("Requires Perception 13 or the Spiritual Trait"),
    condition = function(character) return character:has_trait(trait_spiritual) or character:get_per() >= 13 end,
  },
  {
    id = perk_eagle_eyes,
    condition_string = locale.gettext("Requires Perception 13 and Perk Level 12"),
    condition = function(character) return character:get_per() >= 13 and get_perk_level(character) >= 12 end,
  },
  {
    id = perk_thick_skin,
    condition_string = locale.gettext("Requires Built Tough and Perk Level 6"),
    condition = function(character) return get_perk_level(character) >= 6 and character:has_perk(perk_built_tough) end,
  },
  {
    id = perk_bellringer,
    condition_string = locale.gettext("Requires Bashing or Unarmed Skill Level 4"),
    condition = function(character)
      return character:get_skill_level(unarmed_skill) >= 4 or character:get_skill_level(bashing_skill) >= 4
    end,
  },
  {
    id = perk_vengeful,
    condition_string = locale.gettext("Requires lack of Twice Shy"),
    condition = function(character) return not character:has_perk(perk_twice_shy) end,
    show_if_condition_false = false,
  },
  {
    id = perk_twice_shy,
    condition_string = locale.gettext("Requires lack of Vengeful"),
    condition = function(character) return not character:has_perk(perk_vengeful) end,
    show_if_condition_false = false,
  },
  {
    id = perk_ghost_stealth,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_catfall,
    condition_string = locale.gettext("Requires Athletics Skill 7 or Parkour Expert"),
    condition = function(character)
      return character:get_skill_level(athletics_skill) >= 7 or character:has_trait(trait_parkour)
    end,
  },
  {
    id = perk_perfect_time,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_uncanny_dodge,
    condition_string = locale.gettext("Requires Dodge Skill Level 8"),
    condition = function(character) return character:get_skill_level(dodge_skill) >= 8 end,
  },
  {
    id = perk_safety_squint,
    condition_string = locale.gettext("Requires Mechanics Skill Level 4 or Intellegence 11"),
    condition = function(character) return character:get_int() > 11 or character:get_skill_level(mechanics_skill) >= 4 end,
  },
  {
    id = perk_bedtime_reader,
    condition_string = locale.gettext("Cannot have illiterate or hate books"),
    condition = function(character)
      -- Note: When `LOVES_BOOKS` is jsonized, check for that enchantment value
      return not character:has_trait(trait_illiterate)
    end,
    show_if_condition_false = false,
  },
  {
    id = perk_static_stockpile,
    condition_string = locale.gettext("Requires Tingly Perk and Perk Level 8"),
    condition = function(character) return character:has_perk(perk_tingly) and get_perk_level(character) >= 8 end,
  },
  {
    id = perk_easy_sleeper,
    condition_string = locale.gettext("Cannot have Nocturnal or Insomniac"),
    condition = function(character) return not character:has_perk(perk_nocturnal) and not character:has_trait(trait_insomnia) end,
    show_if_condition_false = false,
  },
  {
    id = perk_early_to_rise,
    condition_string = locale.gettext("Cannot have Nocturnal"),
    condition = function(character) return not character:has_perk(perk_nocturnal) end,
    show_if_condition_false = false,
  },
  {
    id = perk_duck_and_weave,
    condition_string = locale.gettext("Requires dexterity 12 or dodge 6"),
    condition = function(character) return character:get_skill_level(dodge_skill) >= 6 or character:get_dex() >= 12 end,
  },
  {
    id = perk_non_combatant,
    condition_string = locale.gettext("Requires Pacifist"),
    condition = function(character) return character:has_trait(trait_pacifist) end,
    show_if_condition_false = false,
  },
  {
    id = perk_fancy_footwork,
    condition_string = locale.gettext("Requires Melee 5 and Dexterity 10"),
    condition = function(character) return character:get_dex() >= 10 and character:get_skill_level(melee_skill) >= 5 end,
  },
  {
    id = perk_fish_in_water,
    condition_string = locale.gettext("Requires Athletics 4"),
    condition = function(character) return character:get_skill_level(athletics_skill) >= 4 end,
  },
  -- Major perks
  {
    id = perk_eating_window,
    major = true,
    condition_string = locale.gettext("Cannot have Gourmand"),
    condition = function(character) return not character:has_trait(trait_gourmand) end,
    show_if_condition_false = false,
  },
  {
    id = perk_moonstruck,
    major = true,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
  {
    id = perk_nocturnal,
    major = true,
    condition_string = locale.gettext("Cannot have Early to Rise or Easy Sleeper Perks"),
    condition = function(character)
      return not character:has_perk(perk_easy_sleeper) and not character:has_perk(perk_early_to_rise)
    end,
    show_if_condition_false = false,
  },
  {
    id = perk_second_chance,
    major = true,
    condition_string = locale.gettext("Requires Perk Level 12"),
    condition = function(character) return get_perk_level(character) >= 12 end,
  },
  {
    id = perk_gunslinger,
    major = true,
    condition_string = locale.gettext("Requires Perk Level 12 and Pistol and Gun Level 7"),
    condition = function(character)
      return get_perk_level(character) >= 12
        and character:get_skill_level(pistol_skill) >= 7
        and character:get_skill_level(gun_skill) >= 7
    end,
  },
  {
    id = perk_boomstick_blast,
    major = true,
    condition_string = locale.gettext("Requires Shotgun Level 6"),
    condition = function(character) return character:get_skill_level(shotgun_skill) >= 6 end,
  },
}
