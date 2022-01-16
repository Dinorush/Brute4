untyped


global function OnProjectileCollision_FlightCoreRockets

void function OnProjectileCollision_FlightCoreRockets( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
			entity owner = projectile.GetOwner()
			if ( IsValid( owner ) )
			{
				PopcornInfo popcornInfo

				popcornInfo.weaponName = "mp_titanweapon_rocketeer_rocketstream"
				popcornInfo.weaponMods = projectile.ProjectileGetMods()
				popcornInfo.damageSourceId = eDamageSourceId.mp_titanweapon_rocketeer_rocketstream
				popcornInfo.count = 2 //(groupSize is the minimum number of explosions )
				popcornInfo.delay = 0.0
				popcornInfo.offset = 0.3
				popcornInfo.range = 250
				popcornInfo.normal = normal
				popcornInfo.duration = 1.00
				popcornInfo.groupSize = 2 //Total explosions = groupSize * count
				popcornInfo.hasBase = false

				thread StartClusterExplosions( projectile, owner, popcornInfo, CLUSTER_ROCKET_FX_TABLE )
			}
	#endif

	if ( "spiralMissiles" in projectile.s )
	{
		if ( !IsAlive( hitEnt ) )
			return

		if ( !hitEnt.IsTitan() )
			return

		if ( Time() - projectile.s.launchTime < 0.02 )
			return

		foreach ( missile in projectile.s.spiralMissiles )
		{
			if ( !IsValid( missile ) )
				continue

			if ( missile == projectile )
				continue

			missile.s.spiralMissiles = []
			missile.MissileExplode()
		}
	}
}