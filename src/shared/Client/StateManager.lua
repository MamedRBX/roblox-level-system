
--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules 
local Template = require(ReplicatedStorage.Shared.PlayerData.template)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)


--//Remotes 
local UpdateUiRemote  = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder"):WaitForChild("UpdateUi") :: RemoteEvent

local isDataLoaded = false
local PlayerData: Template.PlayerData

--// Fusion Variables 
local Value = Fusion.Value

--//Functions
local function LoadData()
	if isDataLoaded then return end 
	local GetAllData = ReplicatedStorage.Shared.Remotes:WaitForChild("GetAllData") :: RemoteFunction
	while not PlayerData do
		PlayerData = GetAllData:InvokeServer()
		task.wait(1)

	end
	isDataLoaded = true	
end

LoadData() --load all the data


local StateManager = {} --Start of the Module Script


StateManager.Masteries = {} --List of Masteries and their values

--// Loading Fusion Values
function StateManager.InitReactiveValues()
	StateManager.Level = Value(PlayerData.Level)
	StateManager.Xp = Value(PlayerData.Xp)
	StateManager.SkillPoints = Value(PlayerData.SkillPoints)
	StateManager.SkillTreePoints = Value(PlayerData.SkillTreePoints)

	-- Fill the Masteries table
	for skillName, level in pairs(PlayerData.Skills) do
		StateManager.Masteries[skillName] = Value(level)
	end
end

function StateManager.GetData(): Template.PlayerData
	while not isDataLoaded do
		task.wait(0.5)
		print()
	end
	return PlayerData
end

print(PlayerData.SkillPoints)
--// Recevie Remotes
UpdateUiRemote.OnClientEvent:Connect(function(key, payload)
	if not key or not payload then
		warn("[StateManager]:Missing key or payload")
		return
	end

	if key == "Update" then
		for stat, value in pairs(payload) do
			if StateManager[stat] then
				--We send a signal to the client for the pop up Xp
				if stat == "Xp" then 
					if StateManager.Xp:get() < value then
						Signals.XpPopUp:Fire(StateManager.Xp:get(), value)
					end
				elseif stat == "Level" then
					if StateManager.Level:get() < value then
						Signals.LevelPopUp:Fire()
					end
				end
				StateManager[stat]:set(value)
			end
		end
	else
		warn("[StateManager]: Key is not recognized")
	end
end)

return StateManager
