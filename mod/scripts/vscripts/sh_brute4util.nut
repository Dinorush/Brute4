untyped
global function GiveBrute4
global function Brute4_Init

const array<int> PRESERVE_PASSIVES = [ ePassives.PAS_AUTO_EJECT, ePassives.PAS_ENHANCED_TITAN_AI, ePassives.PAS_WARPFALL, ePassives.PAS_HYPER_CORE ]

struct {
	array<entity> reminded // Used to only give players the HUD message on the first drop per match
} file

void function Brute4_Init()
{
	#if SERVER
	RegisterWeaponDamageSources(
		{
			mp_titanweapon_barrage_core_launcher = "Barrage Core",
			mp_titanweapon_grenade_launcher = "Grenade Launcher"
		}
	)
	#endif

	MpTitanAbilityBrute4DomeShield_Init()
	MpTitanweaponGrenadeLauncher_Init()
	BarrageCore_Init()
	#if SERVER
	GameModeRulesRegisterTimerCreditException( eDamageSourceId.mp_titanweapon_barrage_core_launcher )
	//SetGameModeRulesShouldGiveTimerCredit( ShouldGiveTimerCredit_Brute4 )
	AddSpawnCallback( "npc_titan", Brute4_ReplaceNSPrime )
	#endif
}

array<string> function Brute4_GetAllowedChassis()
{
	string cvar = GetConVarString( "brute4_allowed_chassis" )
	cvar = StringReplace( cvar, " ", "" )
	return split( cvar.tolower(), "," )
}

void function GiveBrute4( int index = 0 )
{
	#if SERVER
	entity player = GetPlayerArray()[index]

	if ( player.IsTitan() && ( GetConVarBool( "brute4_unlock_chassis" ) || Brute4_GetAllowedChassis().contains( GetTitanCharacterName( player ) ) ) )
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

void function Brute4_ReplaceGear( entity titan )
{
	TakeAllWeapons( titan )

	titan.GiveOffhandWeapon( "mp_titanability_rocketeer_ammo_swap", OFFHAND_ANTIRODEO )
	titan.GiveOffhandWeapon( "mp_titanability_brute4_bubble_shield", OFFHAND_LEFT )
	titan.GiveOffhandWeapon( "mp_titanweapon_grenade_launcher", OFFHAND_RIGHT )
	titan.GiveOffhandWeapon( "mp_titancore_barrage_core", OFFHAND_EQUIPMENT )
	titan.GiveWeapon( "mp_titanweapon_rocketeer_rocketstream" )

	entity soul = titan.GetTitanSoul()
	if ( !IsValid( soul ) )
		return

	foreach ( passive, hasPassive in soul.passives )
	{
		int passiveVal = expect int( passive )
		if ( hasPassive && !PRESERVE_PASSIVES.contains( passiveVal ) )
			TakePassive( soul, passiveVal )
	}
}

bool function ShouldGiveTimerCredit_Brute4( entity player, entity victim, var damageInfo )
{
    if ( player == victim )
        return false

    if ( player.IsTitan() && !IsCoreAvailable( player ) )
        return false

    if ( GAMETYPE == FREE_AGENCY && !player.IsTitan() )
        return false

    int damageSourceID = DamageInfo_GetDamageSourceIdentifier( damageInfo )
    switch ( damageSourceID )
    {
        case eDamageSourceId.mp_titanweapon_barrage_core_launcher:
        case eDamageSourceId.mp_titancore_flame_wave:
        case eDamageSourceId.mp_titancore_flame_wave_secondary:
        case eDamageSourceId.mp_titancore_salvo_core:
        case damagedef_titan_fall:
        case damagedef_nuclear_core:
            return false
    }

    return true
}
#endif
