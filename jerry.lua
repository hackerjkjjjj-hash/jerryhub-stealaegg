--// JERRY v1.0 - UI + Fixed Visible Toggle Button + Instant Prompt
--// Main Logo: 74724530538319[span_0](start_span)[span_0](end_span)
--// Button Logo: 131681030058686[span_1](start_span)[span_1](end_span)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JERRY_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

---------------------------------------------------------
-- Floating Toggle Button (កែសម្រួលឱ្យមានពណ៌ច្បាស់ ងាយស្រួលឃើញ)
---------------------------------------------------------
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- ដាក់ពណ៌ផ្ទៃខាងក្រោយឱ្យងាយឃើញ
OpenButton.BackgroundTransparency = 0.2
OpenButton.Image = "rbxassetid://131681030058686" --[span_2](start_span)[span_2](end_span)
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.ScaleType = Enum.ScaleType.Fit
OpenButton.ZIndex = 999 -- ធានាថានៅលើគេបង្អស់
OpenButton.Parent = ScreenGui

local openCorner = Instance.new("UICorner", OpenButton)
openCorner.CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", OpenButton)
openStroke.Color = Color3.fromRGB(95, 35, 180)
openStroke.Thickness = 2

---------------------------------------------------------
-- Main Frame
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 390)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.ZIndex = 100
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(95, 35, 180)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- ចុចលើប៊ូតុងអណ្តែតដើម្បី បើក/បិទ Main Frame
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 101
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

--// Main Frame Logo
local MainLogo = Instance.new("ImageLabel")
MainLogo.Name = "MainLogo"
MainLogo.Size = UDim2.new(0, 45, 0, 45)
MainLogo.Position = UDim2.new(0, 12, 0, 10)
MainLogo.BackgroundTransparency = 1
MainLogo.Image = "rbxassetid://74724530538319" --[span_3](start_span)[span_3](end_span)
MainLogo.ScaleType = Enum.ScaleType.Fit
MainLogo.ZIndex = 102
MainLogo.Parent = TopBar

--// Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 30)
Title.Position = UDim2.new(0, 68, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "JERRY v1.0"
Title.TextColor3 = Color3.fromRGB(245,245,255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 102
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 250, 0, 20)
Subtitle.Position = UDim2.new(0, 69, 0, 36)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Smart Steal & Instant Prompt"
Subtitle.TextColor3 = Color3.fromRGB(145,145,160)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 102
Subtitle.Parent = TopBar

--// Close Button (លាក់ MainFrame)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 42, 0, 42)
Close.Position = UDim2.new(1, -54, 0, 11)
Close.BackgroundColor3 = Color3.fromRGB(220, 45, 60)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 17
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.ZIndex = 102
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, -65)
Sidebar.Position = UDim2.new(0, 0, 0, 65)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 101
Sidebar.Parent = MainFrame

--// Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -155, 1, -65)
Content.Position = UDim2.new(0, 155, 0, 65)
Content.BackgroundTransparency = 1
Content.ZIndex = 101
Content.Parent = MainFrame

--// Page function
local function CreatePage()
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ZIndex = 102
    Page.Parent = Content
    return Page
end

local StealPage = CreatePage()
local InfoPage = CreatePage()

StealPage.Visible = true

--// Button Generator
local function CreatePageButton(name, text, y)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -20, 0, 52)
    Button.Position = UDim2.new(0, 10, 0, y)
    Button.BackgroundColor3 = Color3.fromRGB(25, 26, 36)
    Button.Text = ""
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.ZIndex = 102
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    -- Button Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "ButtonLogo"
    Logo.Size = UDim2.new(0, 27, 0, 27)
    Logo.Position = UDim2.new(0, 13, 0.5, -13)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://131681030058686" --[span_4](start_span)[span_4](end_span)
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.ZIndex = 103
    Logo.Parent = Button

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -52, 1, 0)
    Text.Position = UDim2.new(0, 48, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = text
    Text.TextColor3 = Color3.fromRGB(235,235,245)
    Text.TextSize = 15
    Text.Font = Enum.Font.GothamBold
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.ZIndex = 103
    Text.Parent = Button

    return Button
end

local StealButton = CreatePageButton("StealButton", "Steal", 20)
local InfoButton = CreatePageButton("InfoButton", "Info", 82)

--// STEAL PAGE
local StealTitle = Instance.new("TextLabel")
StealTitle.Size = UDim2.new(1, -40, 0, 40)
StealTitle.Position = UDim2.new(0, 20, 0, 20)
StealTitle.BackgroundTransparency = 1
StealTitle.Text = "Steal Settings"
StealTitle.TextColor3 = Color3.fromRGB(245,245,255)
StealTitle.TextSize = 21
StealTitle.Font = Enum.Font.GothamBold
StealTitle.TextXAlignment = Enum.TextXAlignment.Left
StealTitle.ZIndex = 103
StealTitle.Parent = StealPage

local StealStatus = Instance.new("TextLabel")
StealStatus.Size = UDim2.new(1, -40, 0, 30)
StealStatus.Position = UDim2.new(0, 20, 0, 62)
StealStatus.BackgroundTransparency = 1
StealStatus.Text = "Configure your prompt settings below"
StealStatus.TextColor3 = Color3.fromRGB(145,145,160)
StealStatus.TextSize = 13
StealStatus.Font = Enum.Font.Gotham
StealStatus.TextXAlignment = Enum.TextXAlignment.Left
StealStatus.ZIndex = 103
StealStatus.Parent = StealPage

--// Instant Prompt Card & Toggle
local PromptCard = Instance.new("Frame")
PromptCard.Size = UDim2.new(1, -40, 0, 60)
PromptCard.Position = UDim2.new(0, 20, 0, 105)
PromptCard.BackgroundColor3 = Color3.fromRGB(18,19,28)
PromptCard.BorderSizePixel = 0
PromptCard.ZIndex = 103
PromptCard.Parent = StealPage

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 8)
CardCorner.Parent = PromptCard

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(45,45,65)
CardStroke.Thickness = 1
CardStroke.Parent = PromptCard

