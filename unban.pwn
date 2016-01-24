CMD:unbanuser( playerid, params[] )
{
	if( !IsPlayerAdmin( playerid ) && PlayerInfo[playerid][AdminLevel] <= 4 ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: You aren't authorized to use this command!" );

	new targetid;
    new targetname[24], filestring[79];

	if( sscanf( params, "s[24]", targetname ) ) return SendClientMessage( playerid, COLOR_YELLOW, "Usage: /unbanuser [playerid]" );
    format(filestring, sizeof(filestring), "/Users/%s.ini", targetname);
	///   Verifica targetid
	if(fexist(NameUserPath(targetid)))
	{
		new INI:file = INI_Open(filestring);
		INI_SetTag(file, "PlayerData");
		INI_WriteInt(file, "UserBan", 0);
		INI_Close(file);

		new mess[400];
		format( mess, sizeof(mess), ""#COL_GREEN"The user "#COL_WHITE"%s "#COL_GREEN"has been unbanned", GetPlayersName( targetid ) );
		return SendClientMessage( playerid, COLOR_WHITE, mess );
	}

	return SendClientMessage( playerid, COLOR_YELLOW, "The user does not exists" );
}
