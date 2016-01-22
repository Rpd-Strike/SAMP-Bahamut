#include        <  a_samp >
#include        <  ZCMD   >
#include        < sscanf  >
#include    <YSI\y_ini>


#define COL_RED         \
                "{F81414}"

#define COL_LIGHTBLUE   \
                "{00C0FF}"

#define COL_LRED        \
                "{FFA1A1}"

#define COL_GREEN       \
                "{6EF83C}"

#define DIALOG_REG      \
                1995

#define DIALOG_REG_REQ  \
                1996

#define DIALOG_LOGIN    \
                1997

#define DIALOG_LOGIN2   \
                1998

#define DIALOG_LOG_DONE \
                1999

#define DIALOG_LOG      \
                2000

#define DIALOG_STATS    \
                2001

public OnFilterScriptInit( )    return 1;
public OnFilterScriptExit( )    return 1;


forward ParsePlayerPass( playerid, name[ ], value[ ] );
public ParsePlayerPass( playerid, name[ ], value[ ] )
{
    if ( !strcmp( name, "PASSWORD" ) )
    {
        SetPVarString( playerid, "pPass", value );
    }
}

forward LoadUser( playerid, name[ ], value[ ] );
public LoadUser( playerid, name[ ], value[ ] )
{
    if ( !strcmp(name, "REG_DATE" ) )SetPVarString( playerid, "Date", value );

    if ( !strcmp(name, "MONEYS" ) )SetPVarInt( playerid, "Moneys", strval( value ) );

    if ( !strcmp(name, "SCORE" ) )SetPVarInt( playerid, "Score", strval( value ) );
}

