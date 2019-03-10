#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Get Particle List",
	author = "JoinedSenses, Keith Warren (Drixevel)",
	description = "Retrieve and save current particle list.",
	version = "1.1",
	url = "https://github.com/JoinedSenses"
};

public void OnPluginStart()
{
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "data/particles/");
	
	if (!DirExists(sPath))
	{
		CreateDirectory(sPath, 511);
		
		if (!DirExists(sPath))
			ThrowError("Error finding and creating directory: %s", sPath);
	}
	
	char sGame[32];
	GetGameFolderName(sGame, sizeof(sGame));
	
	BuildPath(Path_SM, sPath, sizeof(sPath), "data/particles/%s.txt", sGame);
	
	File file = OpenFile(sPath, "w");
	
	if (file == null) 
		ThrowError("Error opening up file for writing: %s", sPath);
	
	int tblidx = FindStringTable("ParticleEffectNames");
	
	if (tblidx == INVALID_STRING_TABLE) 
		ThrowError("Could not find string table: ParticleEffectNames");
	
	char name[256];
	for (int i = 0; i < GetStringTableNumStrings(tblidx); i++)
	{
		ReadStringTable(tblidx, i, name, sizeof(name));
		file.WriteLine(name);
	}
	
	delete file;
	PrintToServer("Particles file generated successfully for %s at: %s", sGame, sPath);
	
	ServerCommand("sm plugins unload getparticlelist");
}