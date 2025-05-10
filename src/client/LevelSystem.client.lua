--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")


--// Modules
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local Tweens = require(StarterPlayer.StarterPlayerScripts.Client.Tweens)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local FormatNumber = require(ReplicatedStorage.Shared.Libs.FormatNumberShort)
local FusionLevelUi = require(StarterPlayer.StarterPlayerScripts.Client.FusionLevelUi)


StateManager.InitReactiveValues() --init StateManager with Fusion variables

--// [Refs]

--// Main Refs
local player  = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local LevelingSystem = PlayerGui:WaitForChild("LevelingSystem")
local MainFrame = LevelingSystem.MainFrame
local MasterySP = LevelingSystem.MasterySP

--//MasterySP
local Holder = MasterySP.Holder

local Strength = Holder.Strength
local Wisdom = Holder.Wisdom
local Luck = Holder.Luck
local Stamina = Holder.Stamina


--// Fusion variables
local New = Fusion.New
local Computed = Fusion.Computed


--// Buttons
local infoButton = MasterySP.InfoButton
local closeButton = MasterySP.closeButton
local OpenButton = LevelingSystem.MasteryButton

--// Starter Values
local debounce = false


--// Fusion Uis [Level Display , Xp Display, ProgressBar]
local SmoothXp = Fusion.Spring(StateManager.Xp, 30, 1) --smooting out the numbers that Change per Xp gain

local XpCounter = New "TextLabel" {     --XP and XpReQ display
	Name = "XpCounter",
	Parent = LevelingSystem.MainFrame.Level,
	Position = UDim2.fromScale(1.087, 0.097),
	Size = UDim2.fromScale(4.02, 0.249),
	TextColor3 = Color3.fromRGB(118, 125, 171),
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	TextScaled = true,
	Font = Enum.Font.GothamBold,

	Text = Computed(function()
        
		local level = StateManager.Level:get()
		local requiredXp = LevelSystemConfig.GetXpForLevel(level)
        if not LevelSystemConfig.LevelCap(StateManager.Level:get()) then return FormatNumber(requiredXp).." / "..FormatNumber(requiredXp).." XP" end
		return FormatNumber(math.floor(SmoothXp:get())).." / "..FormatNumber(requiredXp).." XP"
	end)
}
local UiStroke = Instance.new("UIStroke", XpCounter) 
UiStroke.Color = Color3.fromRGB(67, 73, 104)
UiStroke.Thickness = 1.5



local LevelCounter = New "TextLabel"  {     --Level counter display 
    Name = "LevelConuter",
    Parent = LevelingSystem.MainFrame.Level,
    BackgroundTransparency = 1,
    TextScaled = true,
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(227, 227, 0),
    Position = UDim2.fromScale(0.299, 0.347),
    Size = UDim2.fromScale(0.395,0.299),

    Text = Computed(function()
        return StateManager.Level:get()       
    end)
}
local UiStrokeLevelCounter = Instance.new("UIStroke",LevelCounter)  
UiStrokeLevelCounter.Color = Color3.fromRGB(255, 255, 127)
UiStrokeLevelCounter.Thickness = 0.6



local XpBarFill = New "Frame" {     --Xp ProgressBar display  
    Name = "XpBar",
    Parent = MainFrame.XPDisplay.XPBarBackground,
    BorderSizePixel = 0,
    Position = UDim2.fromScale(0, 0),

    Size = Fusion.Spring(Computed(function()
        if not LevelSystemConfig.LevelCap(StateManager.Level:get()) then 
            
            return UDim2.fromScale(1, 1) 
        end
        local currentXp = StateManager.Xp:get()
        local maxXp = LevelSystemConfig.GetXpForLevel(StateManager.Level:get())
        local fillRatio = math.clamp(currentXp / maxXp, 0, 1)
        return UDim2.fromScale(fillRatio, 1)
    end), 15),
    BackgroundColor3 = Computed(function()
        if LevelSystemConfig.LevelCap(StateManager.Level:get()) then
            return Color3.fromRGB(0,255,0)
        else
            return Color3.fromRGB(227,227,0)
        end
    end)
}




--// Fusion Uis [Mastery Ui: SkillPointsCounter, SkillCounter , MileStones , SkillProgressBars]

local SkillPoints = New "TextLabel" {     --SkillPoints displayed 
    Name = "SkillPoints",
    Parent = MasterySP.ExtraStats,
    BackgroundTransparency = 1,
    TextScaled = true,
    Font = Enum.Font.Fondamento,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.495,0.115),
    Size = UDim2.fromScale(0.833,0.16),
    TextColor3 = Color3.fromRGB(255,255,255),

    Text = Computed(function()
        return "SkillPoints: "..StateManager.SkillPoints:get()
    end)
}


FusionLevelUi.CreateSkillCounterUi({ --handles SkillCounter, Milestone display , skillprogressbar
    Strength,
    Wisdom,
    Luck,
    Stamina,
})




--//Button actions
OpenButton.MouseButton1Up:Connect(function()
	if debounce then return end
	debounce = true

	Tweens.tweenFrame(MasterySP)

	task.delay(1, function()
		debounce = false
	end)
end)

closeButton.MouseButton1Up:Connect(function()
    MasterySP.Visible = not MasterySP.Visible
end)

infoButton.MouseButton1Up:Connect(function()
    --show infos 
end)


--// Receving Signals
Signals.XpPopUp:Connect(function(old:number , new:number)
    Tweens.showXpGainPopup(new - old) --diplay the xp after getting xp
end)

Signals.LevelPopUp:Connect(function()
    Tweens.showLevelGainPopup() --displaying the Level after levelup
end)
