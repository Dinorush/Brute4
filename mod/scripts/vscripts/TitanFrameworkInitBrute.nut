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
		Brute.icon = $"brute/hud/brute_icon_medium"

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
		GrenadeLauncher.image = $"brute/menu/grenade_launcher"
		Brute.Right = GrenadeLauncher

		ModdedTitanWeaponAbilityData BarrageCore
		BarrageCore.custom = true
		BarrageCore.weaponName = "mp_titancore_barrage_core"
		BarrageCore.displayName = "#TITANCORE_BARRAGE"
		BarrageCore.description = "#TITANCORE_BARRAGE_DESC"
		BarrageCore.image = $"brute/menu/barrage_core"
		Brute.Core = BarrageCore

		ModdedTitanWeaponAbilityData DomeShield
		DomeShield.custom = true
		DomeShield.displayName = "#WPN_TITAN_MOBILE_DOME"
		DomeShield.weaponName = "mp_titanability_mobile_dome_shield"
		DomeShield.description = "#WPN_TITAN_MOBILE_DOME_DESC"
		DomeShield.image = $"brute/menu/dome_shield"
		Brute.Left = DomeShield

		ModdedTitanWeaponAbilityData RocketSwap
		RocketSwap.custom = true
		RocketSwap.displayName = "#WPN_TITAN_CLUSTER_PAYLOAD"
		RocketSwap.weaponName = "mp_titanability_cluster_payload"
		RocketSwap.description = "#WPN_TITAN_CLUSTER_PAYLOAD_DESC"
		RocketSwap.image = $"brute/menu/rocket_swap"
		Brute.Mid = RocketSwap

		ModdedPassiveData RocketStabilizers
		RocketStabilizers.Name = "#GEAR_BRUTE4_WEAPON"
		RocketStabilizers.description = "#GEAR_BRUTE4_WEAPON_LONGDESC"
		RocketStabilizers.image = $"brute/menu/rocket_stabilizers"
		RocketStabilizers.customIcon = true
		Brute.passive2Array.append(RocketStabilizers)

		ModdedPassiveData MagneticRollers
		MagneticRollers.Name = "#GEAR_BRUTE4_GRENADE"
		MagneticRollers.description = "#GEAR_BRUTE4_GRENADE_LONGDESC"
		MagneticRollers.image = $"brute/menu/magnetic_rollers"
		MagneticRollers.customIcon = true
		Brute.passive2Array.append(MagneticRollers)

		ModdedPassiveData MoltingShell
		MoltingShell.Name = "#GEAR_BRUTE4_DOME"
		MoltingShell.description = "#GEAR_BRUTE4_DOME_LONGDESC"
		MoltingShell.image = $"brute/menu/molting_shell"
		MoltingShell.customIcon = true
		Brute.passive2Array.append(MoltingShell)

		ModdedPassiveData RapidDetonators
		RapidDetonators.Name = "#GEAR_BRUTE4_CLUSTER"
		RapidDetonators.description = "#GEAR_BRUTE4_CLUSTER_LONGDESC"
		RapidDetonators.image =  $"brute/menu/rapid_detonators"
		RapidDetonators.customIcon = true
		Brute.passive2Array.append(RapidDetonators)

		ModdedPassiveData ExplosiveReserves
		ExplosiveReserves.Name = "#GEAR_BRUTE4_PAYLOAD"
		ExplosiveReserves.description ="#GEAR_BRUTE4_PAYLOAD_LONGDESC"
		ExplosiveReserves.image =  $"brute/menu/explosive_reserves"
		ExplosiveReserves.customIcon = true
		Brute.passive2Array.append(ExplosiveReserves)

		CreateModdedTitanSimple(Brute)
	#endif
}
