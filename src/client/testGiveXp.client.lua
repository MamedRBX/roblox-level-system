--// Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--//Refs
local player = Players.LocalPlayer

--//Modules
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)


--// Remotes
local GiveXP = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder"): WaitForChild("XpChange") :: RemoteEvent


task.wait(5)

while true do
    if LevelSystemConfig.LevelCap(StateManager.Level:get()) then
        GiveXP:FireServer(300)
    end
    
    task.wait(1)
end

