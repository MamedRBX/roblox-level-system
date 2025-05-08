--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)

local QueueSystem = {}

QueueSystem._queue = {}
QueueSystem._processing = false

--// Register actions
local ActionHandlers = {
	XpChange = function(player:Player, amount:number)
		
		Signals.XPChanged:Fire(player, amount)	
	end,
	SpendMasterySP = function(player:Player , amount:number)
		Signals.SpendMasterySP:Fire(player, amount)
		
	end
}

--// Adding an event into the Queue System 
function QueueSystem:Add(actionName: string, player: Player, ...)
	local handler = ActionHandlers[actionName]
	if not handler then return warn("Unknown action:", actionName) end

	table.insert(self._queue, {
		handler = handler,
		player = player,
		args = { ... }
	})
	
	self:_tryProcess()
end

--// Processing the events that are inside the Queue 
function QueueSystem:_tryProcess()
	if self._processing then return end
	self._processing = true

	task.spawn(function()
		while #self._queue > 0 do
			local job = table.remove(self._queue, 1)
			job.handler(job.player, unpack(job.args))
			task.wait() 
		end
		self._processing = false
	end)
end

--// Init the module script
function QueueSystem:Init()
	
end


return QueueSystem
