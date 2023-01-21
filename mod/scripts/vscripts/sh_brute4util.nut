untyped
global function GiveBrute4
global function Brute4_Init

struct {
	array<entity> reminded // Used to only give players the HUD message on the first drop per match
} file

void function Brute4_Init()
{
	#if SERVER
	RegisterWeaponDamageSources(
		{
			mp_titanweapon_brute4_quad_rocket = "#WPN_TITAN_ROCKET_LAUNCHER",
			mp_titanweapon_barrage_core_launcher = "Barrage Core",
			mp_titanweapon_grenade_launcher = "Grenade Launcher"
		}
	)
	#endif

	Brute4_InitWeaponsAndPassives()
	
	#if SERVER
	GameModeRulesRegisterTimerCreditException( eDamageSourceId.mp_titanweapon_barrage_core_launcher )
	AddSpawnCallback( "npc_titan", Brute4_ReplaceNSPrime )
	//AddCallback_OnTryGetTitanLoadout( Brute4_ReplaceLoadout )
	#endif
}

void function Brute4_InitWeaponsAndPassives()
{
	// Brute4_AddPassive( "PAS_BRUTE4_WEAPON" )
	// Brute4_AddPassive( "PAS_BRUTE4_GRENADE" )
	// Brute4_AddPassive( "PAS_BRUTE4_CLUSTER" )
	// Brute4_AddPassive( "PAS_BRUTE4_AMMO" )
	// Brute4_AddPassive( "PAS_BRUTE4_BUBBLE" )
	MpTitanweaponBrute4QuadRocket_Init()
	MpTitanAbilityBrute4AmmoSwap_Init()
	MpTitanAbilityBrute4DomeShield_Init()
	MpTitanweaponGrenadeLauncher_Init()
	BarrageCore_Init()
}

void function Brute4_AddPassive( string name )
{
	if ( name in ePassives )
		return

	table passives = expect table( getconsttable()["ePassives"] )
	int newVal = passives.len() // ePassives starts at 0
	passives[name] <- newVal
	table passivesFromEnum = expect table( getconsttable()["_PassiveFromEnum"] )
	passivesFromEnum[name.tolower()] <- newVal
}

void function GiveBrute4( int index = 0 )
{
	#if SERVER
	entity player = GetPlayerArray()[index]

	if ( player.IsTitan() )
		Brute4_ReplaceGear( player )
	#endif
}

#if SERVER
void function Brute4_ReplaceNSPrime( entity titan )
{
	if ( !IsValid( titan ) )
		return

	if ( titan.GetModelName() != $"models/titans/light/titan_light_northstar_prime.mdl" )
		return

	if ( !GetConVarBool( "brute4_replace_ns_prime" ) )
		return

	entity player = GetPetTitanOwner( titan )
	if ( IsValid( player ) && !file.reminded.contains( player ) )
	{
		SendHudMessage( player, "Brute4 Loadout Applied\n To use regular loadout, unequip prime titan skin.",  -1, 0.7, 200, 200, 225, 255, 0.15, 6, 1 )
		file.reminded.append( player )
	}

	Brute4_ReplaceGear( titan )
}

