--// Services 
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Tween = {}

--// Popup Xp Label 
function Tween.showXpGainPopup(amount:number)
    local popup = Instance.new("TextLabel")
    popup.Text = "+" .. amount .. " XP"
    popup.TextColor3 = Color3.fromRGB(0, 255, 0)
    popup.TextStrokeTransparency = 0
    popup.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    popup.Font = Enum.Font.GothamBold
    popup.TextScaled = true
    popup.BackgroundTransparency = 1
    popup.Size = UDim2.fromScale(0.15, 0.065)
    popup.Position = UDim2.fromScale(0.32, 0.5)
    popup.Parent = Players.LocalPlayer.PlayerGui.LevelingSystem

    local goal = {
        Position = UDim2.fromScale(0.32, 0.3),
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }

    local tween = TweenService:Create(popup, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    tween:Play()
    tween.Completed:Connect(function()
        popup:Destroy()
    end)
end


--// Popup Level Label
function Tween.showLevelGainPopup()
    local popup = Instance.new("TextLabel")
    popup.Text = "LevelUp!"
    popup.TextColor3 = Color3.fromRGB(227, 227, 0)
    popup.TextStrokeTransparency = 0
    popup.TextStrokeColor3 = Color3.fromRGB(255, 255, 127)
    popup.Font = Enum.Font.GothamBold
    popup.TextScaled = true
    popup.BackgroundTransparency = 1
    popup.Size = UDim2.fromScale(0.15, 0.065)
    popup.Position = UDim2.fromScale(0.5, 0.5)
    popup.Parent = Players.LocalPlayer.PlayerGui.LevelingSystem

    local goal = {
        Position = UDim2.fromScale(0.5, 0.3),
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }

    local tween = TweenService:Create(popup, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    tween:Play()
    tween.Completed:Connect(function()
        popup:Destroy()
    end)
end

return Tween