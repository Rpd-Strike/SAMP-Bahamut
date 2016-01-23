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
///   DEFINES

///   DECLARES
native WP_Hash(buffer[], len, const str[]);
///   DECLARES
//   ||====================||=====================||======================||===========================||
///   ENuMS
//  LOGIN
enum { 
    DIALOG_LOGIN, 
    DIALOG_REGISTER 
};
//   LOGIN

//   PLAYER_INFO
enum E_PLAYER_DATA { 
    Password[129], 
    AdminLevel, 
    HelperLevel, 
    Money, 
    Scores, 
    Kills, 
    Deaths,
	Skin,
    bool:LoggedIn 
}; 
new PlayerInfo[MAX_PLAYERS][E_PLAYER_DATA];  
//   PLAYER_INFO
///   ENUMS
//   ||====================||=====================||======================||===========================||
///   STOCKS
//   ==============================================================
//  World Clock
public settime(playerid)
{
        new string[256],year,month,day,hours,minutes,seconds;
        getdate(year, month, day), gettime(hours, minutes, seconds);
        format(string, sizeof string, "%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
        TextDrawSetString(Date, string);
        format(string, sizeof string, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
        TextDrawSetString(Time, string);
}
//  World Clock
//   ==============================================================
//   LOGIN
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
    return 1; 
}
//   LOGIN
///   STOCKS
//   ||====================||=====================||======================||===========================||


main()
{    ///    SAVE POINT!!  STOP CTRL + Z   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	print("\n-------------------------------------------");
	print(" Bahamut Gamemode by YoChinez + RpdStrike");
	print("-------------------------------------------\n");
	
	print("\n--------------------------------------");
    print("          WORLDCLOCK + DATE             ");
    print("--------------------------------------\n");
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
    PlayerInfo[playerid][LoggedIn] = false; 

    new 
        name[MAX_PLAYER_NAME]; // 'name' will be our variable used to store the player's name in the scope of this function. MAX_PLAYER_NAME is defined as 24. 

    GetPlayerName(playerid, name, sizeof(name)); 
    TogglePlayerSpectating(playerid, true); 
    if(fexist(UserPath(playerid))) { 
        // This will check whether the user's file exists (he is registered). 
        // When it exists, run the following code: 
        INI_ParseFile(UserPath(playerid), "LoadPlayerData_user", .bExtra = true, .extra = playerid);
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

forward MyGivePlayerMoney(toplayerid, amount);
public MyGivePlayerMoney(toplayerid, amount) {
	GivePlayerMoney(toplayerid, amount);
	PlayerInfo[toplayerid][Money] += amount;
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
				message[40];
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
			else SendClientMessage(playerid, 0xFF0000FF, "That player is not connected");
		}
		else SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /givemoney <playerid> <amount>");
	}
	else SendClientMessage(playerid, 0xFF0000FF, "Only admins can use this command!");
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
    } 
    return 0; 
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