CMD:register( playerid, params[ ] )
{
        #pragma unused params
        if ( GetPVarInt( playerid, "Logged" ) == 1 )
            return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You are already registered and logged in.");

    ShowPlayerDialog( playerid, DIALOG_REG, DIALOG_STYLE_INPUT, "{FFFFFF}Registering...", "{FFFFFF}Please write your desired password.", ">>>", "Exit");
        return 1;
}
CMD:login( playerid, params[ ] )
{
        #pragma unused params
        if ( GetPVarInt( playerid, "Logged" ) == 1 )
            return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} You are already registered and logged in.");

    ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Login", "{FFFFFF}Please write your current password", "Login", "Kick");
        return 1;
}
CMD:stats( playerid, paramz[ ] )
{
        if ( GetPVarInt( playerid, "Logged" ) == 0 )
            return SendClientMessage( playerid, -1, ""COL_RED"ERROR:{FFFFFF} To view your stats you must be logged in ");

        new
                iBox[ 256 ],
                RegDate[ 10 + 15 ]
        ;
        GetPVarString( playerid, "Date", RegDate, 10 + 15 );
        format( iBox, sizeof iBox, "{FFFFFF}Hello "COL_LIGHTBLUE"%s{FFFFFF}, these are your stats\n\n\
                                    {FFFFFF}Moneys: "COL_LIGHTBLUE"%d\n\
                                    {FFFFFF}Score: "COL_LIGHTBLUE"%d\n\
                                    {FFFFFF}Registration Date: "COL_LIGHTBLUE"%s\n\
                                    {FFFFFF}Interior: "COL_LIGHTBLUE"%d\n\
                                                                {FFFFFF}Virtual World: "COL_LIGHTBLUE"%d",pName( playerid ),
                                                                                          GetPlayerMoney( playerid ),
                                                                                          GetPlayerScore( playerid ),
                                                                                          RegDate,
                                                                                          GetPlayerInterior( playerid ),
                                                                                          GetPlayerVirtualWorld( playerid ) )
                                                                ;
        ShowPlayerDialog( playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{FFFFFF}Your Stats!", iBox, "Ok", "");
        return 1;
}

///  FunCtiI
main()
{
  print("\n----------------------------------");
  print(" Bahamut Gamemode by your name here");
  print("----------------------------------\n");
}

public OnGameModeInit()
{
  SetGameModeText("Roleplay");
  DisableInteriorEnterExits();
  UsePlayerPedAnims();
  ShowPlayerMarkers(0);
  LimitGlobalChatRadius(50.0);

  AddPlayerClass(60,1781.2979,-1863.4768,13.5750,304.8684,0,0,0,0,0,0);

  AddStaticVehicle(509,1802.5951,-1866.7990,13.0626,347.6411,0,0); // Bike1
  AddStaticVehicle(509,1799.3889,-1866.5785,13.0559,354.4962,0,0); // Bike3
  AddStaticVehicle(509,1801.1124,-1866.6853,13.0343,355.5555,0,0); // Bike2
  AddStaticVehicle(509,1798.0996,-1866.5129,13.0557,357.3568,0,0); // Bike4
  AddStaticVehicle(509,1796.6064,-1866.4248,13.0862,3.4479,0,0); // Bike5
  AddStaticVehicle(509,1792.9340,-1866.6533,13.0560,359.3485,0,0); // Bike6
  AddStaticVehicle(509,1791.2216,-1866.6636,13.0563,0.8822,0,0); // Bike7
  AddStaticVehicle(509,1789.5703,-1866.6317,13.0860,359.1244,0,0); // Bike8
  return 1;
}

public OnGameModeExit()
{
  return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
  SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
  SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
  SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
  return 1;
}

public OnPlayerConnect(playerid)
{
  if ( !INI_Exist( pName( playerid ) ) )
                ShowPlayerDialog( playerid, DIALOG_REG_REQ, DIALOG_STYLE_MSGBOX, "{FFFFFF}Password", "{FFFFFF}To play you must register an account!", "Ok", "");
        else
            ShowPlayerDialog( playerid, DIALOG_LOGIN, DIALOG_STYLE_MSGBOX, "{FFFFFF}Password", "{FFFFFF}Your name is registered, would you like to login?", "Da", "Nu");
        return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
  if ( GetPVarInt( playerid, "Logged" ) == 1 && INI_Exist( pName( playerid ) ) )
        {
                new
                        PlayerFile[ 13 + MAX_PLAYER_NAME + 1];

            format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );


            new
                        INI:PlayerAcc = INI_Open( PlayerFile );

                INI_WriteInt( PlayerAcc,    "MONEYS", GetPlayerMoney( playerid ) );
                INI_WriteInt( PlayerAcc,    "SCORE",  GetPlayerScore( playerid ) );
                INI_Close( PlayerAcc );
        }
        SetPVarInt( playerid, "Logged", 0 );
        return 1;
}

