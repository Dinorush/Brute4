untyped

global function OnWeaponPrimaryAttack_titanweapon_barrage_core_launcher
global function OnProjectileCollision_titanweapon_barrage_core_launcher

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_barrage_core_launcher
#endif // #if SERVER

const FUSE_TIME = 0.25 //Applies once the grenade has stuck to a surface.
const FUSE_TIME_EXT = 1.5

var function OnWeaponPrimaryAttack_titanweapon_barrage_core_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

    if ( IsServer() || weapon.ShouldPredictProjectiles() )
        return FireGrenade( weapon, attackParams )
    return 1
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_barrage_core_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
    weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
    return FireGrenade( weapon, attackParams, true )
}
#endif // #if SERVER

var function FireGrenade( entity weapon, WeaponPrimaryAttackParams attackParams, bool isNPCFiring = false )
{
    entity owner = weapon.GetWeaponOwner()
    owner.Signal("KillBruteShield")

	vector angularVelocity = Vector( RandomFloatRange( -1200, 1200 ), 100, 0 )

	int damageType = DF_RAGDOLL | DF_EXPLOSION

	entity nade = weapon.FireWeaponGrenade( attackParams.pos, attackParams.dir, angularVelocity, 0.0 , damageType, damageType, !isNPCFiring, true, false )

	if ( nade )
	{
		#if SERVER
			EmitSoundOnEntity( nade, "Weapon_softball_Grenade_Emitter" )
			Grenade_Init( nade, weapon )
		#else
			entity weaponOwner = weapon.GetWeaponOwner()
			SetTeam( nade, weaponOwner.GetTeam() )
		#endif
	}
    return 1
}

void function OnProjectileCollision_titanweapon_barrage_core_launcher( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		if ( IsAlive( hitEnt ) && hitEnt.IsPlayer() )
		{
			PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
			EmitSoundOnEntityOnlyToPlayer( projectile, hitEnt, "weapon_softball_grenade_attached_1P" )
			EmitSoundOnEntityExceptToPlayer( projectile, hitEnt, "weapon_softball_grenade_attached_3P" )
		}
		else
		{
			PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
			EmitSoundOnEntity( projectile, "weapon_softball_grenade_attached_3P" )
		}
        // HACK - call cluster creation on impact, otherwise projectile will be null; use projectile_explosion_delay in .txt to account for FUSE_TIME. Must match!
        StartClusterAfterDelay( projectile, normal )
		thread DetonateStickyAfterTime( projectile, FUSE_TIME, normal )
	#endif
}

#if SERVER
void function StartClusterAfterDelay( entity projectile, vector normal) {
    entity owner = projectile.GetOwner()
    if ( IsValid( owner ) )
    {
        PopcornInfo popcornInfo
        // Clusters share explosion radius/damage with the base weapon
        // Clusters spawn '((int) (count/groupSize) + 1) * groupSize' total subexplosions (thanks to a '<=')
        // The ""base delay"" between each group's subexplosion on average is ((float) duration / (int) (count / groupSize))
        // The actual delay is (""base delay"" - delay). Thus 'delay' REDUCES delay. Make sure delay + offset < ""base delay"".

        // Current:
        // 4 count, 0.35 delay, 2 duration, 1 groupSize
        // Total: 5 subexplosions
        // ""Base delay"": 0.5s, avg delay between (each group): 0.15s, total duration: 0.75s
        popcornInfo.weaponName = "mp_titanweapon_barrage_core_launcher"
        popcornInfo.weaponMods = projectile.ProjectileGetMods()
        popcornInfo.damageSourceId = eDamageSourceId.mp_titanweapon_barrage_core_launcher
        popcornInfo.count = 4
        popcornInfo.delay = 0.35
        popcornInfo.offset = 0.1
        popcornInfo.range = 150
        popcornInfo.normal = normal
        popcornInfo.duration = 2.0
        popcornInfo.groupSize = 1
        popcornInfo.hasBase = false

        thread StartClusterExplosions( projectile, owner, popcornInfo, CLUSTER_ROCKET_FX_TABLE )
    }
}
#endif //SERVER

#if SERVER
// need this so grenade can use the normal to explode
void function DetonateStickyAfterTime( entity projectile, float delay, vector normal )
{
	wait delay
	if ( IsValid( projectile ) )
		projectile.GrenadeExplode( normal )
}
#endif

