# Brute 4

**Required by Server and Client**

Implements the Brute4 titan based on cut content.

### Activation

Equip Northstar prime; Brute4 will replace its loadout on drop.

### ConVars for Testing
With **sv_cheats** on, you can give the loadout to the first player by running `script GiveBrute4()`. Player index can be specified if desired, e.g. `script GiveBrute4(2)`. Ordinarily, this command only works for Northstar, but the behavior can be adjusted with three convars:

* `brute4_replace_ns_prime`: Default value of `1`. Causes Brute4 to replace the loadout of any Northstar Prime that drops. Independent of other two ConVars.
* `brute4_allowed_chassis`: Default value of `northstar`. Any titan on the list can be given Brute4. Takes a comma separated list of titan names. (Note: Monarch is `vanguard`)
* `brute4_unlock_chassis`: Default value of `0`. Set to `1` to allow any titan to be given Brute4, overriding `brute4_allowed_chassis`.

## [Loadout](https://youtu.be/enGWYx5sIws)
*Weapon*: Quad Rocket

* Primary fire: Fires 4 rockets with a spiral flight path.
* Alt fire: Fires a single, stronger, faster rocket for 2 ammo.

*Offensive*: Grenade Launcher

* Fires a burst of delayed-impact detonated grenades.

*Defensive*: Dome Shield

* Deploys a mobile Dome Shield that loses health over time and breaks when attacking or dashing. Disables sprinting.

*Utility*: Ammo Swap

* Reloads Quad Rocket with 4 single-fire cluster-loaded rockets.

*Core*: Barrage Core

* Rapidly fires cluster-loaded explosives.

### Kits

**Rocket Stabilizer** (Tied to _Piercing Shot_)

- Quad rockets fly straight and grow closer over time.

**Magnetic Rollers** (Tied to _Enhanced Payload_)

- Grenades bounce much farther and become magnetic after bouncing.

**Molting Shell** (Tied to _Twin Traps_)

- When broken, Dome Shield refills a dash and refunds some remaining duration.

**Rapid Detonators** (Tied to _Viper Thrusters_)

- Ammo Swap fires faster and all clusters explode more quickly.

**Explosive Reserves** (Tied to _Threat Optics_)

- Ammo Swap has two charges.
