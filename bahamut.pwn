/************************************************
/    SAMP    GameMode
/    TYPE:   Roleplay
/    NAME:   Bahamut
*************************************************/

///   INCLUDES
#include <a_samp>
#include <YSi\y_ini>
#include <zcmd>
#include <sscanf2>
///   INCLUDES
//==================================================
///   DEFINES
//   LOGIN
#define USER_PATH "/Users/%s.ini" 
//   LOGIN
//==================================================
//   World Clock
new Text:Time, Text:Date;
forward settime(playerid);
//   World clock
//==================================================
#define PAYDAY_MINUTE 8  //  Cand se reseteaza payday
//   CoLoRS
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_SEAGREEN 0x20B2AAAA
#define COLOR_LIMEGREEN 0x32CD32AA //<--- Dark lime
#define COLOR_MIDNIGHTBLUE 0x191970AA
//  FARA X PENTRU FORMAT
#define COL_EASY           "{FFF1AF}"
#define COL_WHITE          "{FFFFFF}"
#define COL_BLACK          "{0E0101}"
#define COL_GREY           "{C3C3C3}"
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{FFAF00}"
#define COL_LIME           "{B7FF00}"
#define COL_CYAN           "{00FFEE}"
#define COL_LIGHTBLUE      "{00C0FF}"
#define COL_BLUE           "{0049FF}"
#define COL_MAGENTA        "{F300FF}"
#define COL_VIOLET         "{B700FF}"
#define COL_PINK           "{FF00EA}"
#define COL_MARONE         "{A90202}"
#define COL_CMD            "{B8FF02}"
#define COL_PARAM          "{3FCD02}"
#define COL_SERVER         "{AFE7FF}"
#define COL_VALUE 		   "{A3E4FF}"
#define COL_RULE  	   	   "{F9E8B7}"
#define COL_RULE2 		   "{FBDF89}"
#define COL_RWHITE 		   "{FFFFFF}"
#define COL_LGREEN         "{C9FFAB}"
#define COL_LRED           "{FFA1A1}"
#define COL_LRED2          "{C77D87}"
//  =============================================================
//  BAN STUFF
native BlockIpAddress(ip_address[], timems); // blocks an IP address from further communication (wildcards allowed)
native UnBlockIpAddress(ip_address[]); // IP unblock
///   DEFINES

///   DECLARES
//  FORWARDS
forward Automatic_PayDay();


//  FORWARDS

native WP_Hash(buffer[], len, const str[]);   //  For Whirlpool
///   DECLARES
//   ||====================||=====================||======================||===========================||
///   ENuMS
//  LOGIN
enum { 
    DIALOG_LOGIN, 
    DIALOG_REGISTER,
	DIALOG_STATS
};
//   LOGIN

