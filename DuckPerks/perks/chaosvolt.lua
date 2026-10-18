local util = require("utilities")

-- Skill Id List
local survival_skill = SkillId.new("survival")
local unarmed_skill = SkillId.new("unarmed")
local mechanics_skill = SkillId.new("mechanics")
local dodge_skill = SkillId.new("dodge")
local shotgun_skill = SkillId.new("shotgun")

-- Local Perk Id List
local perk_stylish_duelist = PerkId.new("duck_perk_stylish_duelist")
local perk_wanderer = PerkId.new("duck_perk_wanderer")

return {
  -- Major perks
  {
    id = perk_stylish_duelist,
    major = true,
    condition_string = locale.gettext("Requires Survival Level 5 and Dexterity 9"),
    condition = function(character) return character:get_skill_level(survival_skill) >= 5 and character:get_dex() >= 9 end,
  },
  {
    id = perk_wanderer,
    major = true,
    condition_string = locale.gettext("No Condition"),
    condition = function(character) return true end,
  },
}
