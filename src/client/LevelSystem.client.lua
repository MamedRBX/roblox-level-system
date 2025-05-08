--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


--// Modules
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)
local Tweens = require(script.Parent.Tweens)
local Signals = require(ReplicatedStorage.Shared.Signals.LevelSystemSignals)

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
        return StateManager.Xp:get().." / "..LevelSystemConfig.GetXpForLevel(StateManager.Level:get()) .." XP"
        
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


--//Button actions
OpenButton.MouseButton1Up:Connect(function()
    MasterySP.Visible = not MasterySP.Visible
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
