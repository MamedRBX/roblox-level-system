--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StarterPack = game:GetService("StarterPack")


--// Modules
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local Tweens = require(script.Parent.Tweens)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)
local FormatNumber = require(ReplicatedStorage.Shared.Libs.FormatNumberShort)

--// Folders 



--//init StateManager with Fusion variables
StateManager.InitReactiveValues()


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


--//XP Display 
local XpBarBackground = MainFrame.XPDisplay.XPBarBackground


--// Fusion variables
local New = Fusion.New
local Computed = Fusion.Computed
local Value = Fusion.Value

--// Buttons
local infoButton = MasterySP.InfoButton
local closeButton = MasterySP.closeButton
local OpenButton = LevelingSystem.MasteryButton

--// Starter Values
local debounce = false

--// TextLabel for the Xp Counter
local XpCounter = New "TextLabel" {  --Xp Counter Label that displayes the current Xp and the Xp requirement for the next Level 

    Name = "XpCounter",
    Parent = LevelingSystem.MainFrame.Level,
    Position = UDim2.fromScale(1.087, 0.097),
    Size = UDim2.fromScale(4.02, 0.249),
    --TextStrokeColor3 =  Color3.fromRGB(67, 73, 104),
    TextColor3 = Color3.fromRGB(118, 125, 171),
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    TextScaled = true,
    --TextStrokeTransparency = 0,
    Font = Enum.Font.GothamBold,

    Text = Computed(function()
        local number = LevelSystemConfig.GetXpForLevel(StateManager.Level:get())
        return StateManager.Xp:get().." / "..FormatNumber(number).." XP"
        
    end)


}

local UiStroke = Instance.new("UIStroke", XpCounter) 
UiStroke.Color = Color3.fromRGB(67, 73, 104)
UiStroke.Thickness = 1.5


--// TextLabel for the Level Counter
local LevelCounter = New "TextLabel"  {
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


--// Frame for the XPBar 
local XpBarFill = New "Frame" {
    Name = "XpBar",
    Parent = XpBarBackground,
    BackgroundColor3 = Color3.fromRGB(0,255,0),
    BorderSizePixel = 0,
    Position = UDim2.fromScale(0, 0),
    Size = Fusion.Spring(Computed(function()
        local currentXp = StateManager.Xp:get()
        local maxXp = LevelSystemConfig.GetXpForLevel(StateManager.Level:get())
        local fillRatio = math.clamp(currentXp / maxXp, 0, 1)
        return UDim2.fromScale(fillRatio, 1)
    end), 15) 
}


--// Mastery Gui

local SkillPoints = New "TextLabel" {
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

local StrengthLevelCounter = New "TextLabel" {
    Name = "StrengthLevelCounter",
    Parent = Strength,
    BackgroundTransparency = 1,
    TextScaled = true,
    Font = Enum.Font.GothamBold,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.62, 0.424),
    Size = UDim2.fromScale(0.118,0.336),
    TextColor3 = Color3.fromRGB(255,255,255),

    Text = Computed(function()
        return StateManager.Masteries["Strength"]:get().." / "..LevelSystemConfig.MileStoneCalc(StateManager.Masteries["Strength"]:get())
    end)


}

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
