untyped


global function OnProjectileCollision_SpiralMissile

void function OnProjectileCollision_SpiralMissile( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		array<string> mods = projectile.ProjectileGetMods()
		if ( mods.contains( "burn_mod_titan_rocket_launcher" ) || mods.contains( "mini_clusters" ) )
		{
			entity owner = projectile.GetOwner()
			if ( IsValid( owner ) )
			{
				PopcornInfo popcornInfo
                // Clusters share explosion radius/damage with the base weapon
                // Clusters spawn '((int) (count/groupSize) + 1) * groupSize' total subexplosions (thanks to a '<=')
                // The ""base delay"" between each group's subexplosion on average is ((float) duration / (int) (count / groupSize))
                // The actual delay is (""base delay"" - delay). Thus 'delay' REDUCES delay. Make sure delay + offset < ""base delay"".

                // Current:
                // 6 count, 0.3 delay, 2.4 duration, 2 groupSize
                // Total: 8 subexplosions
                // ""Base delay"": 0.8s, avg delay between (each group): 0.5s, total duration: 2.0s
				popcornInfo.weaponName = "mp_titanweapon_rocketeer_rocketstream"
				popcornInfo.weaponMods = projectile.ProjectileGetMods()
				popcornInfo.damageSourceId = eDamageSourceId.mp_titanweapon_rocketeer_rocketstream
				popcornInfo.count = 6
				popcornInfo.delay = 0.3
				popcornInfo.offset = 0.15
				popcornInfo.range = 250
				popcornInfo.normal = normal
				popcornInfo.duration = 2.4
				popcornInfo.groupSize = 2
				popcornInfo.hasBase = false

				thread StartClusterExplosions( projectile, owner, popcornInfo, CLUSTER_ROCKET_FX_TABLE )
			}
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