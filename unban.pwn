
stock GetPlayerIdFromName(playername[])
{
  for(new i = 0; i <= MAX_PLAYERS; i++)
  {
    if(IsPlayerConnected(i))
    {
      new playername2[MAX_PLAYER_NAME];
      GetPlayerName(i, playername2, sizeof(playername2));
	  new lungime = (strlen(playername) == strlen(playername2));
	  if(lumgime)
	  {
		if(strcmp(playername2, playername, true) == 0)
		{
			return i;
		}
	  }
    }
  }
  return INVALID_PLAYER_ID;
}

CMD:banuser( playerid, params[] )
{
	if( !IsPlayerAdmin( playerid ) && PlayerInfo[playerid][AdminLevel] <= 4 ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: You aren't authorized to use this command!" );
	
	new targetname[24], filestring[79];
	
	if(sscanf(params, "s[24]", targetname)) return SendClientMessage( playerid, COLOR_YELLOW, "Usage: /banuser [playername]" );
	
	format(filestring, sizeof(filestring), "/Users/%s.ini", targetname);
	if(!fexist(filestring)) return SendClientMessage(playerid, -1, "Error: The player name you have chosen was not found in our system.");
	
	new INI:file = INI_Open(targetname);
	INI_SetTag(file, "PlayerData"); 
	INI_WriteInt(file, "UserBan", 1);
	INI_Close(file);
	
	if(GetPlayerIdFromName(targetname) != INVALID_PLAYER_ID) {
		Kick(GetPlayerIdFromName(targetname));
	}
	return 1;
}
