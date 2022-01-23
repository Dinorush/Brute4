untyped
global function GiveBrute4
global function Brute4_Init

const array<int> PRESERVE_PASSIVES = [ ePassives.PAS_AUTO_EJECT, ePassives.PAS_ENHANCED_TITAN_AI, ePassives.PAS_WARPFALL, ePassives.PAS_HYPER_CORE ]

void function Brute4_Init()
{
    RegisterWeaponDamageSources(
        {
            mp_titanweapon_barrage_core_launcher = "Barrage Core",
            mp_titanweapon_grenade_launcher = "Grenade Launcher"
        }
    )

    MpTitanAbilityBrute4DomeShield_Init()
    MpTitanweaponGrenadeLauncher_Init()
	BarrageCore_Init()
}

array<string> function Brute4_GetAllowedChassis()
{
    string cvar = GetConVarString( "brute4_allowed_chassis" )
    cvar = StringReplace( cvar, " ", "" )
    return split( cvar.tolower(), "," )
}

void function GiveBrute4( int index = 0 )
{
    entity player = GetPlayerArray()[index]

    if ( player.IsTitan() && ( GetConVarBool( "brute4_unlock_chassis" ) || Brute4_GetAllowedChassis().contains( GetTitanCharacterName( player ) ) ) )
    {
        array<entity> weapons = player.GetMainWeapons()
        player.TakeWeaponNow( weapons[0].GetWeaponClassName() )
        player.GiveWeapon( "mp_titanweapon_rocketeer_rocketstream" )
        player.SetActiveWeaponByName( "mp_titanweapon_rocketeer_rocketstream" )
        player.TakeOffhandWeapon( OFFHAND_SPECIAL )
        player.GiveOffhandWeapon( "mp_titanability_brute4_bubble_shield", OFFHAND_SPECIAL )
        player.TakeOffhandWeapon( OFFHAND_ANTIRODEO )
        player.GiveOffhandWeapon( "mp_titanability_rocketeer_ammo_swap", OFFHAND_ANTIRODEO )
        player.TakeOffhandWeapon( OFFHAND_RIGHT )
        player.GiveOffhandWeapon( "mp_titanweapon_grenade_launcher", OFFHAND_RIGHT )
        player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
        player.GiveOffhandWeapon( "mp_titancore_barrage_core", OFFHAND_EQUIPMENT )

        #if SERVER
        entity soul = player.GetTitanSoul()
        foreach ( passive, hasPassive in soul.passives )
        {
            int passiveVal = expect int( passive )
            if ( hasPassive && !PRESERVE_PASSIVES.contains( passiveVal ) )
                TakePassive( soul, passiveVal )
        }
        #endif
    }
}