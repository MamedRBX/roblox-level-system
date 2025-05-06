--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Modules
local StateManager = require(ReplicatedStorage.Shared.Client.StateManager)
local Fusion = require(ReplicatedStorage._Packages.Fusion)
local LevelSystemConfig = require(ReplicatedStorage.Shared.Config.LevelSystemConfig)


--// Folders 
local LevelRemotes = ReplicatedStorage.Shared.Remotes:WaitForChild("LevelRemotesFolder")

--//init StateManager with Fusion variables
StateManager.InitReactiveValues()


--// Refs 

--// Main Refs
local player  = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local LevelingSystem = PlayerGui:WaitForChild("LevelingSystem")

local MainFrame = LevelingSystem.MainFrame

--// LevelLable
local XPCounter = MainFrame.Level.XpCounter
local LevelCounter = MainFrame.Level.LevelCounter


--//XP Display 
local XpBarBackground = MainFrame.XPDisplay.XPBarBackground
local XpBar = MainFrame.XPDisplay.XPBarBackground.XPBar

--// Fusion variables
local New = Fusion.New
local Computed = Fusion.Computed



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


