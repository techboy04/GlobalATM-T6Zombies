#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    level thread onPlayerConnect();
    if ( getDvar( "g_gametype" ) != "zgrief" )
    {
    	level.globalpoints = 0;
    	level setatmlocation();
    	level thread spawnATMDeposit();
    	level thread spawnATMWithdraw();
    }
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
	self notifyonplayercommand("useatm", "+activate");
    for(;;)
    {
        self waittill("spawned_player");

		if ( getDvar( "g_gametype" ) != "zgrief" )
		{
			self iprintln("^4Global ATM ^7created by ^1techboy04gaming");
		}
    }
}

spawnATMDeposit()
{
	depositTrigger = spawn( "trigger_radius", (level.depositlocation), 1, 50, 50 );
	depositTrigger setHintString("^7Press ^3&&1 ^7to deposit ^31000 ^7to the global ATM (^3$" + level.globalpoints + "^7)");
	depositTrigger setcursorhint( "HINT_NOICON" );
	depositfx = spawn("script_model", (level.depositlocation), 1, 50, 50 );
	depositfx setmodel("tag_origin");
	playfxontag( level._effect["powerup_on"], depositfx, "tag_origin" );

	while(1)
	{
		depositTrigger waittill( "trigger", i );
		depositTrigger setHintString("^7Press ^3&&1 ^7to deposit ^31000 ^7to the global ATM (^3$" + level.globalpoints + "^7)");
		if ( (i.score >= 1000) )
		{
			i waittill("useatm");
			i.score -= 1000;
			i playsound ("zmb_weap_wall");
			level.globalpoints += 1000;
		}
	}
}

spawnATMWithdraw()
{
	withdrawTrigger = spawn( "trigger_radius", (level.withdrawlocation), 1, 50, 50 );
	withdrawTrigger setHintString("^7Press ^3&&1 ^7to withdraw ^31000 ^7from the global ATM (^3$" + level.globalpoints + "^7)");
	withdrawTrigger setcursorhint( "HINT_NOICON" );
	withdrawfx = spawn("script_model", (level.withdrawlocation), 1, 50, 50 );
	withdrawfx setmodel("tag_origin");
	playfxontag( level._effect["powerup_on"], withdrawfx, "tag_origin" );

	while(1)
	{
		withdrawTrigger waittill( "trigger", i );
		withdrawTrigger setHintString("^7Press ^3&&1 ^7to withdraw ^31000 ^7from the global ATM (^3$" + level.globalpoints + "^7)");
		if ( (level.globalpoints >= 1000) && (level.globalpoints != 0) )
		{
			i waittill("useatm");
			i.score += 1000;
			i playsound ("zmb_cha_ching");
			level.globalpoints -= 1000;
		}
	}
}

setatmlocation()
{
	if ( getDvar( "g_gametype" ) == "zgrief" || getDvar( "g_gametype" ) == "zstandard" )
	{
		if(getDvar("mapname") == "zm_prison") //mob of the dead grief
		{

		}
		else if(getDvar("mapname") == "zm_buried") //buried grief
		{

		}
		else if(getDvar("mapname") == "zm_nuked") //nuketown
		{
			level.depositlocation = (-642,271,-35);
			level.withdrawlocation = (-789,652,-35);
		}
		else if(getDvar("mapname") == "zm_transit") //transit grief and survival
		{
			if(getDvar("ui_zm_mapstartlocation") == "town")
			{
				level.depositlocation = (750,434,-19); //Town
				level.withdrawlocation = (643,23,-19);
			}
			else if (getDvar("ui_zm_mapstartlocation") == "transit")
			{
				level.depositlocation = (-7931,4993,-36); //Town
				level.withdrawlocation = (-8021,4722,-36);
			}
			else if (getDvar("ui_zm_mapstartlocation") == "farm")
			{
				level.depositlocation = (8340,-4711,284);
				level.withdrawlocation = (8047,-5313,284);
			}
		}
	}
	else
	{
		if(getDvar("mapname") == "zm_prison") //mob of the dead
		{
			level.depositlocation = (1706,10684,1358);
			level.withdrawlocation = (942,10678,1356);
		}
		else if(getDvar("mapname") == "zm_buried") //buried
		{
			level.depositlocation = (-448,-237,30);
			level.withdrawlocation = (-443,-37,28);
		}
		else if(getDvar("mapname") == "zm_transit") //transit
		{
			level.depositlocation = (750,434,-19); //Town
			level.withdrawlocation = (643,23,-19);
		}
		else if(getDvar("mapname") == "zm_tomb") //origins
		{
			level.depositlocation = (2451,4457,-295);
			level.withdrawlocation = (1935,5058,-287);
		}
		else if(getDvar("mapname") == "zm_highrise")
		{
			level.depositlocation = (1367,-419,1316);
			level.withdrawlocation = (1665,-418,1316);
		}
	}
}
