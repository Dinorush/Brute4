# Brute 4

**Required by Server and Client**

Implements the Brute4 titan based on cut content.

### Activation

Equip Northstar prime; Brute4 will replace its loadout on drop.

### For Testing/Modding
With **sv_cheats** on, you can give the loadout to the first player by running `script GiveBrute4()`. Player index can be specified if desired, e.g. `script GiveBrute4(2)`. The ConVar `brute4_replace_ns_prime` can also be set to 0 to stop the mod from replacing Northstar prime automatically.

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

## Credits

- Galactic Moblin - Custom UI Elements
- Hurb - Custom UI Elements

## Patch Notes

### 1.7

#### Balancing

- Barrage Core
  - Duration: 6s → 5.5s
  - Deploy time: 0.6s → 0.5s
    - Total firing duration: 4.9s → 4.5s
  - Cluster spawn count: 6 → 5
  - Cluster duration: 1.5s → 1.25s
  - No longer deals self damage
  - Now prevents sprinting
  - Now prevents dashing

- Rapid Detonators
  - Fire rate modifier: 1.2x → 1.15x
  - Cluster spawn time modifier: 0.7x → 0.8x

#### Bug Fixes

- Molten Shell
  - Fixed more occasional crashes

#### Miscellaneous

- Changed Brute4's Quad Rocket and Ammo Swap to internally be new weapons to be more compatible with vanilla Brute mods
- Changed method of replacing strings to be more compatible with other custom titan mods (e.g. Archon)

### Prior releases

- Visible on Github release page