public OnPlayerSpawn(playerid)
{
  return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
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

public OnPlayerCommandText(playerid, cmdtext[])
{
  if (strcmp("/mycommand", cmdtext, true, 10) == 0)
  {
    // Do something here
    return 1;
  }
  return 0;
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
  switch( dialogid )
        {
            case DIALOG_REG:
            {
                if ( response )
                {
                    if ( sscanf( inputtext, "s", inputtext[ 0 ] || strlen( inputtext[ 0 ] ) == 0 ) )
                        return ShowPlayerDialog( playerid, DIALOG_REG, DIALOG_STYLE_INPUT, "{FFFFFF}Password", ""COL_RED"Error!\n\
                                                                                                                                                                                        {FFFFFF}Please write your desired password.\n",
                                                                                                                                                                                        ">>>", "Exit");
                        if ( strlen( inputtext[ 0 ] ) < 3 || strlen( inputtext[ 0 ] ) > 20 )
                                return ShowPlayerDialog( playerid, DIALOG_REG, DIALOG_STYLE_INPUT, "{FFFFFF}Password", ""COL_RED"Error!\n\
                                                                                                                                                                                        {FFFFFF}Please write your desired password.\n\
                                                                                                                                                                                        "COL_RED"#{FFFFFF}Min. 3 Char. Max. 20 Char.",
                                                                                                                                                                                        ">>>", "Exit");
                                new
                                        PlayerFile[ 13 + MAX_PLAYER_NAME ],
                                        pDate[ 8 + 15 ], //HH:MM:SS + DD.MM.YYYY = 18
                                        pYear,
                                        pMonth,
                                        pDay,
                                        pHour,
                                        pMinute,
                                        pSecond,
                                        pIP[ 20 ],
                                        InfBox[ 512 ]
                                ;
                                getdate(pYear, pMonth, pDay ),gettime(pHour, pMinute, pSecond );
                                GetPlayerIp( playerid, pIP, 20 );

                                format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
                                format( pDate, sizeof pDate, "%d:%d:%d  %d/%d/%d",pHour, pMinute, pSecond , pDay, pMonth, pYear );
                            format( InfBox, sizeof InfBox, "{FFFFFF}You registered your account with success!\n\n\
                                                                    "COL_LIGHTBLUE"Account: {FFFFFF}%s\n\
                                                                    "COL_LIGHTBLUE"Password: {FFFFFF}%s\n\n\
                                                                    You received "COL_GREEN"$5000{FFFFFF} for registering.\n\
                                                                    Would you like to login?", pName( playerid ),
                                                                                                                                                                 inputtext               );
                                ShowPlayerDialog( playerid, DIALOG_LOG, DIALOG_STYLE_MSGBOX, "Login", InfBox, "Yes", "No" );



                                new
                                        INI:PlayerAcc = INI_Open( PlayerFile );

                INI_WriteString( PlayerAcc, "NAME",                               pName( playerid )        );
                                INI_WriteString( PlayerAcc, "PASSWORD",                   inputtext            );
                                INI_WriteString( PlayerAcc, "REG_DATE",                   pDate                            );
                                INI_WriteInt( PlayerAcc,    "MONEYS",             5000                 );
                                INI_WriteInt( PlayerAcc,    "SCORE",              15                   );
                                INI_Close( PlayerAcc );

                                SetPVarString( playerid, "Date", pDate );
                                SetPVarInt( playerid, "Logged", 0 );
                                GivePlayerMoney( playerid, 5000 );
                                SetPlayerScore( playerid, GetPlayerScore( playerid ) + 15 );


                        }
                }
                case DIALOG_REG_REQ:
                {
                    if ( response ) cmd_register( playerid, "");
                    if ( !response ) return 0;

                }

                case DIALOG_LOGIN: ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Password",
                                                                                                                                                                                  "{FFFFFF}Please write your current password.",
                                                                                                                                                                                  "Login", "Kick");

                case DIALOG_LOG:
                {
                    if ( response )
                ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Password",      "{FFFFFF}Please write your current password.","Login","Kick");
                }
                case DIALOG_LOGIN2:
                {
                    if ( !response ) return Kick( playerid );
                    if ( response )
                    {
                            if ( strlen( inputtext ) == 0 )
                                return ShowPlayerDialog( playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, "{FFFFFF}Password",       ""COL_RED"Error!\n\
                                                                                                                                                                                                                                {FFFFFF}Please write your current password.",
                                                                                                                                                                                                                                "Login", "Kick");

                            new
                                        PlayerFile[ 13 + MAX_PLAYER_NAME ],
                                        Password[ 20 + 1 ]
                                ;
                            format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
                        INI_ParseFile( PlayerFile, "ParsePlayerPass", false, true, playerid );
                        GetPVarString( playerid, "pPass", Password, sizeof Password );

                        if ( !strcmp ( inputtext, Password, false ) )
                        {
                            new
                                                sTitle[ 21 + MAX_PLAYER_NAME + 25 ],
                                                sBoxInfo[ 512 ],
                                                Pdata[ 8 + 15 ]
                                        ;

                                        SetPVarInt( playerid, "Logged", 1 );
                                        format( PlayerFile , sizeof PlayerFile, "Accounts/%s.ini", Encode( pName( playerid ) ) );
                            INI_ParseFile( PlayerFile, "LoadUser", false, true, playerid, true, false );
                            GetPVarString( playerid, "Date", Pdata, 8 + 10 );
                                        GivePlayerMoney( playerid,GetPVarInt( playerid, "Moneys" )  );
                                        SetPlayerScore( playerid, GetPVarInt( playerid, "Score" )  );

                            format( sTitle, sizeof sTitle, "{FFFFFF}Welcome back, "COL_LIGHTBLUE"%s{FFFFFF}!", pName( playerid ) );
                            format( sBoxInfo, sizeof sBoxInfo, "{FFFFFF}These are your stats:\n\n\
                                                                {FFFFFF}Moneys: "COL_LIGHTBLUE"%d\n\
                                                                {FFFFFF}Score: "COL_LIGHTBLUE"%d\n\
                                                                {FFFFFF}Registered on: "COL_LIGHTBLUE"%s", GetPVarInt( playerid, "Moneys" ),
                                                                                                                                                                                                   GetPVarInt( playerid, "Score" ),
                                                                                                                                                                                                   Pdata );
                                        ShowPlayerDialog(playerid, DIALOG_LOG_DONE, DIALOG_STYLE_MSGBOX, sTitle, sBoxInfo, "Ok", "");

                        }
                        else ShowPlayerDialog(playerid, DIALOG_LOGIN2, DIALOG_STYLE_INPUT, ""COL_RED"Wrong password...", ""COL_RED"Wrong password!\n{FFFFFF}Please try again.", "Login", "Kick");


                }
                }
        }
        return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
  return 1;
}


