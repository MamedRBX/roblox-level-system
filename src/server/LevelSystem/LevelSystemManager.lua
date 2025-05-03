--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local QueueSystem = require(script.Parent.QueueSystem)


--// Start of the Module
local LevelManager = {}


--// Behaviour and Event handling
local SignalHandlers = {

	AddItemEvent = function(self, player, ...)
		if not ... then return print("No TemplateId was passed down") end
		local templateId = ...
		QueueSystem:Add("AddItem", player, templateId)
 
	end,
}

--// Giving the received Event a behaviour
function LevelManager:FireSignals(player: Player, event: string, ...)
	local handler = SignalHandlers[event]
	if handler then 
		handler(self, player, ...)
	else
		warn("InventorySystem: No logic defined for event '" .. tostring(event) .. "'")
	end
end

--// Receving Events 



--// Init the Module
function LevelManager:Init()
end

return LevelManager