global function ClusterBarrage_Init

global function OnAbilityStart_ClusterBarrage
global function OnAbilityEnd_ClusterBarrage

//global const FLIGHT_CORE_IMPACT_FX = $"droppod_impact"

void function ClusterBarrage_Init()
{
//	PrecacheParticleSystem( FLIGHT_CORE_IMPACT_FX )
	PrecacheWeapon( "mp_titanweapon_cluster_barrage" )
}

bool function OnAbilityStart_ClusterBarrage( entity weapon )
{
	if ( !OnAbilityCharge_TitanCore( weapon ) )
		return false

#if SERVER
	OnAbilityChargeEnd_TitanCore( weapon )
#endif

	OnAbilityStart_TitanCore( weapon )

	entity titan = weapon.GetOwner() // GetPlayerFromTitanWeapon( weapon )

#if SERVER
	if ( titan.IsPlayer() )
		Melee_Disable( titan )
	thread PROTO_ClusterBarrage( titan, weapon.GetCoreDuration() )
#else
	if ( titan.IsPlayer() && (titan == GetLocalViewPlayer()) && IsFirstTimePredicted() )
		Rumble_Play( "rumble_titan_hovercore_activate", {} )
#endif

	return true
}

void function OnAbilityEnd_ClusterBarrage( entity weapon )
{
	entity titan = weapon.GetWeaponOwner()
	#if SERVER
	OnAbilityEnd_TitanCore( weapon )
int currAmmo = weapon.GetWeaponPrimaryClipCount()
	
	if(currAmmo == 0)
	{
		titan.Signal( "CoreEnd" )
	}

	if ( titan != null )
	{
		if ( titan.IsPlayer() )
			Melee_Enable( titan )
		titan.Signal( "CoreEnd" )
	}
	#else
		if ( titan.IsPlayer() )
			TitanCockpit_PlayDialog( titan, "flightCoreOffline" )
	#endif
}

#if SERVER
//HACK - Should use operator functions from Joe/Steven W
void function PROTO_ClusterBarrage( entity titan, float flightTime )
{
	if ( !titan.IsTitan() )
		return

	table<string, bool> e
	e.shouldDeployWeapon <- false

	array<string> weaponArray = [ "mp_titancore_cluster_barrage" ]

	titan.EndSignal( "OnDestroy" )
	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "TitanEjectionStarted" )
	titan.EndSignal( "DisembarkingTitan" )
	titan.EndSignal( "OnSyncedMelee" )

	if ( titan.IsPlayer() )
		titan.ForceStand()

	OnThreadEnd(
		function() : ( titan, e, weaponArray )
		{
			if ( IsValid( titan ) && titan.IsPlayer() )
			{
				if ( IsAlive( titan ) && titan.IsTitan() )
				{
					if ( HasWeapon( titan, "mp_titanweapon_cluster_barrage" ) )
					{
						EnableWeapons( titan, weaponArray )
						titan.TakeWeapon( "mp_titanweapon_cluster_barrage" )
					}
				}

				titan.ClearParent()
				titan.UnforceStand()
				if ( e.shouldDeployWeapon && !titan.ContextAction_IsActive() )
					DeployAndEnableWeapons( titan )

				titan.Signal( "CoreEnd" )
			}
		}
	)


	if ( titan.IsPlayer() )
	{
		const float startupTime = 0.5
        const float endingTime = 0.5

		e.shouldDeployWeapon = true
		HolsterAndDisableWeapons( titan )

        DisableWeapons( titan, weaponArray )
		titan.GiveWeapon( "mp_titanweapon_cluster_barrage" )
		titan.SetActiveWeaponByName( "mp_titanweapon_cluster_barrage" )

		wait startupTime

		e.shouldDeployWeapon = false
		DeployAndEnableWeapons( titan )

		titan.WaitSignal( "CoreEnd" )

		if ( IsAlive( titan ) && titan.IsTitan() )
		{
			e.shouldDeployWeapon = true
			HolsterAndDisableWeapons( titan )

			wait endingTime
		}
	}
	else
	{
		titan.GiveWeapon( "mp_titanweapon_cluster_barrage" )
		titan.SetActiveWeaponByName( "mp_titanweapon_cluster_barrage" )
		titan.WaitSignal( "CoreEnd" )
		titan.TakeWeapon( "mp_titanweapon_cluster_barrage" )
		titan.SetActiveWeaponByName("mp_titanweapon_rocketeer_rocketstream")
	}
}
#endif