/// STOCKS

stock INI_Exist(nickname[])
{
  new tmp[255];
  format(tmp,sizeof(tmp),"Accounts/%s.ini",Encode( nickname ) );
  return fexist(tmp);
}

stock pName( playerid )
{
        new Name[ MAX_PLAYER_NAME ];
        GetPlayerName( playerid, Name, sizeof( Name ) );
        return Name;
}

//DracoBlue
stock Encode(nickname[])
{
  new tmp[255];
  set(tmp,nickname);
  tmp=strreplace("_","_00",tmp);
  tmp=strreplace(";","_01",tmp);
  tmp=strreplace("!","_02",tmp);
  tmp=strreplace("/","_03",tmp);
  tmp=strreplace("\\","_04",tmp);
  tmp=strreplace("[","_05",tmp);
  tmp=strreplace("]","_06",tmp);
  tmp=strreplace("?","_07",tmp);
  tmp=strreplace(".","_08",tmp);
  tmp=strreplace("*","_09",tmp);
  tmp=strreplace("<","_10",tmp);
  tmp=strreplace(">","_11",tmp);
  tmp=strreplace("{","_12",tmp);
  tmp=strreplace("}","_13",tmp);
  tmp=strreplace(" ","_14",tmp);
  tmp=strreplace("\"","_15",tmp);
  tmp=strreplace(":","_16",tmp);
  tmp=strreplace("|","_17",tmp);
  tmp=strreplace("=","_18",tmp);
 return tmp;
}
stock set(dest[],source[]) {
        new count = strlen(source);
        new i=0;
        for (i=0;i<count;i++) {
                dest[i]=source[i];
        }
        dest[count]=0;
}
stock strreplace(trg[],newstr[],src[]) {
   new f=0;
   new s1[255];
   new tmp[255];
   format(s1,sizeof(s1),"%s",src);
   f = strfind(s1,trg);
   tmp[0]=0;
   while (f>=0) {
       strcat(tmp,ret_memcpy(s1, 0, f));
       strcat(tmp,newstr);
       format(s1,sizeof(s1),"%s",ret_memcpy(s1, f+strlen(trg), strlen(s1)-f));
       f = strfind(s1,trg);
   }
   strcat(tmp,s1);
   return tmp;
}
ret_memcpy(source[],index=0,numbytes) {
        new tmp[255];
        new i=0;
        tmp[0]=0;
        if (index>=strlen(source)) return tmp;
        if (numbytes+index>=strlen(source)) numbytes=strlen(source)-index;
        if (numbytes<=0) return tmp;
        for (i=index;i<numbytes+index;i++) {
                tmp[i-index]=source[i];
                if (source[i]==0) return tmp;
        }
        tmp[numbytes]=0;
        return tmp;
}
