## Duck Perks

A port of the [Bombastic Perks](https://github.com/CleverRaven/Cataclysm-DDA/tree/master/data/mods/BombasticPerks) mod from Cataclysm-DDA for Cataclysm-BN.

The mod was renamed to "Duck Perks" as BombasticSlacks ( the original author ) has nothing to do with this port and there will be major divergence over time.

## Other Mod Compatibility

### Adding More Perks

You must first depend on this mod, then within `main.lua` call
`game.mod_storage["duck_perks"].add_perks(params, "name_of_perk_subset_for_debugging")`

`params` is simple it is a vector of the following lua object

| value | mandatory | type | purpose |
| ----- | --------- | ---- | ------- |
| id    | true      | PerkId | Perk to grant when selected |
| condition_string | true | string | Human readable string for prerequisites, pre-translated |
| condition | true | function taking a character | Function that returns weather the player can choose this perk |
| show_if_condition_false | false | bool | ( default true ) If condition is false, still show it. Generally useful if certain perks can never be earned after condition is false |
| major | false | bool | ( default false ) If this is true, it can only be gotten with major perk points, if false, only with minor perk points |
