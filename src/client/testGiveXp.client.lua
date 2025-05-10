local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local GiveXP = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder"): WaitForChild("XpChange") :: RemoteEvent


task.wait(3)

while true do
    GiveXP:FireServer(50)
    task.wait(2)
end

