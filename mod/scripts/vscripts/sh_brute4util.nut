untyped
global function GiveBrute4
global function Brute4Precache

struct {
	var  chassis 

}titanchassis

void function Brute4Precache()
{
    PrecacheWeapon( "mp_titanability_brute4_bubble_shield" )
	PrecacheWeapon( "mp_titancore_cluster_barrage" )
	PrecacheWeapon( "mp_titanweapon_cluster_barrage" )
	PrecacheWeapon( "mp_titanweapon_grenade_launcher" )
	PrecacheWeapon( "mp_titanweapon_flightcore_rockets" )

    RegisterWeaponDamageSources({
        mp_titanweapon_cluster_barrage = "Cluster Barrage",
        mp_titanweapon_grenade_launcher = "Grenade Launcher"
    })
}

void function GiveBrute4(int index = 0)
{
    

	#if SERVER
		entity player = GetPlayerArray()[index]

		if( player.IsTitan() && ( GetTitanCharacterName( player ) == "northstar" ||  player.IsTitan() && GetTitanCharacterName( player ) == "ronin" ) )
		{
            array<entity> weapons = player.GetMainWeapons()
            player.TakeWeapon(weapons[0].GetWeaponClassName())
            player.GiveWeapon("mp_titanweapon_rocketeer_rocketstream")
            player.SetActiveWeaponByName("mp_titanweapon_rocketeer_rocketstream")
            player.TakeOffhandWeapon(OFFHAND_SPECIAL)
            player.GiveOffhandWeapon("mp_titanability_brute4_bubble_shield", OFFHAND_SPECIAL)
            player.TakeOffhandWeapon(OFFHAND_ANTIRODEO)
            player.GiveOffhandWeapon("mp_titanability_rocketeer_ammo_swap", OFFHAND_ANTIRODEO)
            player.TakeOffhandWeapon(OFFHAND_RIGHT)
            player.GiveOffhandWeapon("mp_titanweapon_grenade_launcher", OFFHAND_RIGHT)
            player.TakeOffhandWeapon(OFFHAND_EQUIPMENT)
            player.GiveOffhandWeapon("mp_titancore_cluster_barrage", OFFHAND_EQUIPMENT)
		}
	#endif
    
}