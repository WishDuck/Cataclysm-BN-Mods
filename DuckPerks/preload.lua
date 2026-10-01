local mod = game.mod_runtime[game.current_mod]

-- game.add_hook("on_mon_death", function(...) return mod.on_monster_killed(...) end)
game.add_hook("on_game_started", function(...) return mod.on_game_load(...) end)
game.add_hook("on_game_load", function(...) return mod.on_game_load(...) end)
-- game.add_hook("on_dialogue_end", function(...) return mod.on_dialogue_end(...) end)
game.iuse_functions["DUCK_PERK_MENU"] = function(...) return mod.open_perks_menu(...) end
