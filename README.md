# Brute 4

**Required by Server and Client**

Implements the Brute4 titan based on cut content.

### Activation

Use peepee.TitanFramework's titan selection to pick Brute4.

## [Loadout](https://youtu.be/enGWYx5sIws)
*Weapon*: Quad Rocket

* Primary fire: Fires 4 rockets with a spiral flight path.
* Alt fire: Fires a single, stronger, faster rocket for 2 ammo.

*Offensive*: Grenade Volley

* Fires a rapid burst of grenades that arm on contact.

*Defensive*: Mobile Dome Shield

* Deploys a mobile Dome Shield that loses health over time and breaks when attacking or dashing. Disables sprinting.

*Utility*: Cluster Payload

* Reloads Quad Rocket with 4 single-fire cluster-loaded rockets.

*Core*: Barrage Core

* Rapidly fires cluster-loaded explosives.

### Kits

**Rocket Stabilizer**

- Quad rockets fly straight and grow closer over time.

**Magnetic Rollers**

- Grenades bounce much farther and become magnetic after bouncing.

**Molting Shell**

- When broken, Mobile Dome Shield refills a dash and refunds some remaining duration.

**Rapid Detonators**

- Cluster Payload fires faster and all clusters explode more quickly.

**Explosive Reserves**

- Cluster Payload has two charges.

### Aegis Upgrades

**Agile Frame**

- Removes all sprinting restrictions.

**Rocket Stream**

- Quad Rocket and Cluster payload fire faster and hold more ammo.

**Quick Load**

- Cluster Payload loads faster and recharges while in use.

**Grenade Swarm**

- Grenade Volley fires twice as many grenades.

**Pyrotechnics**

- Explosions always deal maximum damage.

## Credits

- Galactic Moblin - Custom UI Elements
- Hurb - Custom UI Elements

## Patch Notes

### 1.8.0

#### Balancing

- Quad Rocket
  - Optimal explosion radius: 0m → 1m

#### Miscellaneous

- General
  - Added Aegis Upgrades
  - Added more localization text
  - Updated some UI elements and icons
  - Now uses TitanFramework to select Brute4 instead of prime Northstar

- Barrage Core
  - No longer causes allied AI to run away from clusters

- Grenade Launcher
  - Renamed to Grenade Volley

- Ammo Swap
  - Renamed to Cluster Payload

### 1.7.3

- Barrage Core
  - Dash lock now starts when weapon starts deploying
  - Fixed sprint lock not applying correctly
  - Fixed clusters spawning more than they should in some scenarios

### 1.7.2

- Ammo Swap
  - Fixed cooldown not occurring

### 1.7.1

#### Bug Fixes

- Fixed a syntax error that snuck in

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