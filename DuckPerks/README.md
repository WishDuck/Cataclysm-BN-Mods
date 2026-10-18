## Duck Perks

A port of the [Bombastic Perks](https://github.com/CleverRaven/Cataclysm-DDA/tree/master/data/mods/BombasticPerks) mod from Cataclysm-DDA for Cataclysm-BN.

The mod was renamed to "Duck Perks" as BombasticSlacks ( the original author ) has nothing to do with this port and there will be major divergence over time.

## Other Mod Compatibility

### Adding More Perks

You must first depend on this mod, then within `main.lua` call
`game.mod_storage["duck_perks"].add_perks(params, "name_of_perk_subset_for_debugging")`

`params` is simple it is a vector of the following lua object

| value                   | mandatory | type                        | purpose                                                                                                                               |
| ----------------------- | --------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| id                      | true      | PerkId                      | Perk to grant when selected                                                                                                           |
| condition_string        | true      | string                      | Human readable string for prerequisites, pre-translated                                                                               |
| condition               | true      | function taking a character | Function that returns weather the player can choose this perk                                                                         |
| show_if_condition_false | false     | bool                        | ( default true ) If condition is false, still show it. Generally useful if certain perks can never be earned after condition is false |
| major                   | false     | bool                        | ( default false ) If this is true, it can only be gotten with major perk points, if false, only with minor perk points                |

### Enchantment Conditions

Some useful enchantment conditions for use in other mods are as follows

Any definition method only defines the condition function for usage within the enchantment condition json

Note that all of these only check against the avatar for caching purposes.

#### Weapon Category Conditions

##### Existing

| condition                   | purpose                                                        |
| --------------------------- | -------------------------------------------------------------- |
| DUCK_WIELDED_SHOTGUN        | Checks if a shotgun is wielded                                 |
| DUCK_WIELDED_PISTOL         | Checks if a pistol is wielded                                  |
| DUCK_WIELDED_DUELING_SWORDS | Checks if a dueling sword is wielded                           |
| DUCK_WIELDED_NONE           | Checks if nothing, or something without a category, is wielded |

##### How to add more
To add new functions for weapon category conditions, call 
`game.mod_storage["duck_perks"].ench_cond.add_weapon_cat_condition(condition_id, weapon_category)`

#### Moon Phase Conditions

##### Existing

| condition                | purpose                                                               |
| ------------------------ | --------------------------------------------------------------------- |
| DUCK_NEW_MOON            | Checks if it is a new moon                                            |
| DUCK_WAXING_CRECENT_MOON | Checks if it is a waxing crecent moon                                 |
| DUCK_WAXING_HALF_MOON    | Checks if it is a waxing half moon                                    |
| DUCK_WAXING_GIBBOUS_MOON | Checks if it is a waxing gibbuous moon                                |
| DUCK_FULL_MOON           | Checks if it is a full moon                                           |
| DUCK_WANING_GIBBOUS_MOON | Checks if it is a waning gibbuous moon                                |
| DUCK_WANING_HALF_MOON    | Checks if it is a waning half moon                                    |
| DUCK_WANING_CRECENT_MOON | Checks if it is a waning crecent moon                                 |
| DUCK_WAXING_MOON         | Checks if it is a waxing crecent, waxing half, or waxing gibbous moon |
| DUCK_WANING_MOON         | Checks if it is a waning crecent, waning half, or waning gibbous moon |

##### How to add more
To add new functions for moon phase category conditions, call 
`game.mod_storage["duck_perks"].add_multi_moon_phase_condition(condition_id, moon_phase_enum_vector)`

#### Stylish Conditions

##### Existing

| condition                   | purpose                                                        |
| --------------------------- | -------------------------------------------------------------- |
| DUCK_STYLISH                | Checks if stylish value > 5 ( +1 for fancy, +3 for very )      |
| DUCK_VERY_STYLISH           | Checks if stylish value > 10 ( +1 for fancy, +3 for very )     |
| DUCK_SUPREMELY_STYLISH      | Checks if stylish value > 20 ( +1 for fancy, +3 for very )     |

##### How to add more
To add new functions for moon phase category conditions, call 
`game.mod_storage["duck_perks"].init_stylish_condition(condition_id, minimum_value)`

#### Misc Conditions

| condition                   | purpose                                                        |
| --------------------------- | -------------------------------------------------------------- |
| DUCK_SLEEPY | When the player is tired or nearly tired |
| DUCK_NEAR_ELECTRICITY | When it is a thunderstorm or the player is near shocker esque creatures ( note: this is likely performance intensive and uncached ) |
| DUCK_LONE_WOLF | When there are no allies to the player |

