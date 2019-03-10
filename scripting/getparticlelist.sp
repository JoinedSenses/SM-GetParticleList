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
	char g_sFilePath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "configs/data/particles/");
	
	if (!DirExists(g_sFilePath))
	{
		CreateDirectory(g_sFilePath, 511);
		
		if (DirExists(g_sFilePath))
			ThrowError("Error finding and creating directory: %s", g_sFilePath);
	}
	
	char sGame[32];
	GetGameFolderName(sGame, sizeof(sGame));
	
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "configs/data/particles/%s.txt", sGame);
	
	File file = OpenFile(g_sFilePath, "w");
	
	if (file == null) 
		ThrowError("Error opening up file for writing: %s", g_sFilePath);
	
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
	PrintToServer("Particles file generated successfully at: %s", g_sFilePath);
}