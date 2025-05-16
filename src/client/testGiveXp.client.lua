--// Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

--//Refs
local player = Players.LocalPlayer

--//Modules
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)


--// Remotes
local RemoteFolder = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder")

local GiveXP = RemoteFolder:WaitForChild("XpChange") :: RemoteEvent
local ClearAllStats = RemoteFolder:WaitForChild("ClearAllStats") :: RemoteEvent

-- task.wait(5)



-- while true do
--     if LevelSystemConfig.LevelCap(StateManager.Level:get()) then
--         GiveXP:FireServer(300)
--     end
    
--     task.wait(1)
-- end


--// Button Actions
local Button = player.PlayerGui.LevelingSystem.TextButton
Button.MouseButton1Up:Connect(function()
    ClearAllStats:FireServer()
end)
