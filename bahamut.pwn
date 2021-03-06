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
#include <foreach>
///   INCLUDES
//==================================================
///   DEFINES
//   LOGIN
#define USER_PATH "/Users/%s.ini" 
#define VEHICLE_PATH "/UserVehicles/%d.ini"
#define MY_MAX_VEHICLES = 3000
//   LOGIN
//==================================================
//   PayDay
//   World Clock + PayDay
new Text:PayDay_Text;
new Text:Time, Text:Date;
forward settime(playerid);
//   World clock
//==================================================
#define PAYDAY_MINUTE 0  //  Cand se reseteaza payday
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
#define COLOR_LIGHTPINK 0xDB348CAA
#define COLOR_DARKGREEN 0x036720FF
//  FARA X PENTRU FORMAT
#define COL_IVORY          "{FFFF82}"
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
#define MAX_LEVEL 50
new LevelCostM[MAX_LEVEL + 2], LevelCostP[MAX_LEVEL + 2];

enum E_PLAYER_DATA { 
    Password[129], 
    AdminLevel, 
    HelperLevel,
	RespectP,
    Money,
	BankMoney,
    Scores, 
    Kills, 
    Deaths,
	Skin,
	UserBan,
    bool:LoggedIn 
}; 
///  Vehicle system
new TotalVeh = 0;
enum E_VEHICLE_DATA {
	Name[40],  //  Numele masini in game  (Infernus, landstalker)
	Plate[30], //  Numele plate-ului masinii (Ceva personalizat  /player/masina)
	ModelID,   //  ID-ul masini de folosit (cel link-uit cu numele)
	vID,    ///  Cel folosit in SA-MP system
	Owner[MAX_PLAYER_NAME],     //  Numele celui care detine masina (cel de login)
	Color1,  Color2,            //  Culorile
	Float: ParkX, 
	Float: ParkY,
	Float: ParkZ,
	Float: ParkA, //  Coordonatele de respawn / park
	Fuel,     //  0-100 ||  0 - nu porneste masina
	Engine,   //  Pornit / oprit
	Buyable,  //  Masina e de vanzare?
	Locked,   //  Daca alti playeri pot sa intre in masina in afara de owner
}


new VehicleInfo[MAX_VEHICLES][E_VEHICLE_DATA];
new PlayerInfo[MAX_PLAYERS][E_PLAYER_DATA];  
//   PLAYER_INFO
///   ENUMS
//   ||====================||=====================||======================||===========================||
///   STOCKS

//  Bullshit names
new VehicleNames[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
 	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
 	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "Utility Trailer"
};
stock GetVehicleName_Model(modelid)
{
	new String[20];
	format(String,sizeof(String),"%s",VehicleNames[modelid - 400]);
	return String;
}
stock GetVehicleName_Vehicle(vehicleid)
{
	new String[20];
	format(String,sizeof(String),"%s",VehicleNames[GetVehicleModel(vehicleid) - 400]);
	return String;
}

///  STRTOK + STRREST HERE + MAX/MIN
stock MyMinim( a, b )
{
	if( a < b )  return a;
	return b;
}

stock MyMaxim( a, b )
{
	if( a > b )  return a;
	return b;
}

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

VehiclePath(GlobalID) { 
	new
		str[40];
	
	format(str, sizeof(str), VEHICLE_PATH, GlobalID);
	return str;
}

forward LoadVehicleData( vehid, name[], value[] );
public  LoadVehicleData( vehid, name[], value[] )
{
	INI_String("Name", VehicleInfo[vehid][Name], 40);
	INI_String("Plate", VehicleInfo[vehid][Plate], 30);
	INI_String("Owner", VehicleInfo[vehid][Owner], MAX_PLAYER_NAME);
	INI_Int("ModelID", VehicleInfo[vehid][ModelID]);
	INI_Int("Color1", VehicleInfo[vehid][Color1]);
	INI_Int("Color2", VehicleInfo[vehid][Color2]);
	INI_Float("ParkX", VehicleInfo[vehid][ParkX]);
	INI_Float("ParkY", VehicleInfo[vehid][ParkY]);
	INI_Float("ParkZ", VehicleInfo[vehid][ParkZ]);
	INI_Float("ParkA", VehicleInfo[vehid][ParkA]);
	INI_Int("Engine", VehicleInfo[vehid][Engine]);
	INI_Int("Fuel", VehicleInfo[vehid][Fuel]);
	INI_Int("Buyable", VehicleInfo[vehid][Buyable]);
	INI_Int("Locked", VehicleInfo[vehid][Locked]);
	
	return 1;
}
	
	

