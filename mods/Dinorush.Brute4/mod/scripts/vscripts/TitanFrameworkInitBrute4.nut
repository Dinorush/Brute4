global function Brute4_UIInit
void function Brute4_UIInit()
{
	#if BRUTE4_HAS_TITANFRAMEWORK
		ModdedTitanData Brute
		Brute.Name = "#DEFAULT_TITAN_6"
		Brute.Description = "#MP_TITAN_LOADOUT_DESC_BRUTE4"
		Brute.BaseSetFile = "titan_stryder_sniper"
		Brute.BaseName = "northstar"
		Brute.passiveDisplayNameOverride = "#TITAN_BRUTE4_PASSIVE_TITLE"
		Brute.titanReadyMessageOverride = "#HUD_BRUTE4_READY"
		Brute.difficulty = 1
		Brute.speedStat = 3
		Brute.damageStat = 3
		Brute.healthStat = 1
		Brute.titanHints = ["#DEATH_HINT_BRUTE4_001",
		"#DEATH_HINT_BRUTE4_002",
		"#DEATH_HINT_BRUTE4_003",
		"#DEATH_HINT_BRUTE4_004",
		"#DEATH_HINT_BRUTE4_005",
		"#DEATH_HINT_BRUTE4_006"]
		Brute.Melee = "melee_titan_punch_northstar"
		Brute.Voice = "titanos_northstar"
		Brute.icon = $"brute4/menu/brute4_icon_medium"

		ModdedTitanWeaponAbilityData RocketLauncher
		RocketLauncher.custom = true //when this is false titanframework will not create items, useful if you want to use default items
		RocketLauncher.displayName = "#WPN_TITAN_QUAD_ROCKET"
		RocketLauncher.weaponName = "mp_titanweapon_brute4_quad_rocket"
		RocketLauncher.description = "#WPN_TITAN_QUAD_ROCKET_LONGDESC"
		RocketLauncher.image = $"r2_ui/menus/loadout_icons/titan_weapon/titan_weapon_quad"
		Brute.Primary = RocketLauncher

		ModdedTitanWeaponAbilityData GrenadeLauncher
		GrenadeLauncher.custom = true
		GrenadeLauncher.displayName = "#WPN_TITAN_GRENADE_VOLLEY"
		GrenadeLauncher.weaponName = "mp_titanweapon_grenade_volley"
		GrenadeLauncher.description = "#WPN_TITAN_GRENADE_VOLLEY_DESC"
		GrenadeLauncher.image = $"brute4/menu/grenade_volley"
		Brute.Right = GrenadeLauncher

		ModdedTitanWeaponAbilityData BarrageCore
		BarrageCore.custom = true
		BarrageCore.weaponName = "mp_titancore_barrage_core"
		BarrageCore.displayName = "#TITANCORE_BARRAGE"
		BarrageCore.description = "#TITANCORE_BARRAGE_DESC"
		BarrageCore.image = $"brute4/hud/barrage_core"
		Brute.Core = BarrageCore

		ModdedTitanWeaponAbilityData DomeShield
		DomeShield.custom = true
		DomeShield.displayName = "#WPN_TITAN_MOBILE_DOME"
		DomeShield.weaponName = "mp_titanability_mobile_dome_shield"
		DomeShield.description = "#WPN_TITAN_MOBILE_DOME_DESC"
		DomeShield.image = $"brute4/menu/mobile_dome_shield"
		Brute.Left = DomeShield

		ModdedTitanWeaponAbilityData RocketSwap
		RocketSwap.custom = true
		RocketSwap.displayName = "#WPN_TITAN_CLUSTER_PAYLOAD"
		RocketSwap.weaponName = "mp_titanability_cluster_payload"
		RocketSwap.description = "#WPN_TITAN_CLUSTER_PAYLOAD_DESC"
		RocketSwap.image = $"brute4/menu/cluster_payload"
		Brute.Mid = RocketSwap

		ModdedPassiveData RocketStabilizers
		RocketStabilizers.Name = "#GEAR_BRUTE4_WEAPON"
		RocketStabilizers.description = "#GEAR_BRUTE4_WEAPON_LONGDESC"
		RocketStabilizers.image = $"brute4/menu/rocket_stabilizers"
		RocketStabilizers.customIcon = true
		Brute.passive2Array.append(RocketStabilizers)

		ModdedPassiveData MagneticRollers
		MagneticRollers.Name = "#GEAR_BRUTE4_GRENADE"
		MagneticRollers.description = "#GEAR_BRUTE4_GRENADE_LONGDESC"
		MagneticRollers.image = $"brute4/menu/magnetic_rollers"
		MagneticRollers.customIcon = true
		Brute.passive2Array.append(MagneticRollers)

		ModdedPassiveData MoltingShell
		MoltingShell.Name = "#GEAR_BRUTE4_DOME"
		MoltingShell.description = "#GEAR_BRUTE4_DOME_LONGDESC"
		MoltingShell.image = $"brute4/menu/molting_shell"
		MoltingShell.customIcon = true
		Brute.passive2Array.append(MoltingShell)

		ModdedPassiveData RapidDetonators
		RapidDetonators.Name = "#GEAR_BRUTE4_CLUSTER"
		RapidDetonators.description = "#GEAR_BRUTE4_CLUSTER_LONGDESC"
		RapidDetonators.image =  $"brute4/menu/rapid_detonators"
		RapidDetonators.customIcon = true
		Brute.passive2Array.append(RapidDetonators)

		ModdedPassiveData ExplosiveReserves
		ExplosiveReserves.Name = "#GEAR_BRUTE4_PAYLOAD"
		ExplosiveReserves.description ="#GEAR_BRUTE4_PAYLOAD_LONGDESC"
		ExplosiveReserves.image =  $"brute4/menu/explosive_reserves"
		ExplosiveReserves.customIcon = true
		Brute.passive2Array.append(ExplosiveReserves)

		ModdedPassiveData AgileFrame
		AgileFrame.Name = "#FD_UPGRADE_BRUTE4_UTILITY_TIER_1"
		AgileFrame.description = "#FD_UPGRADE_BRUTE4_UTILITY_TIER_1_DESC"
		AgileFrame.image = $"brute4/hud/agile_frame"
		AgileFrame.customIcon = false
		Brute.passiveFDArray.append(AgileFrame)

		ModdedPassiveData Chassis
		Chassis.Name = "#FD_UPGRADE_BRUTE4_DEFENSE_TIER_1"
		Chassis.description = "#FD_UPGRADE_BRUTE4_DEFENSE_TIER_1_DESC"
		Chassis.image = $"brute4/hud/fd_brute4_health_upgrade"
		Chassis.customIcon = false
		Brute.passiveFDArray.append(Chassis)

		ModdedPassiveData RocketStream
		RocketStream.Name = "#FD_UPGRADE_BRUTE4_WEAPON_TIER_1"
		RocketStream.description = "#FD_UPGRADE_BRUTE4_WEAPON_TIER_1_DESC"
		RocketStream.image = $"brute4/hud/rocket_stream",
		RocketStream.customIcon = false
		Brute.passiveFDArray.append(RocketStream)

		ModdedPassiveData Gliders
		Gliders.Name = "#FD_UPGRADE_BRUTE4_UTILITY_TIER_2"
		Gliders.description = "#FD_UPGRADE_BRUTE4_UTILITY_TIER_2_DESC"
		Gliders.image = $"brute4/hud/barrage_core_glider"
		Gliders.customIcon = false
		Brute.passiveFDArray.append(Gliders)

		ModdedPassiveData Shields
		Shields.Name = "#FD_UPGRADE_BRUTE4_DEFENSE_TIER_2"
		Shields.description = "#FD_UPGRADE_BRUTE4_DEFENSE_TIER_2_DESC"
		Shields.image = $"brute4/hud/fd_brute4_shield_upgrade"
		Shields.customIcon = false
		Brute.passiveFDArray.append(Shields)

		ModdedPassiveData GrenadeSwarm
		GrenadeSwarm.Name = "#FD_UPGRADE_BRUTE4_WEAPON_TIER_2"
		GrenadeSwarm.description = "#FD_UPGRADE_BRUTE4_WEAPON_TIER_2_DESC"
		GrenadeSwarm.image = $"brute4/hud/grenade_swarm"
		GrenadeSwarm.customIcon = false
		Brute.passiveFDArray.append(GrenadeSwarm)

		ModdedPassiveData Pyrotechnics
		Pyrotechnics.Name = "#FD_UPGRADE_BRUTE4_ULTIMATE"
		Pyrotechnics.description = "#FD_UPGRADE_BRUTE4_ULTIMATE_DESC"
		Pyrotechnics.image = $"brute4/hud/pyrotechnics"
		Pyrotechnics.customIcon = false
		Brute.passiveFDArray.append(Pyrotechnics)

		CreateModdedTitanSimple(Brute)
	#endif
}
