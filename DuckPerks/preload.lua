local mod = game.mod_runtime[game.current_mod]

game.add_hook("on_shoot", function(...) return mod.ench.on_shoot(...) end)
game.add_hook("on_mon_death", function(...) return mod.on_monster_killed(...) end)
game.add_hook("on_game_started", function(...) return mod.on_game_load(...) end)
game.add_hook("on_game_load", function(...) return mod.on_game_load(...) end)

gapi.add_on_every_x_hook(TimeDuration.from_minutes(30), function(...) mod.ench_cond.moon_phase_update() end)

game.add_hook("on_character_wield", function(params)
  if params.who:is_avatar() then mod.ench_cond.weapon_category_update() end
end)

game.add_hook("on_character_unwield", function(params)
  if params.who:is_avatar() then mod.ench_cond.weapon_category_clear() end
end)

-- game.add_hook("on_dialogue_end", function(...) return mod.on_dialogue_end(...) end)
game.iuse_functions["DUCK_PERK_MENU"] = function(...) return mod.open_perks_menu(...) end
