#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

char g_sFilePath[PLATFORM_MAX_PATH];
char g_sGame[32];

public Plugin myinfo = {
	name = "Get Particle List",
	author = "JoinedSenses, Keith Warren (Drixevel)",
	description = "Retrieve and save current particle list",
	version = "1.2",
	url = "https://github.com/JoinedSenses"
};

public void OnPluginStart() {
	RegAdminCmd("sm_getparticlelist", cmdGetParticleList, ADMFLAG_ROOT);

	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "data/particles");

	if (!DirExists(g_sFilePath)) {
		CreateDirectory(g_sFilePath, 511);

		if (!DirExists(g_sFilePath)) {
			ThrowError("Error finding and creating directory: %s", g_sFilePath);
		}
	}

	GetGameFolderName(g_sGame, sizeof(g_sGame));

	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "/data/particles/%s_particles.txt", g_sGame);
}

public Action cmdGetParticleList(int client, int args) {
	int tblidx = FindStringTable("ParticleEffectNames");

	if (tblidx == INVALID_STRING_TABLE) {
		LogError("Could not find string table: ParticleEffectNames");
		return Plugin_Handled;
	}
	
	File file = OpenFile(g_sFilePath, "w");

	char tmp[256];
	int count = GetStringTableNumStrings(tblidx);

	for (int i = 0; i < count; i++) {
		ReadStringTable(tblidx, i, tmp, sizeof(tmp));
		file.WriteLine(tmp);
	}

	delete file;

	ReplyToCommand(client, "Particles file generated successfully for %s at: %s", g_sGame, g_sFilePath);
	
	return Plugin_Handled;
}