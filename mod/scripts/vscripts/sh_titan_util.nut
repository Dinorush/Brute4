global function GameModeRulesRegisterTimerCreditExceptions
global function GameModeRulesRegisterTimerCreditException
global function	GameModeRulesGetTimerCreditExceptions

global function SetCustomGameModeRulesTimerCredit

struct {
    array<int> gameModeRulesTimerCreditExceptions = [
		eDamageSourceId.mp_titancore_flame_wave,
		eDamageSourceId.mp_titancore_flame_wave_secondary,
		eDamageSourceId.mp_titancore_salvo_core,
		damagedef_titan_fall,
		damagedef_nuclear_core
	]
} file

void function SetCustomGameModeRulesTimerCredit()
{
    SetGameModeRulesShouldGiveTimerCredit( ShouldGiveTimerCreditTitan )
}

bool function ShouldGiveTimerCreditTitan( entity player, entity victim, var damageInfo )
{
    if ( player == victim )
        return false

    if ( player.IsTitan() && !IsCoreAvailable( player ) )
        return false

    if ( GAMETYPE == FREE_AGENCY && !player.IsTitan() )
        return false

    int damageSourceID = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( file.gameModeRulesTimerCreditExceptions.contains( damageSourceID ) )
		return false

    return true
}

void function GameModeRulesRegisterTimerCreditExceptions( array<int> ids )
{
	foreach( id in ids )
		GameModeRulesRegisterTimerCreditException( id )
}

void function GameModeRulesRegisterTimerCreditException( int id )
{
	if ( !file.gameModeRulesTimerCreditExceptions.contains( id ) )
		file.gameModeRulesTimerCreditExceptions.append( id )
}

array<int> function GameModeRulesGetTimerCreditExceptions()
{
	return file.gameModeRulesTimerCreditExceptions
}