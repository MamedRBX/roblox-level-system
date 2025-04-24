--Modules
local ProfileManager = require(game.ServerScriptService.PlayerData.ProfileManager)


local AUTO_SAVE_INTERVAL = 300

--Load the Module
ProfileManager.Init()

--LoadProfile when the Player joins
game.Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		ProfileManager.LoadPlayer(player)
	end)
end)

--Save Profile when leaving
game.Players.PlayerRemoving:Connect(function(player)
	task.spawn(function()
		local profile = ProfileManager.profiles[player]
		if profile then
			ProfileManager.Save(player)
			profile:Release()
		end
	end)
end)


--Make a AutoSave 
task.spawn(function()
	while task.wait(AUTO_SAVE_INTERVAL) do
		for _, player in pairs(game.Players:GetPlayers()) do
			ProfileManager.Save(player)

		end
	end
end)
