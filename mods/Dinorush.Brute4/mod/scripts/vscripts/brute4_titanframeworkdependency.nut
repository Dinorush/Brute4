global function Brute4_CheckDependencies

struct
{
    string currentMod           = "Dinorush.Brute4"
    string currentDependency    = "Peepee.TitanFramework"
    string currentURL           = "https://northstar.thunderstore.io/package/The_Peepeepoopoo_man/Titanframework/"
} file

void function Brute4_CheckDependencies()
{
    #if BRUTE4_HAS_TITANFRAMEWORK

    #else
        Brute4_CreateDependencyDialog()
    #endif
}

void function Brute4_CreateDependencyDialog()
{
    DialogData dialogData
    dialogData.forceChoice = true
    dialogData.header = Localize("#MISSING_DEPENDENCY_HEADER")
    dialogData.image = $"ui/menu/common/dialog_error"

    array<ModInfo> mods = NSGetModInformation( file.currentDependency )
    // mod is installed but disabled
    if ( mods.len() > 0 )
    {
        dialogData.message = Localize( "#MISSING_DEPENDENCY_BODY_DISABLED", file.currentMod, file.currentDependency )
        AddDialogButton( dialogData, Localize("#ENABLE_MOD", file.currentDependency ), EnableFramework )
    }
    else
    {
        dialogData.message = Localize( "#MISSING_DEPENDENCY_BODY_INSTALL", file.currentMod, file.currentDependency, file.currentURL )
        AddDialogButton( dialogData, "#OPEN_THUNDERSTORE", InstallFramework )
    }

    AddDialogButton( dialogData, Localize("#DISABLE_MOD", file.currentMod), DisableBrute4 )
    AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	OpenDialog( dialogData )
}

void function EnableFramework()
{
    NSSetModEnabled( file.currentDependency, NSGetModInformation(file.currentDependency)[0].version, true )
    ReloadMods()
}

void function InstallFramework()
{
    LaunchExternalWebBrowser( file.currentURL, WEBBROWSER_FLAG_FORCEEXTERNAL )
    ReloadMods()
}

void function DisableBrute4()
{
    array<ModInfo> mods = NSGetModInformation( file.currentMod )
    foreach ( ModInfo mod in mods ){ NSSetModEnabled( file.currentMod, mod.version, false ) }
    ReloadMods()
}
