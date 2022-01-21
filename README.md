# Brute 4

**Required by Server and Client**

Implements the Brute4 titan based on cut content.

### Activation

Requires **sv_cheats**. Be a Northstar and run `script GiveBrute4()` to give the loadout to the first player. Player index can be specified if desired, e.g. `script GiveBrute4(2)`.

### ConVars
Brute4 has two convars to control which titans Brute4 can be put on.

* `brute4_allowed_chassis`: Default value of `northstar`. Any titan on the list can be given Brute4. Takes a comma separated list of titan names. (Note: Monarch is `vanguard`)
* `brute4_unlock_chassis`: Default value of `0`. Set to `1` to allow any titan to be given Brute4, overriding `brute4_allowed_chassis`.

## [Loadout](https://youtu.be/enGWYx5sIws)
*Weapon*: Quad Rocket

* Primary fire: Fires 4 rockets with a spiral flight path.
* Alt fire: Fires a single, stronger, faster rocket for 2 ammo.

*Offensive*: Grenade Launcher

* Fires a burst of delayed-impact detonated grenades.

*Defensive*: Dome Shield

* Deploys a mobile Dome Shield that breaks by attacking, dashing, or from taking enough damage. Disables sprinting.

*Utility*: Ammo Swap

* Reloads Quad Rocket with 4 single-fire cluster-loaded rockets.

*Core*: Cluster Barrage

* Rapidly fires cluster-loaded explosives.

## Version History

### Version 1.1

* Added ConVars to control which chassis Brute4 can be given to

* Quad Rocket
  * Can no longer fire in the middle of ADSing
  * Normal fire projectile speed: 2000 > 2400

* Dome Shield
  * No longer blocks dashing 
  * No longer slows by 10%
  * Breaks upon dashing

* Bug Fixes
  * Should actually run now
  * Changed a few method calls that could cause conflicts for other mods
  * Dome Shield no longer disappears immediately if used after calling in a titan with Dome Shield.
  * Ammo Swap no longer disables Dome Shield during startup

### Version 1.0

* Released Mod