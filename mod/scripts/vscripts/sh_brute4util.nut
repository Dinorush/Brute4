untyped
global function GiveBrute4
global function Brute4_Init

#if SERVER
// aegis upgrade: Child Chain Reaction
global function Brute4_ShouldProjectileDoClusterExplosion
global function Brute4_FireChildChainReactionGrenadeFromProjectile
#endif

struct {
	array<entity> reminded // Used to only give players the HUD message on the first drop per match
	
	array<entity> brute4TitanSouls // used for applying additional damage dealt by brute4
	int childChainReactionImpactTable
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

	// aegis upgrades
	file.childChainReactionImpactTable = PrecacheImpactEffectTable( CHILD_CHAIN_REACTION_IMPACT_TABLE )
	// for brute4's Bullet Rejection perk
	AddDamageFinalCallback( "player", Brute4_BulletRejectionDamage )
	AddDamageFinalCallback( "npc_titan", Brute4_BulletRejectionDamage )
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
	if ( GetCurrentPlaylistVarInt( "aegis_upgrades", 0 ) == 1 )
		Brute4_ApplyAegisUpgrades( titan )
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

void function Brute4_ApplyAegisUpgrades( entity titan )
{
	entity player
	if ( titan.IsPlayer() )
		player = titan
	else if ( IsValid( titan.mySpawnOptions_ownerPlayer ) )
		player = expect entity( titan.mySpawnOptions_ownerPlayer )
	else
		player = titan.GetBossPlayer()

	if ( !IsValid( player ) )
		return

	TitanLoadoutDef loadout = GetTitanLoadoutForPlayer( player )

	array<ItemData> fdUpgrades = GetAllItemsOfType( eItemTypes.TITAN_FD_UPGRADE )
	array<string> upgradeRefs
	foreach ( ItemData upgrade in fdUpgrades )
	{
		if ( loadout.titanClass == upgrade.parentRef && !IsSubItemLocked( player, upgrade.ref, upgrade.parentRef ) )
			upgradeRefs.append( upgrade.ref )
	}

	entity soul = titan.GetTitanSoul()
	if ( !IsValid( soul ) ) //Ejecting
		return

	foreach ( upgrade in upgradeRefs )
	{
		switch ( upgrade )
		{
			case "fd_upgrade_northstar_utility_tier_1":
				entity weapon = titan.GetOffhandWeapon( OFFHAND_LEFT )
				array<string> mods = weapon.GetMods()
				mods.append( "fd_unbreakable_protection" )
				weapon.SetMods( mods )
				break
			case "fd_upgrade_northstar_utility_tier_2":
				file.brute4TitanSouls.append( soul )
				break
			case "fd_upgrade_northstar_defense_tier_2":
				float titanShieldHealth = GetTitanSoulShieldHealth( soul )
				soul.SetShieldHealthMax( int( titanShieldHealth * 1.5 ) )
				break
			case "fd_upgrade_northstar_weapon_tier_1":
				entity weapon = titan.GetMainWeapons()[0]
				array<string> mods = weapon.GetMods()
				mods.append( "fd_one_killing_each_other" )
				weapon.SetMods( mods )
				break
			case "fd_upgrade_northstar_weapon_tier_2":
				entity weapon = titan.GetOffhandWeapon( OFFHAND_RIGHT )
				array<string> mods = weapon.GetMods()
				mods.append( "fd_doubled_explosive" )
				weapon.SetMods( mods )
				break
			case "fd_upgrade_northstar_ultimate":
				entity weapon = titan.GetMainWeapons()[0]
				array<string> mods = weapon.GetMods()
				mods.append( "fd_child_chain_reaction" )
				weapon.SetMods( mods )
				entity core = titan.GetOffhandWeapon( OFFHAND_EQUIPMENT )
				mods = core.GetMods()
				mods.append( "fd_child_chain_reaction" )
				core.SetMods( mods )
				break
		}
	}
}

int function GetBrute4ChildChainReactionImpactTable()
{
	return file.childChainReactionImpactTable
}

// Bullet Rejection
const float BULLET_REJECTION_DAMAGE_PROTECTION = 0.8
const float BULLET_REJECTION_DAMAGE_OUTPUT = 1.3

void function Brute4_BulletRejectionDamage( entity victim, var damageInfo )
{
	if ( !victim.IsTitan() )
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( !attacker.IsTitan() )
		return

	entity attackerSoul = attacker.GetTitanSoul()
	entity victimSoul = victim.GetTitanSoul()
	if ( !IsValid( victimSoul ) || !IsValid( attackerSoul ) ) // ejecting or transfering
		return

	bool brute4Attacker = file.brute4TitanSouls.contains( attackerSoul )
	bool brute4Victim = file.brute4TitanSouls.contains( victimSoul )

	if ( !brute4Attacker && !brute4Victim ) // neither the attacker nor victim is brute4
		return

	if ( brute4Victim )
	{
		// damage protection
		bool isBulletDamage = ( DamageInfo_GetCustomDamageType( damageInfo ) & DF_BULLET ) > 0	
		if ( isBulletDamage && brute4Victim )
			DamageInfo_ScaleDamage( damageInfo, BULLET_REJECTION_DAMAGE_PROTECTION )
	}

	/*
	if ( brute4Attacker )
	{
		// damage amp
		entity victimWeapon = victim.GetActiveWeapon()
		if ( IsValid( victimWeapon ) )
		{
			if ( victimWeapon.GetWeaponSettingInt( eWeaponVar.damage_flags ) & DF_BULLET )
				DamageInfo_ScaleDamage( damageInfo, BULLET_REJECTION_DAMAGE_OUTPUT )
		}
	}
	*/
}

// Child Chain Reaction
const float CHILD_CHAIN_REACTION_EXPLOSION_DELAY = 0.5
const vector CHILD_CHAIN_REACTION_LAUNCH_VELOCITY = < 0, 0, 230 >
const vector CHILD_CHAIN_REACTION_ANGULAR_VELOCITY = < 200, 0, 0 >
const string CHILD_CHAIN_REACTION_IMPACT_TABLE = "exp_softball_grenade"
const asset CHILD_CHAIN_REACTION_GRENADE_MODEL = $"models/weapons/bullets/mgl_grenade.mdl"
const string CHILD_CHAIN_REACTION_GRENADE_SCRIPTNAME = "child_chain_reaction_grenade"

void function Brute4_FireChildChainReactionGrenadeFromProjectile( entity projectile )
{
	entity owner = projectile.GetOwner()
	if ( !IsAlive( owner ) )
		return
	entity weapon = owner.GetMainWeapons()[0]
	if ( IsValid( weapon ) )
	{
		int damageFlags = weapon.GetWeaponDamageFlags()
		weapon.AddMod( "fd_child_chain_reaction_grenade" ) // for it's unique damage!
		entity grenade = weapon.FireWeaponGrenade( projectile.GetOrigin(), CHILD_CHAIN_REACTION_LAUNCH_VELOCITY, CHILD_CHAIN_REACTION_ANGULAR_VELOCITY, CHILD_CHAIN_REACTION_EXPLOSION_DELAY, damageFlags, damageFlags, false, true, true )
		weapon.RemoveMod( "fd_child_chain_reaction_grenade" )
		if ( grenade )
		{
			grenade.SetModel( CHILD_CHAIN_REACTION_GRENADE_MODEL )
			grenade.SetImpactEffectTable( file.childChainReactionImpactTable )
			grenade.SetScriptName( CHILD_CHAIN_REACTION_GRENADE_SCRIPTNAME ) // so it won't cause more cluster explosion on collision
		}
	}
}

bool function Brute4_ShouldProjectileDoClusterExplosion( entity projectile )
{
	if ( projectile.GetScriptName() == CHILD_CHAIN_REACTION_GRENADE_SCRIPTNAME )
		return false
	
	return true
}
#endif
