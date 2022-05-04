untyped
global function MpTitanweaponGrenadeLauncher_Init
global function OnWeaponPrimaryAttack_titanweapon_grenade_launcher
global function OnProjectileCollision_titanweapon_grenade_launcher
global function OnWeaponAttemptOffhandSwitch_titanweapon_grenade_launcher

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_grenade_launcher
#endif // #if SERVER

const FUSE_TIME = 0.5
const FUSE_TIME_EXT = 0.75 //Applies if the grenade hits an entity

void function MpTitanweaponGrenadeLauncher_Init()
{
	PrecacheWeapon( "mp_titanweapon_grenade_launcher" )
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_grenade_launcher( entity weapon )
{
	int minAmmo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < minAmmo )
		return false

	return true
}

var function OnWeaponPrimaryAttack_titanweapon_grenade_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()
	if ( owner.IsPlayer() )
		PlayerUsedOffhand( owner, weapon )

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		FireGrenade( weapon, attackParams )

	return weapon.GetAmmoPerShot()
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_grenade_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	FireGrenade( weapon, attackParams, true )
}
#endif // #if SERVER

function FireGrenade( entity weapon, WeaponPrimaryAttackParams attackParams, isNPCFiring = false )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	vector angularVelocity = Vector( RandomFloatRange( -1200, 1200 ), 100, 0 )

	int damageType = DF_RAGDOLL | DF_EXPLOSION

	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.Signal( "KillBruteShield" )

	vector bulletVec = ApplyVectorSpread( attackParams.dir, (weaponOwner.GetAttackSpreadAngle() - 1.0) * 2 )

	entity nade = weapon.FireWeaponGrenade( attackParams.pos, bulletVec, angularVelocity, 0.0 , damageType, damageType, !isNPCFiring, true, false )

	if ( nade )
	{
		#if SERVER
			EmitSoundOnEntity( nade, "Weapon_softball_Grenade_Emitter" )
			Grenade_Init( nade, weapon )
		#else
			SetTeam( nade, weaponOwner.GetTeam() )
		#endif
	}
}

void function OnProjectileCollision_titanweapon_grenade_launcher( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	if ( projectile.proj.projectileBounceCount > 0 )
		return

	projectile.proj.projectileBounceCount++

	EmitSoundOnEntity( projectile, "weapon_softball_grenade_attached_3P" )
	thread DetonateAfterTime( projectile, FUSE_TIME, normal )
	#endif
}

#if SERVER
// need this so grenade can use the normal to explode
void function DetonateAfterTime( entity projectile, float delay, vector normal )
{
	wait delay
	if ( IsValid( projectile ) )
		projectile.GrenadeExplode( normal )
}
#endif