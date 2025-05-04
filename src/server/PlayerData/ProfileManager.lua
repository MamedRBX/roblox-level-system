--// Services
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")


--// Modules
local ProfileService = require(ServerScriptService.Server.Libs.ProfileService)
local DataTemplate = require(ReplicatedStorage.Shared.PlayerData.template)
local remoteEvents = require(ReplicatedStorage.Shared.Remotes.RemoteEvents) 


--// Remote for State Manager 
local GetAllDataRemote = ReplicatedStorage.Shared.Remotes:WaitForChild("GetAllData")


local ProfileManager = {}
ProfileManager.__index = ProfileManager


--// Game Data Key
local DataStoreName = "PlayerData_V1_1"
local ProfileStore = ProfileService.GetProfileStore(DataStoreName, DataTemplate)


--//Backup Data Key
local BackupDataStore = DataStoreService:GetDataStore("Backup_PlayerData_V1_1")  


--//Players Profiles
ProfileManager.profiles = {}


--// Leaderstats whenever the player loads
local function LoadLeaderstats(player: Player)
	local profile = ProfileManager.profiles[player]
	if not profile then return warn("[ProfileManager]: Missing profile") end

	local Leaderstats = Instance.new("Folder", player)
	Leaderstats.Name = "leaderstats"
	
	local Xp = Instance.new("NumberValue", Leaderstats)
	Xp.Name = "Xp"
	Xp.Value = profile.Data.Xp

	local Level = Instance.new("NumberValue",Leaderstats)
	Level.Name = "Level"
	Level.Value = profile.Data.Level
end


--// Load player and Profile when player joins
function ProfileManager.LoadPlayer(player)
	task.wait(1) -- Prevents session locking issues

	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		ProfileManager.profiles[player] = profile 

		profile:ListenToRelease(function()
			ProfileManager.profiles[player] = nil
			player:Kick("Your data has been loaded elsewhere.") 
		end)
		
		if player:IsDescendantOf(Players) == true then
			LoadLeaderstats(player)
		else
			profile:Release()
		end
		
	else
		--  If main data fails, try loading from backup
		local success, backupData = pcall(function()
			return BackupDataStore:GetAsync("Player_" .. player.UserId)
		end)

		if success and backupData then
			print(` Restoring backup for {player.Name}`)
			ProfileManager.profiles[player] = {
				Data = backupData,
				IsActive = function() return true end,
				Save = function() end, --  Disable saving for backups
			}
		else
			player:Kick(" Data failed to load, and no backup was found.")
		end
	end
end


--// Save
function ProfileManager.Save(player)
	local profile = ProfileManager.profiles[player]
	if profile and profile:IsActive() then
		profile:Save() 

		--  Also save a backup
		local success, err = pcall(function()
			BackupDataStore:UpdateAsync("Player_" .. player.UserId, function(oldData)
				oldData = oldData or {} 
				table.insert(oldData, 1, profile.Data)

				if #oldData > 3 then --  Keep only the latest 3 backups
					table.remove(oldData, #oldData)
				end

				return oldData
			end)
		end)

		if not success then
			warn(`⚠️ Backup failed for {player.Name}: {err}`)
		end
	end
end


--// Force save (for debugging/admin commands)
function ProfileManager.ForceSave(player)
	print(`🔴 Force Saving Data for {player.Name}`)
	ProfileManager.Save(player)
end


--// Rollback Restores backup and saves immediately
function ProfileManager.Rollback(player, version)
	local success, backupData = pcall(function()
		return BackupDataStore:GetAsync("Player_" .. player.UserId)
	end)

	if success and backupData and backupData[version] then
		print(`🚨 Rolling back {player.Name} to version {version}`)

		--  Clone backup to prevent modification issues
		ProfileManager.profiles[player].Data = table.clone(backupData[version])

		
		ProfileManager.Save(player)
	else
		warn(`⚠️ Rollback failed for {player.Name}: No valid backup found.`)
	end
end


for _, player in Players:GetPlayers() do 
	task.spawn(ProfileManager.LoadPlayer , player)
end


--// Init the Module
function ProfileManager.Init()
	
end


--// Fetching profile for the State Manager
local function GetAllData(player:Player)
	local profile = ProfileManager.profiles[player]
	if not profile then return end
	return profile.Data
end

GetAllDataRemote.OnServerInvoke = GetAllData --sends State Manager current state from start


return ProfileManager