untyped
global function MpTitanweaponGrenadeLauncher_Init
global function OnWeaponPrimaryAttack_titanweapon_grenade_launcher
global function OnProjectileCollision_titanweapon_grenade_launcher
// global function OnWeaponAttemptOffhandSwitch_titanweapon_grenade_launcher

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_grenade_launcher
#endif // #if SERVER

const FUSE_TIME = 0.5 
const FUSE_TIME_EXT = 0.75 //Applies if the grenade hits an entity
const FUSE_OFFSET = 0.0

function MpTitanweaponGrenadeLauncher_Init()
{
	RegisterSignal( "KillBruteShield" )
}

// bool function OnWeaponAttemptOffhandSwitch_titanweapon_grenade_launcher( entity weapon )
// {
// 	int ammoPerShot = weapon.GetAmmoPerShot()
// 	int currAmmo = weapon.GetWeaponPrimaryClipCount()
// 	if ( currAmmo < ammoPerShot )
// 		return false

// 	return true
// }

var function OnWeaponPrimaryAttack_titanweapon_grenade_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

	player.Signal( "KillBruteShield" )

	#if CLIENT
		return weapon.GetAmmoPerShot()
	#endif

	int ammoToSpend = weapon.GetAmmoPerShot()

	if ( player.IsPlayer() )
		PlayerUsedOffhand( player, weapon )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	//vector bulletVec = ApplyVectorSpread( attackParams.dir, player.GetAttackSpreadAngle() * 2.0 )
	//attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		// vector offset = Vector( 30.0, 6.0, -4.0 )
		// if ( weapon.IsWeaponInAds() )
		// 	offset = Vector( 30.0, 0.0, -3.0 )
		// vector attackPos = player.OffsetPositionFromView( attackParams[ "pos" ], offset )	// forward, right, up
        int numProjectiles = weapon.GetProjectilesPerShot()
        for (int i = 0; i < numProjectiles; i++) {
		    FireGrenade( weapon, attackParams )
        }
	}
	return ammoToSpend
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_grenade_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_titanweapon_grenade_launcher(  weapon, attackParams )
//	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
//	FireGrenade( weapon, attackParams, true )
}
#endif // #if SERVER

function FireGrenade( entity weapon, WeaponPrimaryAttackParams attackParams, isNPCFiring = false )
{
	vector angularVelocity = Vector( RandomFloatRange( -1200, 1200 ), 100, 0 )

	int damageType = DF_RAGDOLL | DF_EXPLOSION    
    
    entity weaponOwner = weapon.GetWeaponOwner()   
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
//	bool didStick = PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
//	if ( !didStick )
//		return


	#if SERVER
// 		if ( hitEnt.IsTitan() )
// 		{
// //			PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
// //			thread DetonateStickyAfterTime( projectile, FUSE_TIME, normal )
// 		}

    if ( projectile.proj.projectileBounceCount > 0 )
		return

	projectile.proj.projectileBounceCount++

    EmitSoundOnEntity( projectile, "weapon_softball_grenade_attached_3P" )

    // if ( IsAlive( hitEnt ) )
    // {
    //     PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
    //     EmitSoundOnEntityOnlyToPlayer( projectile, hitEnt, "weapon_softball_grenade_attached_1P" )
    //     EmitSoundOnEntityExceptToPlayer( projectile, hitEnt, "weapon_softball_grenade_attached_3P" )
    //     thread DetonateStickyAfterTime( projectile, FUSE_TIME, normal )
    //     thread DetonateStickyAfterTime( projectile, FUSE_TIME_EXT + RandomFloatRange(-FUSE_OFFSET, FUSE_OFFSET), normal )
    // }
    // else
        thread DetonateStickyAfterTime( projectile, FUSE_TIME + RandomFloatRange(-FUSE_OFFSET, FUSE_OFFSET), normal )
    
	#endif
}

#if SERVER
// need this so grenade can use the normal to explode
void function DetonateStickyAfterTime( entity projectile, float delay, vector normal )
{
	wait delay
	if ( IsValid( projectile ) )
		projectile.GrenadeExplode( normal )
}
#endif