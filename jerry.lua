--[[
    JERRY v1.0
    Clean UI: Info + Steal
    Animation / Emote / Home / Player functions removed.
]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomUI"
ScreenGui.ResetOnSpawn = false

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

---------------------------------------------------------
-- Circular Floating Toggle Button
---------------------------------------------------------
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 15, 0.5, -25)
OpenButton.Image = "rbxassetid://135995313313068"
OpenButton.BackgroundTransparency = 1
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Parent = ScreenGui

local openCorner = Instance.new("UICorner", OpenButton)
openCorner.CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", OpenButton)
openStroke.Color = Color3.fromRGB(150, 0, 255)
openStroke.Thickness = 2

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

---------------------------------------------------------
-- Top Header Logo, Title & Close Button
---------------------------------------------------------
local MainLogo = Instance.new("ImageLabel")
MainLogo.Name = "MainLogo"
MainLogo.Size = UDim2.new(0, 35, 0, 35)
MainLogo.Position = UDim2.new(0, 10, 0, 8)
MainLogo.Image = "rbxassetid://133870737244711"
MainLogo.BackgroundTransparency = 1
MainLogo.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 35)
Title.Position = UDim2.new(0, 50, 0, 8)
Title.Text = "JERRY v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 10)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Sidebar Section
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Container for Pages
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -125, 1, -60)
PageContainer.Position = UDim2.new(0, 120, 0, 55)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- Page Instances
local InfoPage = Instance.new("Frame", PageContainer)
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = true

local StealPage = Instance.new("Frame", PageContainer)
StealPage.Size = UDim2.new(1, 0, 1, 0)
StealPage.BackgroundTransparency = 1
StealPage.Visible = false

local EmotePage = Instance.new("Frame", PageContainer)
EmotePage.Size = UDim2.new(1, 0, 1, 0)
EmotePage.BackgroundTransparency = 1

local AnimPage = Instance.new("Frame", PageContainer)
AnimPage.Size = UDim2.new(1, 0, 1, 0)
AnimPage.BackgroundTransparency = 1

local function hideAllPages()
    InfoPage.Visible = false
    StealPage.Visible = false
end

-- Tab Button Generator
local function createTabBtn(name, pos, page)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.Parent = Sidebar
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        hideAllPages()
        page.Visible = true
    end)
end

createTabBtn("Info", 10, InfoPage)
createTabBtn("Steal", 50, StealPage)

---------------------------------------------------------
-- PAGE: STEAL
-- Safe UI toggle only; does not activate or modify prompts.
---------------------------------------------------------

