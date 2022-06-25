global function OnWeaponPrimaryAttack_rocketeer_ammo_swap
global function MpTitanAbilityRocketeerAmmoSwap_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_rocketeer_ammo_swap
#endif

void function MpTitanAbilityRocketeerAmmoSwap_Init()
{
}

var function OnWeaponPrimaryAttack_rocketeer_ammo_swap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	array<entity> weapons = GetPrimaryWeapons( weaponOwner )
	entity primaryWeapon = weapons[0]

	if ( !IsValid( primaryWeapon ) )
		return false
	else if ( weaponOwner.ContextAction_IsActive() )
		return false
	else if ( primaryWeapon.GetWeaponClassName() != "mp_titanweapon_rocketeer_rocketstream" )
		return false
	else if ( primaryWeapon.HasMod( "burn_mod_titan_rocket_launcher" ) )
		return false

	#if SERVER
	thread SwapRocketAmmo( weaponOwner, weapon, primaryWeapon )
	#endif

	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetAmmoPerShot()
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_rocketeer_ammo_swap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_rocketeer_ammo_swap( weapon, attackParams )
}

void function SwapRocketAmmo( entity weaponOwner, entity offhand, entity weapon )
{
	weapon.EndSignal( "OnDestroy" )
	offhand.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "DisembarkingTitan" )

	EmitSoundOnEntity( weaponOwner, "Coop_AmmoBox_AmmoRefill" )

	if ( weaponOwner.IsNPC() && HasAnim( weaponOwner, "at_reload_quick" ) )
	{
		weaponOwner.Anim_ScriptedPlay( "at_reload_quick" )
	}

	array<string> mods = weapon.GetMods()
	mods.append( "burn_mod_titan_rocket_launcher" )
	mods.append( "fast_reload" )
	if ( mods.contains( "rapid_detonator" ) )
		mods.append( "rapid_detonator_active" )
	weapon.SetMods( mods )

	offhand.AddMod( "no_regen" )

	weapon.SetWeaponPrimaryClipCount( 0 )
	if ( weapon.IsReloading() )
	{
		weapon.AddMod( "fast_deploy" )
		weaponOwner.HolsterWeapon()
		weaponOwner.DeployWeapon()
		weapon.RemoveMod( "fast_deploy" )
	}

	OnThreadEnd(
	function() : ( weaponOwner, weapon, offhand )
		{
			if ( IsValid( weapon ) )
			{
				array<string> mods = weapon.GetMods()
				mods.fastremovebyvalue( "burn_mod_titan_rocket_launcher" )
				mods.fastremovebyvalue( "fast_reload" )
				mods.fastremovebyvalue( "rapid_detonator_active" )
				weapon.SetMods( mods )
			}
			if ( IsValid( offhand ) )
				offhand.RemoveMod( "no_regen" )
		}
	)

	// We want the reload speed buff to stay until the reload is finished.
	// The weapon will not be reloading if something lowers it, so this more reliably waits until the weapon is reloaded than checking the IsReloading function.
	while ( weapon.GetWeaponPrimaryClipCount() == 0 )
		WaitFrame()

	weapon.RemoveMod( "fast_reload" )

	if ( weaponOwner.IsPlayer() )
	{
		// Check reload index to avoid stopping thread on canceled reloads, but catch non-empty reloads
		while ( weapon.GetReloadMilestoneIndex() == 0 && weapon.GetWeaponPrimaryClipCount() > 0 )
			WaitFrame()
	}
	else
	{
		while ( weapon.GetWeaponPrimaryClipCount() > 0 )
		WaitFrame()
	}
}
#endif