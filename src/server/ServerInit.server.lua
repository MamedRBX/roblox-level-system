--// Services 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--// Folders 
local LevelSystem = ServerScriptService.Server.LevelSystem
local MicroServices = LevelSystem.MicroServices

--// Modules [LevelSystem]
local QueueSystem = require(LevelSystem.QueueSystem)
local LevelManager = require(LevelSystem.LevelManager)
local Validation = require(LevelSystem.Validation)

--// Init Modules [LevelSystem]
LevelManager:Init()
QueueSystem:Init()
Validation:Init()

--// Auto-init MicroServices (no hardcoded requires)
for _, moduleScript in ipairs(MicroServices:GetChildren()) do
	if moduleScript:IsA("ModuleScript") then
		local success, service = pcall(require, moduleScript)
		if success and typeof(service.Init) == "function" then
			local ok, err = pcall(function()
				service:Init()
			end)
			if not ok then
				warn(`[{moduleScript.Name}] Init error: {err}`)
			end
		else
			warn(`[{moduleScript.Name}] is missing Init or failed to load`)
		end
	end
end
