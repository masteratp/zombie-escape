GM.Name     = "ZombieEscape"
GM.Author   = "Samuel 'samm5506' Maddock"
GM.Website  = "http://samuelmaddock.com/"

DeriveGamemode('base')

include('player_class/player_ze.lua')
include('player_class/player_human.lua')
include('player_class/player_zombie.lua')
include('player_class/player_spectator.lua')

include('animations.lua')
include('sh_meta.lua')
include('sh_load.lua')

CVars = {}
CVars.Version = CreateConVar( "ze_version", "1.1.0.1", {FCVAR_REPLICATED,FCVAR_PRINTABLEONLY}, "Zombie Escape gamemode version." )

TEAM_SPECTATOR = 1
TEAM_ZOMBIES = 2
TEAM_HUMANS = 3

TEAM_BOTH = { TEAM_ZOMBIES, TEAM_HUMANS }

Loader.Load( "extensions" )
Loader.Load( "modules" )

function GM:CreateTeams()

	self.BaseClass.CreateTeams( self )

	team.SetUp( TEAM_SPECTATOR, "Spectators", Color(255,253,122) )
	team.SetUp( TEAM_HUMANS, "Humans", Color(42,190,235) )
	team.SetUp( TEAM_ZOMBIES, "Zombies", Color(0,180,0) )

	if self.SwapSpawns then
		team.SetSpawnPoint( TEAM_HUMANS, "info_player_terrorist" )
		team.SetSpawnPoint( TEAM_ZOMBIES, "info_player_counterterrorist" )
	else
		team.SetSpawnPoint( TEAM_HUMANS, "info_player_counterterrorist" )
		team.SetSpawnPoint( TEAM_ZOMBIES, "info_player_terrorist" )
	end

	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_counterterrorist", "info_player_terrorist" } )

end

function GM:GetGameDescription()
	return "Zombie Escape"
end

function GM:GetGamemodeDescription()
	return self:GetGameDescription()
end

timer.Create( "PlayerThinkTimer", 1.0, 0, function()

	if SERVER then

		for _, ply in pairs( player.GetAll() ) do

			if IsValid( ply ) then
				player_manager.RunClass( ply, "Think" )
			end

		end

	else
		if IsValid( LocalPlayer() ) then
			player_manager.RunClass( LocalPlayer(), "Think" )
		end
	end

end)

local prefix_ze = "[ZE] "
local color_ze = Color(147,255,25)
function MsgZE( str )

	if !str then return end
	str = tostring(str)

	MsgC( color_ze, prefix_ze, str, "\n" )

end

-- Remove unused default hooks
hook.Remove( "PlayerTick", "TickWidgets" )