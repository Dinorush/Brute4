untyped

global function MpTitanabilityDomeShield_Init

global function OnWeaponPrimaryAttack_dome_shield





#if SERVER
global function OnWeaponNpcPrimaryAttack_dome_shield
#endif // #if SERVER

global const DOME_SHIELD_HEALTH = 2000
const PAS_DOME_SHIELD_HEALTH = 3000


function MpTitanabilityDomeShield_Init()
{
	RegisterSignal( "RegenAmmo" )

    #if CLIENT
	    PrecacheHUDMaterial( $"vgui/hud/dpad_bubble_shield_charge_0" )
	    PrecacheHUDMaterial( $"vgui/hud/dpad_bubble_shield_charge_1" )
	    PrecacheHUDMaterial( $"vgui/hud/dpad_bubble_shield_charge_2" )
    #endif
}

var function OnWeaponPrimaryAttack_dome_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	entity weaponOwner = weapon.GetWeaponOwner()
    
    #if SERVER
    entity soul = player.GetTitanSoul()

    if( weaponOwner.IsPlayer() && IsValid( soul )  && IsValid( soul.soul.bubbleShield ))
        return
    #endif //SERVER

	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )
        
    float duration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
	thread Brute4GiveShortDomeShield( weapon, player, duration )
	
	return weapon.GetWeaponInfoFileKeyField( "ammo_per_shot" )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_dome_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

    float duration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
	thread Brute4GiveShortDomeShield( weapon, player, duration )
	
	return weapon.GetWeaponInfoFileKeyField( "ammo_per_shot" )
}
#endif // #if SERVER

void function Brute4GiveShortDomeShield( entity weapon, entity player, float duration = 6.0 )
{
	#if SERVER
	player.EndSignal( "OnDeath" )

	entity soul = GetSoulFromPlayer( player )
	if ( soul == null )
		return

	soul.EndSignal( "OnTitanDeath" )
	soul.EndSignal( "OnDestroy" )

	// Prevents the player from sprinting
    int slowID = StatusEffect_AddTimed( player, eStatusEffect.move_slow, 0.5, duration, 0 )
    int speedID = StatusEffect_AddTimed( player, eStatusEffect.speed_boost, 0.5, duration, 0 )

	CreateParentedBrute4BubbleShield( player, player.GetOrigin(), player.GetAngles(), duration )

	OnThreadEnd(
	function() : ( player, soul, slowID, speedID )
		{
			if ( IsValid( soul ) )
			{
				if ( IsValid( soul.soul.bubbleShield ) )
					soul.soul.bubbleShield.Destroy()
                
                if ( IsValid( player ) )
                {
                    StatusEffect_Stop( player, slowID )
                    StatusEffect_Stop( player, slowID )
                }
			}
		}
	)

    soul.EndSignal( "TitanBrokeBubbleShield" )
	soul.soul.bubbleShield.EndSignal( "OnDestroy" )
    
	Brute4LetTitanPlayerShootThroughBubbleShield( weapon, player )

	wait duration
	#endif
}