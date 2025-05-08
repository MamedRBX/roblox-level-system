--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Modules
local ProfileManager = require(ServerScriptService.Server.PlayerData.ProfileManager)
local Singals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)

--// Folders
local LevelSystemFolder = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder") :: Folder


--//Remotes
local UpdateUi = LevelSystemFolder:WaitForChild("UpdateUi") :: RemoteEvent


local MasterySP = {}

--// Functions 
function MasterySP.OnLevelUp(player)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[MasterySP]: Missing Profile") end

    profile.Data.SkillPoints += 1 
    
end

function MasterySP.OnSPSpend(player: Player, amount:number, SkillName:string)
    local profile = ProfileManager.profiles[player]
    if not profile then return warn("[MasterySP]: Missing Profile") end

    if amount >= profile.Data.SkillPoints then --checking if player has enough points for what he wants to skill x amount of times
       
        if not profile.Data.Skills[SkillName] then return warn("[Mastery]: Skill Missing"..SkillName) end

        --make possible cap check here , 20 , 50 maybe 100 skillpoints as a cap
        
        local amountToAdd , b  =  LevelSystemConfig.SkillCap(amount, profile.Data.Skills[SkillName]) 
        profile.Data.Skills[SkillName] += amount
        profile.Data.SkillPoints -= amount

        --Update Ui
        UpdateUi:FireClient(player , "Update", {
            SkillPoints = profile.Data.SkillPoints,
            Skills = profile.Data.Skills
        })

    else
        print("the player does not have enough skills to upgrade this skill x time")
    end


end

--// Receving Signals
Singals.LevelUp:Connect(function(player:Player)
    MasterySP.OnLevelUp(player)
end)

Singals.SpendMasterySP:Connect(function(player:Player, amount:number, SkillName:string)
    MasterySP.OnSPSpend(player, amount, SkillName)
end)



--// Init Module
function  MasterySP.Init()
    
end

return MasterySP