sTryGetTitanLoadoutCallbackReturn function Brute4_ReplaceLoadout( entity titan, TitanLoadoutDef loadout, bool wasChanged )
{
	sTryGetTitanLoadoutCallbackReturn ret

	if ( !GetConVarBool( "brute4_replace_ns_prime" ) )
		return ret

	if ( loadout.titanClass != "northstar" || loadout.isPrime != "titan_is_prime" )
		return ret

	ret.loadout = loadout
	ret.loadout.primary = "mp_titanweapon_brute4_quad_rocket"
	ret.loadout.primaryMods = []
	ret.loadout.ordnance = "mp_titanweapon_grenade_launcher"
	ret.loadout.ordnanceMods = []
	ret.loadout.special = "mp_titanability_brute4_bubble_shield"
	ret.loadout.specialMods = []
	ret.loadout.antirodeo = "mp_titanability_brute4_ammo_swap"
	ret.loadout.antirodeoMods = []

	if ( ret.loadout.passive2 != "" )
	{
		switch( _PassiveFromEnum[ret.loadout.passive2] )
		{
			case ePassives.PAS_NORTHSTAR_WEAPON:
				ret.loadout.passive2 = "pas_brute4_weapon"
				ret.loadout.primaryMods.append( "straight_shot" )
				break

			case ePassives.PAS_NORTHSTAR_CLUSTER:
				ret.loadout.passive2 = "pas_brute4_grenade"
				ret.loadout.ordnanceMods.append( "magnetic_rollers" )
				break

			case ePassives.PAS_NORTHSTAR_FLIGHTCORE:
				ret.loadout.passive2 = "pas_brute4_cluster"
				ret.loadout.primaryMods.append( "rapid_detonators" )
				break
			
			case ePassives.PAS_NORTHSTAR_OPTICS:
				ret.loadout.passive2 = "pas_brute4_ammo"
				ret.loadout.antirodeoMods.append( "explosive_reserves" )
				break

			case ePassives.PAS_NORTHSTAR_TRAP:
				ret.loadout.passive2 = "pas_brute4_bubble"
				ret.loadout.specialMods.append( "molting_dome" )
				break
		}
	}

	ret.wasChanged = true
	ret.runMoreCallbacks = false
	return ret
}

void function Brute4_HandlePassives( entity titan )
{
	entity soul = titan.GetTitanSoul()
	if ( soul.passives.len() == GetNumPassives() )
		soul.passives.append( false )
	soul.passives.extend( [ false, false, false, false, false ] )

	entity player = GetPetTitanOwner( titan )
	if ( IsValid( player ) && !file.reminded.contains( player ) )
	{
		SendHudMessage( player, "Brute4 Loadout Applied\n To use regular loadout, unequip prime titan skin.",  -1, 0.7, 200, 200, 225, 255, 0.15, 6, 1 )
		file.reminded.append( player )
	}
}

void function Brute4_ReplaceGear( entity titan )
{
	TakeAllWeapons( titan )

	titan.GiveOffhandWeapon( "mp_titanability_brute4_ammo_swap", OFFHAND_ANTIRODEO )
	titan.GiveOffhandWeapon( "mp_titanability_brute4_bubble_shield", OFFHAND_LEFT )
	titan.GiveOffhandWeapon( "mp_titanweapon_grenade_launcher", OFFHAND_RIGHT )
	titan.GiveOffhandWeapon( "mp_titancore_barrage_core", OFFHAND_EQUIPMENT )
	titan.GiveOffhandWeapon( "melee_titan_punch_northstar", OFFHAND_MELEE )
	titan.GiveWeapon( "mp_titanweapon_brute4_quad_rocket" )

	entity soul = titan.GetTitanSoul()
	if ( !IsValid( soul ) )
		return

	if ( SoulHasPassive( soul, ePassives.PAS_NORTHSTAR_WEAPON ) )
		titan.GetMainWeapons()[0].AddMod( "straight_shot" )

	if ( SoulHasPassive( soul, ePassives.PAS_NORTHSTAR_CLUSTER ) )
		titan.GetOffhandWeapon( OFFHAND_RIGHT ).AddMod( "magnetic_rollers" )

	if ( SoulHasPassive( soul, ePassives.PAS_NORTHSTAR_FLIGHTCORE ) )
	{
		titan.GetOffhandWeapon( OFFHAND_EQUIPMENT ).AddMod( "rapid_detonator" )
		titan.GetMainWeapons()[0].AddMod( "rapid_detonator" )
	}
	
	if ( SoulHasPassive( soul, ePassives.PAS_NORTHSTAR_OPTICS ) )
		titan.GetOffhandWeapon( OFFHAND_TITAN_CENTER ).AddMod( "explosive_reserves" )

	if ( SoulHasPassive( soul, ePassives.PAS_NORTHSTAR_TRAP ) )
		titan.GetOffhandWeapon( OFFHAND_LEFT ).AddMod( "molting_dome" )
}
#endif
