
--// Services 
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules 
local Template = require(ReplicatedStorage.Shared.PlayerData.template)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local SkillTreeData = require(ReplicatedStorage.Shared.Config.SkillTreeData)

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
StateManager.SkillTreeSkills = {} --List of the skills from the skilltree that the player has leveled or unlocked


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

	-- Fill the SkillTreeSkills table with saved values (if any)
	for skillName, level in pairs(PlayerData.SkillTreeSkills) do 
		StateManager.SkillTreeSkills[skillName] = Value(level)
	end

	-- Ensure all skills have reactive state, even if not yet unlocked
	for skillName, skillData in pairs(SkillTreeData) do
		if typeof(skillData) ~= "table" then continue end
		-- Only add if not already added from PlayerData
		if not StateManager.SkillTreeSkills[skillName] then
			StateManager.SkillTreeSkills[skillName] = Value(0)
		end
	end

	-- More values for other actions
	StateManager.SelectedSpendAmount = Value(1) 
	StateManager.CustomSpendText = Value("")
end


function StateManager.GetData(): Template.PlayerData
	while not isDataLoaded do
		task.wait(0.5)
		print()
	end
	return PlayerData
end

--// Recevie Remotes
UpdateUiRemote.OnClientEvent:Connect(function(key, payload)
	
	if not key or not payload then
		warn("[StateManager]:Missing key or payload")
		return
	end
	
	if key == "Update" then
		
		for stat, value in pairs(payload) do --We go throught the updated Data from the server
			print(payload)
			if stat == "Xp" then 
				if StateManager.Xp:get() < value then --quick validation
					Signals.XpPopUp:Fire(StateManager.Xp:get(), value)--just for a xp popup frame
				end
			elseif stat == "Level" then
				if StateManager.Level:get() < value then --quick validation
					Signals.LevelPopUp:Fire() --just for a Level popup frame 
				end
			elseif stat == "Skills" then --When the server updates a Skill , then it sends a table of all skills with their values
				for skill, skillvalue in pairs(value) do
					local mastery = StateManager.Masteries[skill]
					if mastery then
						mastery:set(skillvalue)
					end
					
				end
				return 
			
			elseif stat == "SkillTreeSkills" then 
				for skill, skillvalue in value do 
					local Skill = StateManager.SkillTreeSkills[skill]

					if not Skill then
						-- create a new state if it doesn't exist
						Skill = Value(skillvalue)
						StateManager.SkillTreeSkills[skill] = Skill
						
					else
						Skill:set(skillvalue)
					end
				end
				print(StateManager.SkillTreeSkills)
				return
			end
			
			StateManager[stat]:set(value)
		
		end
	else
		warn("[StateManager]: Key is not recognized")
	end
end)

return StateManager