local PromptText = Instance.new("TextLabel")
PromptText.Size = UDim2.new(1, -100, 1, 0)
PromptText.Position = UDim2.new(0, 15, 0, 0)
PromptText.BackgroundTransparency = 1
PromptText.Text = "Instant Prompt (0.0s)"
PromptText.TextColor3 = Color3.fromRGB(210,210,225)
PromptText.TextSize = 14
PromptText.Font = Enum.Font.GothamBold
PromptText.TextXAlignment = Enum.TextXAlignment.Left
PromptText.ZIndex = 104
PromptText.Parent = PromptCard

local PromptToggle = Instance.new("TextButton")
PromptToggle.Size = UDim2.new(0, 48, 0, 26)
PromptToggle.Position = UDim2.new(1, -65, 0.5, -13)
PromptToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
PromptToggle.Text = ""
PromptToggle.AutoButtonColor = false
PromptToggle.ZIndex = 104
PromptToggle.Parent = PromptCard

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = PromptToggle

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
ToggleCircle.BorderSizePixel = 0
ToggleCircle.ZIndex = 105
ToggleCircle.Parent = PromptToggle

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleCircle

--// Instant Prompt Logic
local PromptEnabled = false
local originalHoldDurations = {}
local promptConnection = nil

PromptToggle.MouseButton1Click:Connect(function()
    PromptEnabled = not PromptEnabled
    
    local targetColor = PromptEnabled and Color3.fromRGB(95, 35, 180) or Color3.fromRGB(45, 45, 60)
    local targetPos = PromptEnabled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    
    PromptToggle.BackgroundColor3 = targetColor
    ToggleCircle.Position = targetPos
    
    if PromptEnabled then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                if not originalHoldDurations[v] then
                    originalHoldDurations[v] = v.HoldDuration
                end
                v.HoldDuration = 0
            end
        end
        
        promptConnection = Workspace.DescendantAdded:Connect(function(v)
            if PromptEnabled and v:IsA("ProximityPrompt") then
                if not originalHoldDurations[v] then
                    originalHoldDurations[v] = v.HoldDuration
                end
                v.HoldDuration = 0
            end
        end)
    else
        if promptConnection then
            promptConnection:Disconnect()
            promptConnection = nil
        end
        for v, orig in pairs(originalHoldDurations) do
            if v and v.Parent then v.HoldDuration = orig end
        end
    end
end)

--// INFO PAGE
local InfoTitle = Instance.new("TextLabel")
InfoTitle.Size = UDim2.new(1, -40, 0, 40)
InfoTitle.Position = UDim2.new(0, 20, 0, 20)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "Info"
InfoTitle.TextColor3 = Color3.fromRGB(245,245,255)
InfoTitle.TextSize = 21
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.ZIndex = 103
InfoTitle.Parent = InfoPage

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 90, 0, 90)
Avatar.Position = UDim2.new(0, 20, 0, 75)
Avatar.BackgroundColor3 = Color3.fromRGB(25,25,35)
Avatar.BorderSizePixel = 0
Avatar.ZIndex = 103
Avatar.Parent = InfoPage

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 10)
AvatarCorner.Parent = Avatar

local AvatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId="
    .. Player.UserId
    .. "&width=150&height=150&format=png"

Avatar.Image = AvatarUrl

-- User information
local UserInfo = Instance.new("TextLabel")
UserInfo.Size = UDim2.new(1, -140, 0, 110)
UserInfo.Position = UDim2.new(0, 130, 0, 70)
UserInfo.BackgroundTransparency = 1
UserInfo.Text =
    "Username: " .. Player.Name ..
    "\nDisplay Name: " .. Player.DisplayName ..
    "\nUser ID: " .. tostring(Player.UserId)
UserInfo.TextColor3 = Color3.fromRGB(230,230,240)
UserInfo.TextSize = 14
UserInfo.Font = Enum.Font.Gotham
UserInfo.TextXAlignment = Enum.TextXAlignment.Left
UserInfo.TextYAlignment = Enum.TextYAlignment.Top
UserInfo.ZIndex = 103
UserInfo.Parent = InfoPage

--// Page switching
local function ShowPage(page)
    StealPage.Visible = false
    InfoPage.Visible = false
    page.Visible = true
end

StealButton.MouseButton1Click:Connect(function()
    ShowPage(StealPage)
end)

InfoButton.MouseButton1Click:Connect(function()
    ShowPage(InfoPage)
end)

--// DRAG SYSTEM
local dragging = false
local dragStart
local startPosition

local function UpdateDrag(input)
    local delta = input.Position - dragStart

    MainFrame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        if dragging then
            UpdateDrag(input)
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        UpdateDrag(input)
    end
end)

print("JERRY v1.0 Loaded Successfully")
