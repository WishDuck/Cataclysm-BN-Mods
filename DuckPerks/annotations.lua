---@class unfinalized_perk_data
---@field id PerkId Perk Id that this gives
---@field condition_string string String to show for the condition
---@field condition fun(character: Character): boolean Function for the actual condition
---@field show_if_condition_false boolean? default true bool for hiding if condition fails
---@field description string? default empty string -> overrides perk menu description
---@field has_description boolean? 
---@field major boolean? default false, weather it is a major perk or not
unfinalized_perk_data = {}

---@class finalized_perk_data
---@field id PerkId
---@field condition_string string
---@field condition fun(character: Character): boolean
---@field show_if_condition_false boolean
---@field has_description boolean
---@field description string
---@field major boolean
finalized_perk_data = {}

