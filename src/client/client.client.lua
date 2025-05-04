--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// RemotesFolder 
local Remote = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder")

local XpChange = Remote:WaitForChild("XpChange") :: RemoteEvent

local XpAmount = 10
task.wait(2 )
while true do
    task.wait(0.8)
    XpChange:FireServer(XpAmount) 
end