//   PLAYER_INFO
enum E_PLAYER_DATA { 
    Password[129], 
    AdminLevel, 
    HelperLevel,
	RespectP,
    Money, 
    Scores, 
    Kills, 
    Deaths,
	Skin,
	UserBan,
    bool:LoggedIn 
}; 
new PlayerInfo[MAX_PLAYERS][E_PLAYER_DATA];  
//   PLAYER_INFO
///   ENUMS
//   ||====================||=====================||======================||===========================||
///   STOCKS
///  STRTOK + STRREST HERE
stock GetPlayerIdFromName(playername[])
{
  for(new i = 0; i <= MAX_PLAYERS; i++)
  {
    if(IsPlayerConnected(i))
    {
      new playername2[MAX_PLAYER_NAME];
      GetPlayerName(i, playername2, sizeof(playername2));
	  new lungime = (strlen(playername) == strlen(playername2));
	  if(lungime)
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

stock strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock strtok(const string[], &index) 
{ 
	new length = strlen(string); 
	while ((index < length) && (string[index] <= ' ')) index++; 
	new offset = index, result[20]; 
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1))) 
	{ 
		result[index - offset] = string[index]; 
		index++; 
	} 
	result[index - offset] = EOS; 
	return result; 
}
//   ==============================================================
//  World Clock
public settime(playerid)
{
    new string[256],year,month,day,hours,minutes,seconds;
    getdate(year, month, day), gettime(hours, minutes, seconds);
	
	//  PayDay
	if( minutes == PAYDAY_MINUTE && seconds == 5 ) {
		Automatic_PayDay();
	}
	//  PayDay
	
    format(string, sizeof string, "%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
    TextDrawSetString(Date, string);
    format(string, sizeof string, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
    TextDrawSetString(Time, string);
}
//  World Clock
//   ==============================================================
//   LOGIN
stock NameUserPath(playerid) {
    new 
	str[36]; // 'str' will be our variable used to format a string, the size of that string will never exceed 36 characters. 

    // Format USER_PATH with the name that we got with GetPlayerName. 
    format(str, sizeof(str), USER_PATH, playerid); // USER_PATH has been defined as: "/Users/%s.ini", %s will be replaced the player's name. 
    return str;
}

UserPath(playerid) { 

    // Declare our variables used in this function 
    new 
        str[36], // 'str' will be our variable used to format a string, the size of that string will never exceed 36 characters. 
        name[MAX_PLAYER_NAME]; // 'name' will be our variable used to store the player's name in the scope of this function. MAX_PLAYER_NAME is defined as 24. 

    // Get the player's name. 
    GetPlayerName(playerid, name, sizeof(name)); 

    // Format USER_PATH with the name that we got with GetPlayerName. 
    format(str, sizeof(str), USER_PATH, name); // USER_PATH has been defined as: "/Users/%s.ini", %s will be replaced the player's name. 
    return str; 
}  

forward LoadPlayerData_user(playerid, name[], value[]); 
public LoadPlayerData_user(playerid, name[], value[]) { 

    INI_String("Password", PlayerInfo[playerid][Password], 129); 
    INI_Int("AdminLevel", PlayerInfo[playerid][AdminLevel]); 
    INI_Int("HelperLevel", PlayerInfo[playerid][HelperLevel]); 
    INI_Int("Money", PlayerInfo[playerid][Money]); 
    INI_Int("Scores", PlayerInfo[playerid][Scores]); 
    INI_Int("Kills", PlayerInfo[playerid][Kills]); 
    INI_Int("Deaths", PlayerInfo[playerid][Deaths]); 
    INI_Int("Skin", PlayerInfo[playerid][Skin]); 
    INI_Int("RespectP", PlayerInfo[playerid][RespectP]); 
    INI_Int("UserBan", PlayerInfo[playerid][UserBan]); 
	
    return 1; 
}
//   LOGIN

//   PayDay
stock Automatic_PayDay()
{
	for( new player = 0;  player < MAX_PLAYERS;  ++player ) {
		SendClientMessage( player, COLOR_BLUE, "PAYDAY TIME !!" );
		PlayerInfo[player][RespectP] += 1;  //  Adaugam Respect Points
		SendClientMessage( player, COLOR_GREEN, "Ai primit 1 RespectPoint" );
	}
}
//   GESTIONARE BANS / USERS
stock GetPlayersName( playerid )
{
	// creating a variable to store the player's name in.
	new name[ MAX_PLAYER_NAME ];
	// getting the player's name and storing it into the variable
	GetPlayerName( playerid, name, sizeof( name ) );
	return name; // returning the player's name.
}

stock ReturnPlayerIp( playerid )
{
	// creating a variable to store the player's IP address in.
	new Ip[ 20 ];
	// getting the IP address of the player and storing it into the variable.
	GetPlayerIp( playerid, Ip, sizeof( Ip ) );
	return Ip; // returning the IP address.
}

///   STOCKS
//   ||====================||=====================||======================||===========================||

main()
{    ///    SAVE POINT!!  STOP CTRL + Z   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	print("\n-------------------------------------------");
	print(" Bahamut Gamemode by YoChinezu + RpdStrike");
	print("-------------------------------------------\n");
	
	print("\n-------------------------------------------");
    print("          WORLDCLOCK + DATE             ");
    print("-------------------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("Roleplay");
	DisableInteriorEnterExits();
	UsePlayerPedAnims();
	ShowPlayerMarkers(0);
	LimitGlobalChatRadius(50.0);
	EnableStuntBonusForAll(0);
	
	//  ================================================================================
	//  World Clock
	SetTimer("settime",1000,true);

	Date = TextDrawCreate(547.000000,11.000000,"--");

	TextDrawFont(Date,3);
	TextDrawLetterSize(Date,0.399999,1.600000);
    TextDrawColor(Date,0xffffffff);
 
	Time = TextDrawCreate(547.000000,28.000000,"--");

	TextDrawFont(Time,3);
	TextDrawLetterSize(Time,0.399999,1.600000);
	TextDrawColor(Time,0xffffffff);
	//  World Clock
	//  =================================================================================
	AddPlayerClass(60,1781.2979,-1863.4768,13.5750,304.8684,0,0,0,0,0,0);

	AddStaticVehicle(509,1802.5951,-1866.7990,13.0626,347.6411,0,0);
	AddStaticVehicle(509,1799.3889,-1866.5785,13.0559,354.4962,0,0);
	AddStaticVehicle(509,1801.1124,-1866.6853,13.0343,355.5555,0,0);
	AddStaticVehicle(509,1798.0996,-1866.5129,13.0557,357.3568,0,0);
	AddStaticVehicle(509,1796.6064,-1866.4248,13.0862,3.4479,0,0);
	AddStaticVehicle(509,1792.9340,-1866.6533,13.0560,359.3485,0,0);
	AddStaticVehicle(509,1791.2216,-1866.6636,13.0563,0.8822,0,0);
	AddStaticVehicle(509,1789.5703,-1866.6317,13.0860,359.1244,0,0);
	
	return 1;
}

public OnGameModeExit()
{
	for( new playerid = 0;  playerid < MAX_PLAYERS;  ++playerid ) 
	{
		///  Saving Details
		new INI:file = INI_Open(UserPath(playerid));
		INI_SetTag(file, "PlayerData"); 
		INI_WriteInt(file, "AdminLevel", PlayerInfo[playerid][AdminLevel]);
		INI_WriteInt(file, "HelperLevel", PlayerInfo[playerid][HelperLevel]);
		INI_WriteInt(file, "Skin", PlayerInfo[playerid][Skin]);
		INI_WriteInt(file, "Money", PlayerInfo[playerid][Money]);
		INI_WriteInt(file, "Skin", PlayerInfo[playerid][Skin]);
		INI_WriteInt(file, "Kills", PlayerInfo[playerid][Kills]);
		INI_WriteInt(file, "Deaths", PlayerInfo[playerid][Deaths]);
		INI_WriteInt(file, "RespectP", PlayerInfo[playerid][RespectP]);
		
		INI_Close(file);
		///  Saving Details
	}
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, -250.9738, 2585.6497, 63.5703);
	SetPlayerFacingAngle(playerid, 210.3500);
	SetPlayerCameraPos(playerid, -248.9410, 2581.5327, 64.9334);
	SetPlayerCameraLookAt(playerid, -250.9738, 2585.6497, 63.5703);
	return 1;
}

public OnPlayerConnect(playerid)
{
	///  Server INIT
	SetPlayerColor(playerid, 0xFFFFFFFF);
	
	///   LOGIN SYSTEM
	// Reset the variables to avoid data corruption 
    PlayerInfo[playerid][AdminLevel] = 0; 
    PlayerInfo[playerid][HelperLevel] = 0; 
    PlayerInfo[playerid][Money] = 0; 
    PlayerInfo[playerid][Scores] = 0; 
    PlayerInfo[playerid][Kills] = 0; 
    PlayerInfo[playerid][Deaths] = 0; 
	PlayerInfo[playerid][UserBan] = 0;
    PlayerInfo[playerid][LoggedIn] = false; 

    new 
        name[MAX_PLAYER_NAME]; // 'name' will be our variable used to store the player's name in the scope of this function. MAX_PLAYER_NAME is defined as 24. 

    GetPlayerName(playerid, name, sizeof(name)); 
    TogglePlayerSpectating(playerid, true); 
    if(fexist(UserPath(playerid))) { 
        // This will check whether the user's file exists (he is registered). 
        // When it exists, run the following code: 
        INI_ParseFile(UserPath(playerid), "LoadPlayerData_user", .bExtra = true, .extra = playerid);
		
		if( PlayerInfo[playerid][UserBan] ) {
			SendClientMessage( playerid, -1, "Esti banat de pe server, ne pare rau, vei fi deconectat" );
			
			Kick( playerid );
		}
		
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Welcome back. This account is registered.\n\nEnter your password below to log in:", "Login", "Quit"); 
    } 
    else { 

        // When the user's file doesn't exist (he isn't registered). 
        // When it doesn't exist, run the following code: 
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "Welcome. This account is not registered.\n\nEnter your desired password below to register:", "Register", "Quit"); 
    } 
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{	
	//  World Clock
	TextDrawHideForPlayer(playerid, Time), TextDrawHideForPlayer(playerid, Date);
	//  World Clock
	
	///  Saving Details
	new INI:file = INI_Open(UserPath(playerid));
	INI_SetTag(file, "PlayerData"); 
    INI_WriteInt(file, "Skin", PlayerInfo[playerid][Skin]);
    INI_WriteInt(file, "Money", PlayerInfo[playerid][Money]);
    INI_WriteInt(file, "Skin", PlayerInfo[playerid][Skin]);
    INI_WriteInt(file, "Scores", PlayerInfo[playerid][Scores]);
    INI_WriteInt(file, "AdminLevel", PlayerInfo[playerid][AdminLevel]);
    INI_WriteInt(file, "HelperLevel", PlayerInfo[playerid][HelperLevel]);
    INI_WriteInt(file, "UserBan", PlayerInfo[playerid][UserBan]);
	
	
    INI_Close(file);
	///  Saving Details
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//  =============================================================
	//  World Clock
    TextDrawShowForPlayer(playerid, Time), TextDrawShowForPlayer(playerid, Date);
	//  World Clock
	//  =============================================================
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID) { 

        // We check whether the killer is a valid player 
        PlayerInfo[playerid][Deaths] ++; // ++ means +1 
        if( playerid != killerid )  PlayerInfo[killerid][Kills] ++; 

        // Save the deaths 
        new INI:file = INI_Open(UserPath(playerid)); 
        INI_SetTag(file, "PlayerData"); 
        INI_WriteInt(file, "Deaths", PlayerInfo[playerid][Deaths]); 
        INI_Close(file); 

        // Save the kills 
        new INI:file2 = INI_Open(UserPath(killerid)); 
        INI_SetTag(file2, "PlayerData"); 
        INI_WriteInt(file2, "Kills", PlayerInfo[killerid][Kills]); 
        INI_Close(file2); 
		
    } 
    return 1; 
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}
 
CMD:stats(playerid, params[])
{	
	new playername[MAX_PLAYER_NAME];
	GetPlayerName( playerid, playername, sizeof(playername) );
	
	new title_mess[62];
	format( title_mess, 60, "The stats for user: %s", playername );
	
	new str_stats[1000];
	new cLevel = PlayerInfo[playerid][Scores];
	new cRespectP = PlayerInfo[playerid][RespectP];
	new cMoney = PlayerInfo[playerid][Money];
	new cKills = PlayerInfo[playerid][Kills];
	new cDeaths = PlayerInfo[playerid][Deaths];
	new cAdmin = PlayerInfo[playerid][AdminLevel];
	new cHelper = PlayerInfo[playerid][HelperLevel];
	format( str_stats, 1000, " "#COL_WHITE"Name: "#COL_BLUE"%s \n "#COL_WHITE"Level: "#COL_GREEN"%d \n "#COL_WHITE"Respect Points: "#COL_GREEN"%d \n "#COL_WHITE"Money: "#COL_GREEN"%d \n "#COL_WHITE"Kills: "#COL_GREEN"%d \n "#COL_WHITE"Deaths: "#COL_GREEN"%d \n "#COL_WHITE"Admin_Level: "#COL_YELLOW"%d \n "#COL_WHITE"Helper_Level: "#COL_YELLOW"%d", playername, cLevel, cRespectP, cMoney, cKills, cDeaths, cAdmin, cHelper );
	
	ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, title_mess, str_stats, "OK / Close", "" );
	
	return 1;
}

forward MyGivePlayerMoney(toplayerid, amount);
public MyGivePlayerMoney(toplayerid, amount) {
	GivePlayerMoney(toplayerid, amount);
	PlayerInfo[toplayerid][Money] += amount;
}

forward MySetPlayerMoney(toplayerid, amount);
public  MySetPlayerMoney(toplayerid, amount)
{
	ResetPlayerMoney( toplayerid );
	GivePlayerMoney( toplayerid, amount );
	PlayerInfo[ toplayerid ][ Money ] = amount;
}

CMD:announce(playerid, params[]) 
{
    new
        string[130],
        pName[MAX_PLAYER_NAME];

    if( PlayerInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid) ) {
		if (isnull(params)) return SendClientMessage(playerid, COLOR_WHITE,"Usage:  /announce [text]");
		GetPlayerName(playerid, pName, sizeof(pName));
		format(string, sizeof(string), "[Admin] %s: ", pName);
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), " %s", params);
		SendClientMessageToAll(COLOR_LIMEGREEN, string);
		
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "You are not an admin");
	}
    return 1;
}