-- 0.0s ProximityPrompt setting (for prompts owned by this UI's game)
local PromptToggleFrame = Instance.new("Frame", StealPage)
PromptToggleFrame.Size = UDim2.new(1, -20, 0, 45)
PromptToggleFrame.Position = UDim2.new(0, 10, 0, 55)
PromptToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", PromptToggleFrame).CornerRadius = UDim.new(0, 6)

local PromptLabel = Instance.new("TextLabel", PromptToggleFrame)
PromptLabel.Size = UDim2.new(1, -70, 1, 0)
PromptLabel.Position = UDim2.new(0, 12, 0, 0)
PromptLabel.BackgroundTransparency = 1
PromptLabel.Text = "ProximityPrompt 0.0s"
PromptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PromptLabel.Font = Enum.Font.SourceSansBold
PromptLabel.TextSize = 15
PromptLabel.TextXAlignment = Enum.TextXAlignment.Left

local PromptToggle = Instance.new("TextButton", PromptToggleFrame)
PromptToggle.Size = UDim2.new(0, 45, 0, 24)
PromptToggle.Position = UDim2.new(1, -55, 0.5, -12)
PromptToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PromptToggle.Text = ""
Instance.new("UICorner", PromptToggle).CornerRadius = UDim.new(1, 0)

local PromptEnabled = false

PromptToggle.MouseButton1Click:Connect(function()
    PromptEnabled = not PromptEnabled
    PromptToggle.BackgroundColor3 = PromptEnabled
        and Color3.fromRGB(46, 204, 113)
        or Color3.fromRGB(70, 70, 70)
end)

local StealTitle = Instance.new("TextLabel", StealPage)
StealTitle.Size = UDim2.new(1, -20, 0, 35)
StealTitle.Position = UDim2.new(0, 10, 0, 10)
StealTitle.BackgroundTransparency = 1
StealTitle.Text = "Steal"
StealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StealTitle.Font = Enum.Font.SourceSansBold
StealTitle.TextSize = 20
StealTitle.TextXAlignment = Enum.TextXAlignment.Left

local PromptFrame = Instance.new("Frame", StealPage)
PromptFrame.Size = UDim2.new(1, -20, 0, 45)
PromptFrame.Position = UDim2.new(0, 10, 0, 55)
PromptFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", PromptFrame).CornerRadius = UDim.new(0, 6)

local PromptLabel = Instance.new("TextLabel", PromptFrame)
PromptLabel.Size = UDim2.new(1, -70, 1, 0)
PromptLabel.Position = UDim2.new(0, 12, 0, 0)
PromptLabel.BackgroundTransparency = 1
PromptLabel.Text = "ProximityPrompt"
PromptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PromptLabel.Font = Enum.Font.SourceSansBold
PromptLabel.TextSize = 15
PromptLabel.TextXAlignment = Enum.TextXAlignment.Left

local PromptToggle = Instance.new("TextButton", PromptFrame)
PromptToggle.Size = UDim2.new(0, 45, 0, 24)
PromptToggle.Position = UDim2.new(1, -55, 0.5, -12)
PromptToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PromptToggle.Text = ""
Instance.new("UICorner", PromptToggle).CornerRadius = UDim.new(1, 0)

local PromptEnabled = false

PromptToggle.MouseButton1Click:Connect(function()
    PromptEnabled = not PromptEnabled
    PromptToggle.BackgroundColor3 = PromptEnabled
        and Color3.fromRGB(46, 204, 113)
        or Color3.fromRGB(70, 70, 70)
end)

local PromptStatus = Instance.new("TextLabel", StealPage)
PromptStatus.Size = UDim2.new(1, -20, 0, 30)
PromptStatus.Position = UDim2.new(0, 10, 0, 110)
PromptStatus.BackgroundTransparency = 1
PromptStatus.Text = "Status: OFF"
PromptStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
PromptStatus.Font = Enum.Font.SourceSans
PromptStatus.TextSize = 14
PromptStatus.TextXAlignment = Enum.TextXAlignment.Left

PromptToggle.MouseButton1Click:Connect(function()
    PromptStatus.Text = PromptEnabled and "Status: ON" or "Status: OFF"
end)

---------------------------------------------------------
-- PAGE 3: INFO
---------------------------------------------------------
local MyAvatar = Instance.new("ImageLabel")
MyAvatar.Size = UDim2.new(0, 85, 0, 85)
MyAvatar.Position = UDim2.new(0, 0, 0, 10)
MyAvatar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MyAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
MyAvatar.Parent = InfoPage
Instance.new("UICorner", MyAvatar).CornerRadius = UDim.new(0, 8)

local MyInfoText = Instance.new("TextLabel")
MyInfoText.Size = UDim2.new(1, -95, 0, 85)
MyInfoText.Position = UDim2.new(0, 95, 0, 10)
MyInfoText.Text = "Username: " .. LocalPlayer.Name .. "\nNickname: " .. LocalPlayer.DisplayName .. "\nAccount ID: " .. LocalPlayer.UserId
MyInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
MyInfoText.TextXAlignment = Enum.TextXAlignment.Left
MyInfoText.TextYAlignment = Enum.TextYAlignment.Top
MyInfoText.BackgroundTransparency = 1
MyInfoText.Font = Enum.Font.SourceSans
MyInfoText.TextSize = 16
MyInfoText.Parent = InfoPage

---------------------------------------------------------
