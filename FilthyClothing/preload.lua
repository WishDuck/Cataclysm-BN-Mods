local mod = game.mod_runtime[game.current_mod]

local storage = game.mod_storage[game.current_mod]

mod.stor = storage

game.add_hook("on_mon_death", function(...) return mod.make_clothing_dirty(...) end)

gapi.add_on_every_x_hook(TimeDuration.from_minutes(30), function(...) return mod.give_morale_and_sweat(...) end)

game.iuse_functions["LUA_WASH"] = function(...) return mod.wash(...) end