CMD:setmoney(playerid, params[])
{
	if (IsPlayerAdmin(playerid))
	{
		new
			toplayerid, // the player we want to SET money to
			amount;
		// extracting player's ID and amount from params
		if (!sscanf(params, "ii", toplayerid, amount))
		{
			if (toplayerid != INVALID_PLAYER_ID)
			{
		    new
				message[1000];
			MySetPlayerMoney(toplayerid, amount);
			//  Mesaj la TOPLAYERID
			new aname[MAX_PLAYER_NAME], astr[200], str_amount[200];
			GetPlayerName(playerid, aname, sizeof(aname));
			format(astr, sizeof(astr), "%s", aname);
			format(str_amount, sizeof(str_amount), "%s", amount);
			format(message, sizeof(message), "The Admin %s has set your money to $%d", astr, str_amount);
			
			SendClientMessage(toplayerid, COLOR_RED, message);
			//  Mesaj la ADMIN
			new pname[MAX_PLAYER_NAME], str[200];
			GetPlayerName(toplayerid, pname, sizeof(pname));
			format(str, sizeof(str), "%s", pname);
			format(message, sizeof(message), "You set $%d to %s", amount, str); 
			
			SendClientMessage(playerid, COLOR_RED, message);
			}
			else SendClientMessage(playerid, COLOR_FLBLUE, "That player is not connected");
		}
		else SendClientMessage(playerid, COLOR_YELLOW, "Usage: /setmoney <playerid> <amount>");
	}
	else SendClientMessage(playerid, COLOR_YELLOW, "Only admins can use this command!");
	return 1;
}
	

