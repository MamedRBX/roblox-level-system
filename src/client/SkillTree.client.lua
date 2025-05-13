--// Services 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Modules 
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local Janitor = require(ReplicatedStorage._Packages.Janitor) 
local SkillTreeData = require(ReplicatedStorage.Shared.Config.SkillTreeData)


--// Fusion
local Hydrate = Fusion.Hydrate	
local OnEvent = Fusion.OnEvent

--// Refs
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LevelingSystem = PlayerGui:WaitForChild("LevelingSystem")
local SkillTreeFrame = LevelingSystem.SkillTree

local ViewFrame = SkillTreeFrame.ViewFrame
local Canvas = ViewFrame.Canvis

local SkillFolder = Canvas.SkillFrames

--// Buttons
local closeButton = SkillTreeFrame.closeButton
local openSkillTree = LevelingSystem.SkillTreeButton

--// Zoom state
local originalScaleX = Canvas.Size.X.Scale
local originalScaleY = Canvas.Size.Y.Scale
local zoomScale = 1
local minZoom = 0.5
local maxZoom = 2
local zoomStep = 0.1

--// Drag state
local dragging = false
local dragStart
local startPos

--// Clamp config
local padding = 64

--// Reusable janitor
local janitor = Janitor.new()

local function clampCanvasPosition()
	local viewSize = ViewFrame.AbsoluteSize
	local canvasSize = Canvas.AbsoluteSize

	local currentPos = Canvas.Position
	local newX = currentPos.X.Offset
	local newY = currentPos.Y.Offset

	local minX = -(canvasSize.X / 2 - viewSize.X / 2) + padding
	local maxX = (canvasSize.X / 2 - viewSize.X / 2) - padding
	local minY = -(canvasSize.Y / 2 - viewSize.Y / 2) + padding
	local maxY = (canvasSize.Y / 2 - viewSize.Y / 2) - padding

	local clampedX = math.clamp(newX, minX, maxX)
	local clampedY = math.clamp(newY, minY, maxY)

	Canvas.Position = UDim2.new(0.5, clampedX, 0.5, clampedY)
end

--// Hydrate & Connect logic
local function InitSkillTree()
	janitor = Janitor.new()
	SkillTreeFrame.Visible = true

	-- zoom + input hydration
	Hydrate(Canvas) {
		[OnEvent "InputBegan"] = function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = UserInputService:GetMouseLocation()
				startPos = Canvas.Position
			end
		end,

		[OnEvent "InputEnded"] = function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end,

		[OnEvent "MouseWheelForward"] = function()
			zoomScale = math.clamp(zoomScale + zoomStep, minZoom, maxZoom)
			Canvas.Size = UDim2.fromScale(originalScaleX * zoomScale, originalScaleY * zoomScale)
			clampCanvasPosition()
		end,

		[OnEvent "MouseWheelBackward"] = function()
			zoomScale = math.clamp(zoomScale - zoomStep, minZoom, maxZoom)
			Canvas.Size = UDim2.fromScale(originalScaleX * zoomScale, originalScaleY * zoomScale)
			clampCanvasPosition()
		end,
	}

	-- drag + clamp logic
	janitor:Add(RunService.RenderStepped:Connect(function()
		if not dragging then return end

		local mouse = UserInputService:GetMouseLocation()
		local delta = mouse - dragStart

		local viewSize = ViewFrame.AbsoluteSize
		local canvasSize = Canvas.AbsoluteSize

		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y

		local minX = -(canvasSize.X / 2 - viewSize.X / 2) + padding
		local maxX = (canvasSize.X / 2 - viewSize.X / 2) - padding
		local minY = -(canvasSize.Y / 2 - viewSize.Y / 2) + padding
		local maxY = (canvasSize.Y / 2 - viewSize.Y / 2) - padding

		local clampedX = math.clamp(newX, minX, maxX)
		local clampedY = math.clamp(newY, minY, maxY)

		Canvas.Position = UDim2.new(0.5, clampedX, 0.5, clampedY)
	end), "Disconnect")
end

local function CleanupSkillTree()
	janitor:Destroy()
	SkillTreeFrame.Visible = false
end



--//Creating the SkillButtons
for Skill , info in SkillTreeData do 
	--search for the right folder

	local SkillData = SkillTreeData[Skill]
	print(SkillData.SkillType)
	local Frame: Frame = SkillFolder:FindFirstChild(SkillData.SkillType):FindFirstChild(SkillData.Name)
	if not Frame then return warn("[SkillTreeClient]: Missing Frame for Skill") end

	--create button , 


	--create a not skilled imagelabel 
	--create another image for the icon in the unskilled fase
	--and another one for the skilled fase
	--if the player has enough points then let it be clickable
end


--// Button logic
closeButton.MouseButton1Up:Connect(CleanupSkillTree)

openSkillTree.MouseButton1Up:Connect(function()
	if SkillTreeFrame.Visible then
		CleanupSkillTree()
	else
		InitSkillTree()
	end
end)
