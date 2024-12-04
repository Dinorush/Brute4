global function Brute4_CheckDependencies

struct
{
    string currentMod
    string currentDependency
    string currentURL
} file

void function Brute4_CheckDependencies()
{
    #if BRUTE4_HAS_TITANFRAMEWORK

    #elseif UI
        Brute4_CreateDependencyDialog( "Dinorush.Brute4", "Peepee.TitanFramework", "https://northstar.thunderstore.io/package/The_Peepeepoopoo_man/Titanframework/" )
    #endif
}

void function Brute4_CreateDependencyDialog( string mod, string dependency, string url )
{
    file.currentMod = mod
    file.currentDependency = dependency
    file.currentURL = url
    DialogData dialogData
    dialogData.header = Localize("#MISSING_DEPENDENCY_HEADER")

    array<ModInfo> infos = NSGetModInformation( dependency )

    //Mod not installed
    dialogData.message = Localize( "#MISSING_DEPENDENCY_BODY_INSTALL", mod, dependency, url )

    AddDialogButton( dialogData, "#OPEN_THUNDERSTORE", InstallFramework )
    AddDialogButton( dialogData, Localize("#ENABLE_MOD", dependency), EnableFramework )
    AddDialogButton( dialogData, Localize("#DISABLE_MOD", mod), DisableBrute4 )
    AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_BACK" )
    foreach ( ModInfo modInfo in infos )
    {
        if ( modInfo.name == dependency ){//Mod disabled
            dialogData.message = Localize( "#MISSING_DEPENDENCY_BODY_DISABLED", mod, dependency )

	        AddDialogButton( dialogData, Localize("#ENABLE_MOD", dependency), EnableFramework )
            AddDialogButton( dialogData, Localize("#DISABLE_MOD", mod), DisableBrute4 )
            AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	        AddDialogFooter( dialogData, "#B_BUTTON_BACK" )
            break
        }
    }

	OpenDialog( dialogData )
}

void function EnableFramework()
{
    NSSetModEnabled( file.currentDependency, true )
    ReloadMods()
}

void function InstallFramework()
{
    LaunchExternalWebBrowser( file.currentURL, WEBBROWSER_FLAG_FORCEEXTERNAL )
    ReloadMods()
}

void function DisableBrute4()
{
    NSSetModEnabled( file.currentMod, false )
    ReloadMods()
}