CMD:givemoney(playerid, params[])
{
	if (IsPlayerAdmin(playerid))
	{
		new
			toplayerid, // the player we want to give money to
			amount;
		// extracting player's ID and amount from params
		if (!sscanf(params, "ii", toplayerid, amount))
		{
			if (toplayerid != INVALID_PLAYER_ID)
			{
		    new
				message[200];
			MyGivePlayerMoney(toplayerid, amount);
			//  Mesaj la TOPLAYERID
			format(message, sizeof(message), "You got $%d from admin!", amount);
			SendClientMessage(toplayerid, 0x00FF00FF, message);
			//  Mesaj la ADMIN
			new pname[MAX_PLAYER_NAME], str[200];
			GetPlayerName(toplayerid, pname, sizeof(pname));
			format(str, sizeof(str), "%s", pname);
			format(message, sizeof(message), "You gave $%d to %s", amount, str); 
			
			SendClientMessage(playerid, COLOR_RED, message);
			}
			else SendClientMessage(playerid, COLOR_FLBLUE, "That player is not connected");
		}
		else SendClientMessage(playerid, COLOR_YELLOW, "Usage: /givemoney <playerid> <amount>");
	}
	else SendClientMessage(playerid, COLOR_YELLOW, "Only admins can use this command!");
	return 1;
}