forward LoadPlayerData_user(playerid, name[], value[]); 
public LoadPlayerData_user(playerid, name[], value[]) { 

    INI_String("Password", PlayerInfo[playerid][Password], 129); 
    INI_Int("AdminLevel", PlayerInfo[playerid][AdminLevel]); 
    INI_Int("HelperLevel", PlayerInfo[playerid][HelperLevel]); 
    INI_Int("Money", PlayerInfo[playerid][Money]); 
    INI_Int("BankMoney", PlayerInfo[playerid][BankMoney]); 
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
forward KillTextPayday();
public KillTextPayday()
{
	TextDrawHideForAll( PayDay_Text );
}

stock Automatic_PayDay()
{
	TextDrawShowForAll( PayDay_Text );
	SetTimer( "KillTextPayday", 1000 * 3, 0 );
	
	SendClientMessageToAll( COLOR_LIGHTBLUE, "------------- PAYDAY -------------" );
	
	new str[400];
	
	for( new player = 0;  player < MAX_PLAYERS;  ++player ) {
		if( !IsPlayerConnected(player) )  continue;
		
		//   Update stats
		PlayerInfo[player][RespectP] += 1;  //  Adaugam Respect Points
		SendClientMessage( player, COLOR_GREEN, "Ai primit 1 RespectPoint." );
		
		//   Bonus de bani  CASH
		new Float:cmoney = PlayerInfo[player][Money];
		cmoney = (cmoney * 2 / 100);
		new plus = floatround( cmoney, floatround_ceil );   ///  Bonus 2% in CASH
		
		format( str, sizeof(str), ""#COL_GREEN"Ai primit "#COL_BLUE"$%d "#COL_GREEN"in mana.", plus );
		GivePlayerMoney(player, plus);
		plus += PlayerInfo[player][Money];
		SendClientMessage(player, COLOR_WHITE, str);
		
		PlayerInfo[player][Money] = plus;
		
		//   Bonus de bani  BANK
		cmoney = PlayerInfo[player][BankMoney];
		cmoney = (cmoney * 5 / 100);
		plus = floatround( cmoney, floatround_ceil );   ///  Bonus 5% in BANK
		
		format( str, sizeof(str), ""#COL_GREEN"Ai primit "#COL_BLUE"$%d "#COL_GREEN"in banca.", plus );
		plus += PlayerInfo[player][BankMoney];
		
		SendClientMessage(player, COLOR_WHITE, str);
		PlayerInfo[player][BankMoney] = plus;
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
	
	///  Level system
	for( new lv = 0;  lv < MAX_LEVEL;  ++lv )
	{
		LevelCostP[lv] = 2 + lv;
		LevelCostM[lv] = 10000 * (lv+1);
	}
	
	//  ================================================================================
	//  PayDay
	PayDay_Text = TextDrawCreate(483.808746, 307.733459, "PayDay");
	TextDrawLetterSize(PayDay_Text, 1.064761, 4.885333);
	TextDrawTextSize(PayDay_Text, 3.333323, 3.199984);
	TextDrawAlignment(PayDay_Text, 1);
	TextDrawColor(PayDay_Text, COLOR_DARKGREEN);
	TextDrawSetShadow(PayDay_Text, 1);
	TextDrawSetOutline(PayDay_Text, 0);
	TextDrawBackgroundColor(PayDay_Text, -1378294017);
	TextDrawFont(PayDay_Text, 3);
	TextDrawSetProportional(PayDay_Text, 1);
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
	
	///  Masini UNREGISTERED
	AddStaticVehicle(509,1802.5951,-1866.7990,13.0626,347.6411,0,0);
	AddStaticVehicle(509,1799.3889,-1866.5785,13.0559,354.4962,0,0);
	AddStaticVehicle(509,1801.1124,-1866.6853,13.0343,355.5555,0,0);
	AddStaticVehicle(509,1798.0996,-1866.5129,13.0557,357.3568,0,0);
	AddStaticVehicle(509,1796.6064,-1866.4248,13.0862,3.4479,0,0);
	AddStaticVehicle(509,1792.9340,-1866.6533,13.0560,359.3485,0,0);
	AddStaticVehicle(509,1791.2216,-1866.6636,13.0563,0.8822,0,0);
	AddStaticVehicle(509,1789.5703,-1866.6317,13.0860,359.1244,0,0);
	///  Masini  REGISTERED
	LoadAllVehicles();
	return 1;
}

public OnGameModeExit()
{
	///  Save Players
	for( new playerid = 0;  playerid < MAX_PLAYERS;  ++playerid ) 
	{
		///  Saving Details
		new INI:file = INI_Open(UserPath(playerid));
		INI_SetTag(file, "PlayerData"); 
		INI_WriteInt(file, "AdminLevel", PlayerInfo[playerid][AdminLevel]);
		INI_WriteInt(file, "HelperLevel", PlayerInfo[playerid][HelperLevel]);
		INI_WriteInt(file, "Skin", PlayerInfo[playerid][Skin]);
		INI_WriteInt(file, "Scores", PlayerInfo[playerid][Scores]);
		INI_WriteInt(file, "Money", PlayerInfo[playerid][Money]);
		INI_WriteInt(file, "BankMoney", PlayerInfo[playerid][BankMoney]);
		INI_WriteInt(file, "Skin", PlayerInfo[playerid][Skin]);
		INI_WriteInt(file, "Kills", PlayerInfo[playerid][Kills]);
		INI_WriteInt(file, "Deaths", PlayerInfo[playerid][Deaths]);
		INI_WriteInt(file, "RespectP", PlayerInfo[playerid][RespectP]);
		
		INI_Close(file);
		///  Saving Details
	}
	///  Save Vehicles
	for( new vehid = 0;  vehid < MAX_VEHICLES;  ++vehid )
	{
		if( fexist( VehiclePath(vehid) ) )
		{
			new INI:file = INI_Open(VehiclePath(vehid)); 
			INI_SetTag(file, "VehicleData"); 
			INI_WriteString(file, "Name", VehicleInfo[vehid][Name]); 
			INI_WriteString(file, "Plate", VehicleInfo[vehid][Plate]); 
			INI_WriteString(file, "Owner", VehicleInfo[vehid][Owner]); 
			INI_WriteInt(file, "ModelID", VehicleInfo[vehid][ModelID]); 
			INI_WriteInt(file, "Color1", VehicleInfo[vehid][Color1]); 
			INI_WriteInt(file, "Color2", VehicleInfo[vehid][Color2]); 
			INI_WriteFloat(file, "ParkX", VehicleInfo[vehid][ParkX]); 
			INI_WriteFloat(file, "ParkY", VehicleInfo[vehid][ParkY]); 
			INI_WriteFloat(file, "ParkZ", VehicleInfo[vehid][ParkZ]); 
			INI_WriteFloat(file, "ParkA", VehicleInfo[vehid][ParkA]); 
			INI_WriteInt(file, "Fuel", VehicleInfo[vehid][Fuel]); 
			INI_WriteInt(file, "Buyable", VehicleInfo[vehid][Buyable]);
			INI_WriteInt(file, "Engine", VehicleInfo[vehid][Engine]); 
			INI_WriteInt(file, "Locked", VehicleInfo[vehid][Locked]); 
			
			INI_Close(file); 
		}
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
    INI_WriteInt(file, "BankMoney", PlayerInfo[playerid][BankMoney]);
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

CMD:buylevel(playerid, params[])
{
	new lv = PlayerInfo[playerid][Scores];
	if( lv == MAX_LEVEL )
	{
		return SendClientMessage( playerid, COLOR_LIGHTBLUE, "You have maximum level. CONGRATULATIONS!" );
	}
	new cM = LevelCostM[lv], cP = LevelCostP[lv];
	new pM = PlayerInfo[playerid][Money], pP = PlayerInfo[playerid][RespectP];
	if( pP < cP )
	{
		new msg[400];
		format(msg, sizeof(msg), ""#COL_GREY"You need "#COL_YELLOW"%d "#COL_GREY"Respect Point(s) to level up.", cM);
		return SendClientMessage(playerid, COLOR_WHITE, msg);
	}
	if( pM < cM )
	{
		new msg[400];
		format(msg, sizeof(msg), ""#COL_GREY"You need "#COL_YELLOW"$%d "#COL_GREY"to level up.", cM);
		return SendClientMessage(playerid, COLOR_WHITE, msg);
	}
	pM -= cM;
	pP -= cP;
	++lv;
	MySetPlayerMoney( playerid, pM );
	PlayerInfo[playerid][RespectP] = pP;
	PlayerInfo[playerid][Scores] = lv;
	
	new msg[400];
	format( msg, sizeof(msg), ""#COL_LIGHTBLUE"You have spent $%d and %d Respect Point(s) to level up.", cM, cP );
	SendClientMessage(playerid, COLOR_WHITE, msg);
	format( msg, sizeof(msg), ""#COL_LIGHTBLUE"You are now level %d.", lv );
	SendClientMessage(playerid, COLOR_WHITE, msg);
	
	return 1;
}
	
	
	
CMD:stats(playerid, params[])
{	
	new playername[MAX_PLAYER_NAME];
	GetPlayerName( playerid, playername, sizeof(playername) );
	
	new title_mess[62];
	format( title_mess, 60, "These are your stats." );
	
	new str_stats[1000], str1[500];
	new cLevel = PlayerInfo[playerid][Scores];
	new cRespectP = PlayerInfo[playerid][RespectP];
	new cNextRP = MyMinim( cLevel, MAX_LEVEL );
	cNextRP = LevelCostP[ cNextRP ];
	new cMoney = PlayerInfo[playerid][Money];
	new cBankMoney = PlayerInfo[playerid][BankMoney];
	new cKills = PlayerInfo[playerid][Kills];
	new cDeaths = PlayerInfo[playerid][Deaths];
	new cNameBanned = PlayerInfo[playerid][UserBan];
	new strNameBan[20];
	format( strNameBan, sizeof(strNameBan), ""#COL_GREEN"No" );
	if( cNameBanned )  format( strNameBan, sizeof(strNameBan), ""#COL_RED"Yes" );
	new cAdmin = PlayerInfo[playerid][AdminLevel];
	new cHelper = PlayerInfo[playerid][HelperLevel];
	format(str1, sizeof(str1), ""#COL_WHITE"Name: "#COL_BLUE"%s \n "#COL_WHITE"Level: "#COL_GREEN"%d \n "#COL_WHITE"Respect Points: "#COL_GREEN"%d/%d \n "#COL_WHITE"Money: "#COL_GREEN"$%d \n "#COL_WHITE"Money in bank: "#COL_GREEN"$%d \n ", playername, cLevel, cRespectP, cNextRP, cMoney, cBankMoney );
	format( str_stats, sizeof(str_stats), "%s"#COL_WHITE"Kills: "#COL_GREEN"%d \n "#COL_WHITE"Deaths: "#COL_GREEN"%d \n "#COL_WHITE"Name banned: "#COL_YELLOW"%s \n "#COL_WHITE"Admin_Level: "#COL_YELLOW"%d \n "#COL_WHITE"Helper_Level: "#COL_YELLOW"%d", str1, cKills, cDeaths, strNameBan, cAdmin, cHelper );
	
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

CMD:givepayday(playerid, params[])
{
	if( !IsPlayerAdmin(playerid) )  return SendClientMessage(playerid, COLOR_YELLOW, "You are not authorized to use this command.");
	Automatic_PayDay();
	return 1;
}

CMD:announce(playerid, params[]) 
{
    new
        string[400],
        pName[MAX_PLAYER_NAME];

    if( PlayerInfo[playerid][AdminLevel] >= 1 || IsPlayerAdmin(playerid) || PlayerInfo[playerid][HelperLevel] >= 1 ) {
		if (isnull(params)) return SendClientMessage(playerid, COLOR_WHITE,"Usage:  /announce [text]");
		GetPlayerName(playerid, pName, sizeof(pName));
		format(string, sizeof(string), ""#COL_RED"[Admin] %s:  "#COL_GREEN"%s", pName, params);
		SendClientMessageToAll(COLOR_LIGHTPINK, string);		
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
		if (!sscanf(params, "ui", toplayerid, amount))
		{
			if (toplayerid != INVALID_PLAYER_ID)
			{
		    new
				message[1000];
			MySetPlayerMoney(toplayerid, amount);
			//  Mesaj la TOPLAYERID
			new aname[MAX_PLAYER_NAME], astr[400], str_amount[400];
			GetPlayerName(playerid, aname, sizeof(aname));
			format(astr, sizeof(astr), "%s", aname);
			format(str_amount, sizeof(str_amount), "%s", amount);
			format(message, sizeof(message), "The Admin %s has set your money to $%s", astr, str_amount);
			
			SendClientMessage(toplayerid, COLOR_RED, message);
			//  Mesaj la ADMIN
			new pname[MAX_PLAYER_NAME], str[400];
			GetPlayerName(toplayerid, pname, sizeof(pname));
			format(str, sizeof(str), "%s", pname);
			format(message, sizeof(message), "You set $%d to %s", amount, str); 
			
			SendClientMessage(playerid, COLOR_RED, message);
			}
			else SendClientMessage(playerid, COLOR_FLBLUE, "That player is not connected");
		}
		else SendClientMessage(playerid, COLOR_YELLOW, "Usage: /setmoney <playerid/name> <amount>");
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
		if (!sscanf(params, "ui", toplayerid, amount))
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
		else SendClientMessage(playerid, COLOR_YELLOW, "Usage: /givemoney <playerid/name> <amount>");
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

///  CAR SYSTEM  ||===============================================================================================||
forward GetVehiclesOwner(vehid);
stock  GetVehiclesOwner(vehid)
{
	new owner[30];
	for( new localid = 0;  localid < TotalVeh;  ++localid )
	{
		if( VehicleInfo[localid][vID] == vehid ){
			format( owner, sizeof(owner), "%s", VehicleInfo[localid][Owner] );
			return owner;
		}
	}
	format(owner, sizeof(owner), "INVALIDVEHICLEOWNER");
	return owner;
}

forward GetGlobalVehicleID( vehicleid );
stock   GetGlobalVehicleID( vehicleid )
{
	new AnswerID = -1;
	for( new localid = 0;  localid < TotalVeh;  ++localid )
	{
		if( VehicleInfo[localid][vID] == vehicleid )
		{
			AnswerID = localid;
		}
	}
	return AnswerID;
}

forward LoadAllVehicles();
public  LoadAllVehicles()
{
	for( new vehid = 0;  vehid < MAX_VEHICLES;  ++vehid )
	{
		if( fexist( VehiclePath(vehid) ) )
		{
			INI_ParseFile(VehiclePath(vehid), "LoadVehicleData", .bExtra = true, .extra = vehid);
			++TotalVeh;
			new cModelID = VehicleInfo[vehid][ModelID];
			new Float:cParkX = VehicleInfo[vehid][ParkX];
			new Float:cParkY = VehicleInfo[vehid][ParkY];
			new Float:cParkZ = VehicleInfo[vehid][ParkZ];
			new Float:cParkA = VehicleInfo[vehid][ParkA];
			new cColor1 = VehicleInfo[vehid][Color1];
			new cColor2 = VehicleInfo[vehid][Color2];
			VehicleInfo[vehid][vID] = CreateVehicle(cModelID, cParkX, cParkY, cParkZ, cParkA, cColor1, cColor2, -1);
			
			new msg[500];
			new cPlate[30];  format(cPlate, sizeof(cPlate), VehicleInfo[vehid][Plate]);
			format(msg, sizeof(msg), "Vehiculul cu ID: %d, cu plate: %s a fost spawnat la: %f %f %f", vehid, cPlate, cParkX, cParkY, cParkZ );
			print(msg);
		}
	}
}

///  CAR COMMANDS
CMD:deleteveh( playerid, params[] )
{
	if( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][AdminLevel] <= 4 )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: You are not authorized to use this command.");
	}
	if( !IsPlayerInAnyVehicle(playerid) )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: You are not in any vehicle.");
	}
	
	new tID = GetPlayerVehicleID(playerid);
	for( new vehid = 0;  vehid < TotalVeh;  ++vehid ) {
		if( tID == VehicleInfo[vehid][vID] )
		{
			--TotalVeh;
			VehicleInfo[vehid] = VehicleInfo[TotalVeh];
			fremove( VehiclePath(TotalVeh) );
			return SendClientMessage( playerid, COLOR_GREEN, "Vehicle deleted succesfully." );
		}
	}
	
	return SendClientMessage(playerid, COLOR_YELLOW, "This vehicle is not in our INI system.");
}

CMD:createveh( playerid, params[] )
{
	if( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][AdminLevel] <= 4 )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: You are not authorized to use this command.");
	}
	new cModelID, cColor1, cColor2, cPlate[30];
	if( sscanf( params, "ddds[30]", cModelID, cColor1, cColor2, cPlate ) ) 
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Usage: /createveh <ModelID> <Color1> <Color2> <PlateNumber>");
	}
	if( cModelID < 400 || cModelID > 611 )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: Invalid ModelID, it should be in range 400-611.");
	}
	if( cColor1 < 0 || cColor2 < 0 || cColor1 > 255 || cColor2 > 255 )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: Invalid color(s), both should be in range 0-255");
	}
	if( TotalVeh >= MAX_VEHICLES )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "You cannot create a new vehicle, the limit of created vehicles has been reached.");
	}
	
	new Float:cParkX, Float:cParkY, Float:cParkZ, Float:cParkA;
	GetPlayerPos(playerid, cParkX, cParkY, cParkZ);
	GetPlayerFacingAngle(playerid, cParkA);
	
	SendClientMessage(playerid, COLOR_GREEN, "0 Starting building the vehicle.");
	
	///  Setam variabilele
	new NEWVID = TotalVeh;
	++TotalVeh;
	new cOwner[MAX_PLAYER_NAME];
	GetPlayerName(playerid, cOwner, MAX_PLAYER_NAME);	
	
	new cName[40];
	format(cName, sizeof(cName), "%s", GetVehicleName_Model(cModelID) );
	
	SendClientMessage(playerid, COLOR_GREEN, "1 Starting building the vehicle.");
	
	////  Avoiing data corruption
	VehicleInfo[NEWVID][ModelID] = cModelID;
	VehicleInfo[NEWVID][Name] = cName;
	VehicleInfo[NEWVID][Plate] = cPlate;
	VehicleInfo[NEWVID][Owner] = cOwner;
	VehicleInfo[NEWVID][Color1] = cColor1;
	VehicleInfo[NEWVID][Color2] = cColor2;
	VehicleInfo[NEWVID][ParkX] = cParkX;
	VehicleInfo[NEWVID][ParkY] = cParkY;
	VehicleInfo[NEWVID][ParkZ] = cParkZ;
	VehicleInfo[NEWVID][ParkA] = cParkA;
	VehicleInfo[NEWVID][Fuel]  = 100;
	VehicleInfo[NEWVID][Engine] = 1;
	VehicleInfo[NEWVID][Buyable] = 0;
	VehicleInfo[NEWVID][Locked] = 0;
	
	SendClientMessage(playerid, COLOR_GREEN, "2 Starting building the vehicle.");
	
	VehicleInfo[NEWVID][vID] = CreateVehicle(cModelID, cParkX, cParkY, cParkZ, cParkA, cColor1, cColor2, -1);
	
	SendClientMessage(playerid, COLOR_GREEN, "Vehicle built.");
	
	PutPlayerInVehicle(playerid, VehicleInfo[NEWVID][vID], 0);
	
	SendClientMessage(playerid, COLOR_GREEN, "You are in the vehicle.");
	///  Setting the ini_file
	new INI:file = INI_Open(VehiclePath(NEWVID)); 
	INI_SetTag(file, "VehicleData"); 
	INI_WriteString(file, "Name", VehicleInfo[NEWVID][Name]); 
	INI_WriteString(file, "Plate", VehicleInfo[NEWVID][Plate]); 
	INI_WriteString(file, "Owner", VehicleInfo[NEWVID][Owner]); 
	INI_WriteInt(file, "ModelID", VehicleInfo[NEWVID][ModelID]); 
	INI_WriteFloat(file, "ParkX", VehicleInfo[NEWVID][ParkX]); 
	INI_WriteFloat(file, "ParkY", VehicleInfo[NEWVID][ParkY]); 
	INI_WriteFloat(file, "ParkZ", VehicleInfo[NEWVID][ParkZ]); 
	INI_WriteFloat(file, "ParkA", VehicleInfo[NEWVID][ParkA]); 
	INI_WriteInt(file, "Fuel", VehicleInfo[NEWVID][Fuel]); 
	INI_WriteInt(file, "Buyable", VehicleInfo[NEWVID][Buyable]); 
	INI_WriteInt(file, "Locked", VehicleInfo[NEWVID][Locked]); 
	
	INI_Close(file); 
	
	SendClientMessage(playerid, COLOR_GREEN, "Vehicle saved in the ini system.");
	
	return 1;
}

CMD:parkveh( playerid, params )
{
	if( !IsPlayerInAnyVehicle(playerid) )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: You are not in any vehicle.");
	}
	new Pname[MAX_PLAYER_NAME];
	format(Pname, sizeof(Pname), GetPlayersName(playerid) );
	new Oname[MAX_PLAYER_NAME];
	format(Oname, sizeof(Oname), GetVehiclesOwner( GetPlayerVehicleID(playerid) ) );
	if( strlen(Pname) != strlen(Oname) )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: You are not the owner of this vehicle.");
	}
	if( strcmp(Pname, Oname, false, MAX_PLAYER_NAME) )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "Error: You are not the owner of this vehicle.");
	}
	new Float:cParkX, Float:cParkY, Float:cParkZ, Float:cParkA;
	GetVehiclePos( GetPlayerVehicleID(playerid), cParkX, cParkY, cParkZ );
	GetVehicleZAngle( GetPlayerVehicleID(playerid), cParkA );
	new vehid = GetGlobalVehicleID( GetPlayerVehicleID(playerid) );
	VehicleInfo[vehid][ParkX] = cParkX;
	VehicleInfo[vehid][ParkY] = cParkY;
	VehicleInfo[vehid][ParkZ] = cParkZ;
	VehicleInfo[vehid][ParkA] = cParkA;
	
	SendClientMessage( playerid, COLOR_LIGHTBLUE, "You parked your vehicle." );
	
	return 1;	
}
	
CMD:repairveh(playerid, params[])
{
	if( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][HelperLevel] <= 1 && PlayerInfo[playerid][AdminLevel] <= 0 )
	{
		return SendClientMessage( playerid, COLOR_YELLOW, "Error: You are not authorized to use this command." );
	}
	if( !IsPlayerInAnyVehicle(playerid) )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "You are not in a vehicle.");
	}
	RepairVehicle( GetPlayerVehicleID(playerid) );
	SetVehicleHealth( GetPlayerVehicleID(playerid), 1000.0 );
	SendClientMessage(playerid, COLOR_GREEN, "You repaired the vehicle you are in.");
	
	return 1;
}

CMD:rv(playerid, params[])
{
	if( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][HelperLevel] <= 1 && PlayerInfo[playerid][AdminLevel] <= 0 )
	{
		return SendClientMessage( playerid, COLOR_YELLOW, "Error: You are not authorized to use this command." );
	}
	if( !IsPlayerInAnyVehicle(playerid) )
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "You are not in a vehicle.");
	}
	RepairVehicle( GetPlayerVehicleID(playerid) );
	SetVehicleHealth( GetPlayerVehicleID(playerid), 1000.0 );
	SendClientMessage(playerid, COLOR_GREEN, "You repaired the vehicle you are in.");
	
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
		format( mess, sizeof(mess), ""#COL_GREEN"The user "#COL_WHITE"%s "#COL_GREEN"has been unbanned.", targetname );
		return SendClientMessage( playerid, COLOR_WHITE, mess );
	}

	return SendClientMessage( playerid, COLOR_YELLOW, "The user does not exists on our system." );
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

///  Godlike functions
CMD:getheal( playerid, params[] ) {
	if( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][AdminLevel] <= 0 )
	{
		return SendClientMessage( playerid, COLOR_YELLOW, "You are not authorized to use this command" );
	}
	SetPlayerHealth(playerid, 100.0);
	SendClientMessage( playerid, COLOR_GREEN, "Your health is now full!" );
	return 1;
}

CMD:getarmour( playerid, params[] ) {
	if( !IsPlayerAdmin(playerid) && PlayerInfo[playerid][AdminLevel] <= 0 )
	{
		return SendClientMessage( playerid, COLOR_YELLOW, "You are not authorized to use this command" );
	}
	SetPlayerArmour(playerid, 100.0);
	SendClientMessage( playerid, COLOR_GREEN, "Your armour is now full!" );
	return 1;
}

CMD:duty( playerid, params[] ) {
	if( !IsPlayerAdmin(playerid) && !PlayerInfo[playerid][AdminLevel] && !PlayerInfo[playerid][HelperLevel] ) 
	{
		return SendClientMessage( playerid, COLOR_YELLOW, "You are not authorized to use this command." );
	}
	
	new str[400], status[100], name[100];
	GetPlayerName(playerid, name, sizeof(name));
	format( status, sizeof(status), "Helper-ul" );
	if( PlayerInfo[playerid][AdminLevel] )  format( status, sizeof(status), "Admin-ul" );
	if( IsPlayerAdmin(playerid) )  format( status, sizeof(status), "Fondatorul" );
	
	if( GetPlayerColor(playerid) == COLOR_LIGHTPINK ) {
		SetPlayerColor( playerid, COLOR_WHITE );
		
		
		format( str, sizeof(str), ""#COL_RED"%s %s "#COL_GREEN"este acum OFF DUTY.", status, name );
		return SendClientMessageToAll( COLOR_WHITE, str );
	}
	else {
		SetPlayerColor(playerid, COLOR_LIGHTPINK);
		
		format( str, sizeof(str), ""#COL_RED"%s %s "#COL_GREEN"este acum ON DUTY.", status, name );
		return SendClientMessageToAll( COLOR_WHITE, str );
	}
	
}
  /*
CMD:tp( playerid, params[] ) {
	if( !IsPlayerAdmin(playerid) && !PlayerInfo[playerid][AdminLevel] && !PlayerInfo[playerid][HelperLevel] )
	{
		return SendClientMessage( playerid, COLOR_YELLOW, "You are not authorized to use this command." );
	}
	if
	
	*/
	
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
                INI_WriteInt(file, "BankMoney", 0); 
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
					
					new wmsg[400], pname[MAX_PLAYER_NAME];
					GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
					format( wmsg, sizeof(wmsg), ""#COL_CYAN"Player "#COL_LIGHTBLUE"%s "#COL_CYAN"has joined the server.", pname );
					SendClientMessageToAll(COLOR_WHITE, wmsg);
                    
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