CMD:kickall(playerid)
{
	if( (IsPlayerAdmin(playerid)) ) {
		for( new i = 0;  i < MAX_PLAYERS;  ++i ) {
			if( !IsPlayerAdmin(i) ) {
				Kick(i);
			}
			else {
				SendClientMessage( i, COLOR_RED, "All Non-Admins were kicked :P" );
			}
		}
	}
	else {
		SendClientMessage(playerid, COLOR_RED, "Only for admins :P");
	}
	return 1;
}

///  BAN FUNCTION
CMD:unbanuser( playerid, params[] )
{
	if( !IsPlayerAdmin( playerid ) && PlayerInfo[playerid][AdminLevel] <= 4 ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: You aren't authorized to use this command!" );

    new targetname[24], filestring[79];

	if( sscanf( params, "s[24]", targetname ) ) return SendClientMessage( playerid, COLOR_YELLOW, "Usage: /unbanuser [playername]" );
    format(filestring, sizeof(filestring), "/Users/%s.ini", targetname);
	///   Verifica targetid
	if( fexist(filestring) )
	{
		new INI:file = INI_Open(filestring);
		INI_SetTag(file, "PlayerData");
		INI_WriteInt(file, "UserBan", 0);
		INI_Close(file);

		new mess[400];
		format( mess, sizeof(mess), ""#COL_GREEN"The user "#COL_WHITE"%s "#COL_GREEN"has been unbanned", targetname );
		return SendClientMessage( playerid, COLOR_WHITE, mess );
	}

	return SendClientMessage( playerid, COLOR_YELLOW, "The user does not exists" );
}

CMD:banuser( playerid, params[] )
{
	if( !IsPlayerAdmin( playerid ) && PlayerInfo[playerid][AdminLevel] <= 4 ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: You aren't authorized to use this command!" );
	
	new targetname[24], filestring[79];
	
	if(sscanf(params, "s[24]", targetname)) return SendClientMessage( playerid, COLOR_YELLOW, "Usage: /banuser [playername]" );
	
	format(filestring, sizeof(filestring), "/Users/%s.ini", targetname);
	if(!fexist(filestring)) return SendClientMessage(playerid, -1, "Error: The player name you have chosen was not found in our system.");
	
	new INI:file = INI_Open(filestring);
	INI_SetTag(file, "PlayerData"); 
	INI_WriteInt(file, "UserBan", 1);
	INI_Close(file);
	
	new str[400];
	format( str, sizeof(str), ""#COL_GREEN"You have banned "#COL_YELLOW"%s "#COL_GREEN"succesfully.", targetname );
	SendClientMessage( playerid, -1, str );
	
	if(GetPlayerIdFromName(targetname) != INVALID_PLAYER_ID) {
		new playername[MAX_PLAYER_NAME + 2];
		GetPlayerName(playerid, playername, sizeof(playername) );
		format( str, sizeof(str), ""#COL_RED"You have been banned by "#COL_YELLOW"%s "#COL_RED"Congrats!!", playername );
		SendClientMessage( playerid, -1, str );
		PlayerInfo[GetPlayerIdFromName(targetname)][UserBan] = 1;
		Kick(GetPlayerIdFromName(targetname));
	}
	return 1;
}

CMD:banip( playerid, params[ ] )
{
	if( !IsPlayerAdmin( playerid ) && PlayerInfo[playerid][AdminLevel] <= 4 ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: You aren't authorized to use this command!" );
	
	new targetid, reason[ 200 ];
	
	if( sscanf( params, "us[64]", targetid, reason ) ) return SendClientMessage( playerid, COLOR_YELLOW, "Usage: /banip [playerid] [reason]" );
	
	if( targetid == INVALID_PLAYER_ID || playerid == targetid ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: Invalid playerid." );
	
	// creating a string to store the message in.
	new str[ 400 ];
	
	// formatting the message, and sending it to everyone online. for more information on this function please visit the SA-MP wiki.
	format( str, sizeof( str ), ""#COL_INDIGO"%s "#COL_RED"has BANNED YOU "#COL_YELLOW"for "#COL_RED"%s.", GetPlayersName( playerid ), reason );
	SendClientMessage( targetid, -1, str );
	
	format( str, sizeof( str ), ""#COL_GREEN"YOU have banned "#COL_BLUE"%s "#COL_GREEN"for %s" );
	
	BlockIpAddress( ReturnPlayerIp( targetid ), 0 );
	return 1;
}

CMD:unbanip( playerid, params[ ] )
{
    if( !IsPlayerAdmin( playerid ) && PlayerInfo[playerid][AdminLevel] <= 4 ) return SendClientMessage( playerid, COLOR_YELLOW, "Error: You aren't authorized to use this command!" );
    
    // Defining a variable for our parameter.
    new ip_address[ 20 ];
    
    if( sscanf( params, "s[16]", ip_address ) ) return SendClientMessage( playerid, COLOR_YELLOW, "Usage: /unbanip [ip-address]" );

    // creating a string to store the message in.
    new str[ 200 ];
    
    format( str, sizeof( str ), ""#COL_GREEN"You've unbanned IP: "#COL_RED"%s", ip_address );
    SendClientMessage(playerid, -1, str );
	
	UnBlockIpAddress( ip_address );
    return 1;
}

CMD:pm( playerid, params[] )
{
	new mes[450], raw_mes[400], id, send_name[MAX_PLAYER_NAME], rec_name[MAX_PLAYER_NAME];
	if(sscanf(params, "us", id, raw_mes))
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Usage: /pm <id/name> <message>");
	}
	if( !IsPlayerConnected(id) ) 
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "That player is not connected right now.");
	}
	if( playerid == id ) {
		return SendClientMessage(playerid, COLOR_YELLOW, "You can not PM yourself.");
	}
	GetPlayerName(playerid, send_name, sizeof(send_name)); //The Sender's Name so we use (playerid).
	GetPlayerName(id, rec_name, sizeof(rec_name)); //The Receiver's Name so we use (id).
	format(mes, sizeof(mes), ""#COL_GREEN"PM To "#COL_IVORY"%s(%d): "#COL_GREEN"%s", rec_name, id, raw_mes);
	SendClientMessage(playerid, COLOR_INDIGO, mes);
	format(mes, sizeof(mes), ""#COL_GREEN"PM From "#COL_IVORY"%s(%d): "#COL_GREEN"%s", send_name, playerid, raw_mes);
	SendClientMessage(id, COLOR_INDIGO, mes);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{	
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid) { 

        case DIALOG_REGISTER: { 

            if(!response) Kick(playerid); 
            else { 

                if(!strlen(inputtext)) { 

                    SendClientMessage(playerid, -1, "You have to enter your desired password."); 
                    return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "Welcome. This account is not registered.\n\nEnter your desired password below to register:", "Register", "Quit"); 
                } 
                WP_Hash(PlayerInfo[playerid][Password], 129, inputtext); 
                new INI:file = INI_Open(UserPath(playerid)); 
                INI_SetTag(file, "PlayerData"); 
                INI_WriteString(file, "Password", PlayerInfo[playerid][Password]); 
                INI_WriteInt(file, "AdminLevel", 0); 
                INI_WriteInt(file, "HelperLevel", 0); 
                INI_WriteInt(file, "Money", 0); 
                INI_WriteInt(file, "Scores", 0); 
                INI_WriteInt(file, "Kills", 0); 
                INI_WriteInt(file, "Deaths", 0); 
                INI_WriteInt(file, "RespectP", 0); 
                INI_WriteInt(file, "UserBan", 0); 
                INI_Close(file); 
                SendClientMessage(playerid, -1, "You have successfully registered."); 
                PlayerInfo[playerid][LoggedIn] = true; 
                TogglePlayerSpectating(playerid, false); 
                return 1; 
            } 
        } 
        case DIALOG_LOGIN: { 

            if(!response) Kick(playerid); 
            else { 

                new 
                    hashpass[129]; 

                WP_Hash(hashpass, sizeof(hashpass), inputtext); 

                if(!strcmp(hashpass, PlayerInfo[playerid][Password])) { 

                    // The player has entered the correct password 
                    SetPlayerScore(playerid, PlayerInfo[playerid][Scores]); 
                    GivePlayerMoney(playerid, PlayerInfo[playerid][Money]); 
                    SendClientMessage(playerid, -1, "Welcome back! You have successfully logged in!"); 
                    PlayerInfo[playerid][LoggedIn] = true; 
                    TogglePlayerSpectating(playerid, false); 
                } 
                else { 

                    // The player has entered an incorrect password 
                    SendClientMessage(playerid, -1, "You have entered an incorrect password."); 
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Welcome back. This account is registered.\n\nEnter your password below to log in:", "Login", "Quit"); 
                } 
                return 1; 
            } 
        }
		case DIALOG_STATS: {
			if( response )  {  //  Au apasat pe OK
				SendClientMessage( playerid, COLOR_GREEN, "We hope you will have better stats next time !!" );
			}
			else {
				SendClientMessage( playerid, COLOR_GREEN, "We hope you will have better stats next time !!" );
			}
		}
	} 
    return 0; 
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
