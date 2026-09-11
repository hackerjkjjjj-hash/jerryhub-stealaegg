
--[[
    Jerry Hub - Animation Unchanged / Movement Safety Test
    NOTE:
    The Animation Pack section below is intentionally unchanged.
    This test version does NOT attempt to bypass any server anti-cheat.
    Movement-exploit features can be disabled by the game/server independently.
]]
local __JerryMovementSafetyTest = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomUI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

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
local HomePage = Instance.new("Frame", PageContainer)
HomePage.Size = UDim2.new(1, 0, 1, 0)
HomePage.BackgroundTransparency = 1
HomePage.Visible = false

local PlayerPage = Instance.new("Frame", PageContainer)
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false

local InfoPage = Instance.new("Frame", PageContainer)
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = false

local StealPage = Instance.new("Frame", PageContainer)
StealPage.Size = UDim2.new(1, 0, 1, 0)
StealPage.BackgroundTransparency = 1
StealPage.Visible = true

local EmotePage = Instance.new("Frame", PageContainer)
EmotePage.Size = UDim2.new(1, 0, 1, 0)
EmotePage.BackgroundTransparency = 1
EmotePage.Visible = false

local AnimPage = Instance.new("Frame", PageContainer)
AnimPage.Size = UDim2.new(1, 0, 1, 0)
AnimPage.BackgroundTransparency = 1
AnimPage.Visible = false

local function hideAllPages()
    HomePage.Visible = false
    PlayerPage.Visible = false
    InfoPage.Visible = false
    EmotePage.Visible = false
    AnimPage.Visible = false
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

createTabBtn("Steal", 10, StealPage)
createTabBtn("Info", 50, InfoPage)

---------------------------------------------------------
-- PAGE: STEAL (UI PLACEHOLDER)
---------------------------------------------------------
local StealTitle = Instance.new("TextLabel", StealPage)
StealTitle.Size = UDim2.new(1, -20, 0, 35)
StealTitle.Position = UDim2.new(0, 10, 0, 10)
StealTitle.BackgroundTransparency = 1
StealTitle.Text = "Steal"
StealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StealTitle.Font = Enum.Font.SourceSansBold
StealTitle.TextSize = 20
StealTitle.TextXAlignment = Enum.TextXAlignment.Left

local StealStatus = Instance.new("TextLabel", StealPage)
StealStatus.Size = UDim2.new(1, -20, 0, 70)
StealStatus.Position = UDim2.new(0, 10, 0, 55)
StealStatus.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
StealStatus.Text = "Steal Function: Coming Soon"
StealStatus.TextColor3 = Color3.fromRGB(190, 190, 190)
StealStatus.Font = Enum.Font.SourceSans
StealStatus.TextSize = 16
StealStatus.Parent = StealPage
Instance.new("UICorner", StealStatus).CornerRadius = UDim.new(0, 6)

---------------------------------------------------------
-- PAGE 1: HOME (HIDDEN / ORIGINAL FUNCTIONS KEPT)
---------------------------------------------------------
local function createToggleBtn(parent, text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, pos)
    btn.Text = text .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 15
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

-- 1. Noclip Logic
local noclipEnabled = false
local noclipConnection = nil

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name == "HumanoidRootPart" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Torso" or part.Name == "Head" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end

createToggleBtn(HomePage, "Noclip", 0, toggleNoclip)

-- 2. Fly Logic
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local flyBV, flyBG

local function disableFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.zero
    end
end

createToggleBtn(HomePage, "Fly", 45, function(state)
    flyEnabled = state
    
    if not flyEnabled then
        disableFly()
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hrp or not humanoid then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "FlyVelocity"
    flyBV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "FlyGyro"
    flyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not hrp or not hrp.Parent then
            disableFly()
            return
        end

        local cam = workspace.CurrentCamera
        local moveDir = humanoid.MoveDirection

        flyBG.CFrame = cam.CFrame

        if moveDir.Magnitude > 0 then
            local flyVector = (cam.CFrame.LookVector * moveDir.Z * -1) + (cam.CFrame.RightVector * moveDir.X)
            flyBV.Velocity = flyVector * flySpeed
        else
            flyBV.Velocity = Vector3.zero
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function()
    flyEnabled = false
    disableFly()
end)

-- 3. ESP Box + Line Logic
local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Container_" .. math.random(1000, 9999)
espFolder.Parent = ScreenGui

local function removePlayerESP(plr)
    if not espFolder then return end
    local container = espFolder:FindFirstChild(plr.Name)
    if container then
        container:Destroy()
    end
end

local function applyESP(plr)
    if not espEnabled or plr == LocalPlayer or not plr.Character then return end
    
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not myHRP then return end
    
    removePlayerESP(plr)

    local pContainer = Instance.new("Folder")
    pContainer.Name = plr.Name
    pContainer.Parent = espFolder

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESPBox"
    bb.Adornee = hrp
    bb.Size = UDim2.new(4, 0, 5.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = pContainer

    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(1, 0, 1, 0)
    boxFrame.BackgroundTransparency = 1
    boxFrame.Parent = bb

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 1.5
    stroke.Parent = boxFrame

    local myAttachment = myHRP:FindFirstChild("MyESPAttachment")
    if not myAttachment then
        myAttachment = Instance.new("Attachment")
        myAttachment.Name = "MyESPAttachment"
        myAttachment.Parent = myHRP
    end

    local targetAttachment = hrp:FindFirstChild("TargetESPAttachment")
    if not targetAttachment then
        targetAttachment = Instance.new("Attachment")
        targetAttachment.Name = "TargetESPAttachment"
        targetAttachment.Parent = hrp
    end

    local beam = Instance.new("Beam")
    beam.Name = "ESPLine"
    beam.Attachment0 = myAttachment
    beam.Attachment1 = targetAttachment
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    beam.Width0 = 0.05
    beam.Width1 = 0.05
    beam.FaceCamera = true
    beam.Parent = pContainer
end

local function updateAllESP()
    if not espFolder then return end
    espFolder:ClearAllChildren()
    if not espEnabled then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            applyESP(plr)
        end
    end
end

createToggleBtn(HomePage, "ESP Box Line", 90, function(state)
    espEnabled = state
    updateAllESP()
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if espEnabled then applyESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(removePlayerESP)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if espEnabled then applyESP(plr) end
        end)
    end
end

-- 4. Anti-AFK Logic
local VirtualUser = game:GetService("VirtualUser")
local antiAFKConnection = nil

createToggleBtn(HomePage, "Anti-AFK Infinity", 135, function(state)
    if state then
        antiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

-- 4. Spin 360° Logic
local spinEnabled = false
local spinConnection = nil

local function toggleSpin360(state)
    spinEnabled = state

    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end

    if spinEnabled then
        spinConnection = RunService.RenderStepped:Connect(function(dt)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(360) * dt, 0)
            end
        end)
    end
end

--// HOME PAGE
createToggleBtn(HomePage, "🔄 Spin 360°", 315, function(state)
    toggleSpin360(state)
end)
---------------------------------------------------------
-- PAGE 2: PLAYER
---------------------------------------------------------
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, 0, 1, 0)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.BorderSizePixel = 0
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.Parent = PlayerPage

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

local function refreshPlayerList()
    for _, item in pairs(PlayerScroll:GetChildren()) do
        if item:IsA("Frame") then
            item:Destroy()
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -10, 0, 50)
            Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Card.Parent = PlayerScroll
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

            local Avatar = Instance.new("ImageLabel")
            Avatar.Size = UDim2.new(0, 40, 0, 40)
            Avatar.Position = UDim2.new(0, 5, 0, 5)
            Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
            Avatar.BackgroundTransparency = 1
            Avatar.Parent = Card
            Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

            local InfoText = Instance.new("TextLabel")
            InfoText.Size = UDim2.new(1, -135, 1, 0)
            InfoText.Position = UDim2.new(0, 50, 0, 0)
            InfoText.Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")"
            InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
            InfoText.TextXAlignment = Enum.TextXAlignment.Left
            InfoText.BackgroundTransparency = 1
            InfoText.Font = Enum.Font.SourceSans
            InfoText.TextSize = 13
            InfoText.TextTruncate = Enum.TextTruncate.AtEnd
            InfoText.Parent = Card

            local GoTo = Instance.new("TextButton")
            GoTo.Size = UDim2.new(0, 70, 0, 30)
            GoTo.Position = UDim2.new(1, -75, 0, 10)
            GoTo.Text = "GoTo"
            GoTo.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            GoTo.TextColor3 = Color3.fromRGB(255, 255, 255)
            GoTo.Font = Enum.Font.SourceSansBold
            GoTo.TextSize = 14
            GoTo.Parent = Card
            Instance.new("UICorner", GoTo).CornerRadius = UDim.new(0, 6)

            GoTo.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

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
-- PAGE 4: EMOTES
---------------------------------------------------------
local currentTrack = nil

local function playEmote(animId)
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    
    if animator then
        if currentTrack then
            currentTrack:Stop()
        end
        
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. tostring(animId)
        
        currentTrack = animator:LoadAnimation(anim)
        currentTrack:Play()
    end
end

local StopEmoteBtn = Instance.new("TextButton")
StopEmoteBtn.Size = UDim2.new(1, 0, 0, 30)
StopEmoteBtn.Position = UDim2.new(0, 0, 0, 0)
StopEmoteBtn.Text = "Stop Emote"
StopEmoteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopEmoteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopEmoteBtn.Font = Enum.Font.SourceSansBold
StopEmoteBtn.TextSize = 14
StopEmoteBtn.Parent = EmotePage
Instance.new("UICorner", StopEmoteBtn).CornerRadius = UDim.new(0, 6)

StopEmoteBtn.MouseButton1Click:Connect(function()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
end)

local EmoteScroll = Instance.new("ScrollingFrame")
EmoteScroll.Size = UDim2.new(1, 0, 1, -38)
EmoteScroll.Position = UDim2.new(0, 0, 0, 38)
EmoteScroll.BackgroundTransparency = 1
EmoteScroll.BorderSizePixel = 0
EmoteScroll.ScrollBarThickness = 4
EmoteScroll.Parent = EmotePage

local UIGrid = Instance.new("UIGridLayout")
UIGrid.CellSize = UDim2.new(0, 105, 0, 35)
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UIGrid.Parent = EmoteScroll

UIGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    EmoteScroll.CanvasSize = UDim2.new(0, 0, 0, UIGrid.AbsoluteContentSize.Y + 10)
end)

local emoteList = {
    {Name = "Coming Soon", ID = 5915773155},
}

for _, data in ipairs(emoteList) do
    local btn = Instance.new("TextButton")
    btn.Text = data.Name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = EmoteScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        playEmote(data.ID)
    end)
end

---------------------------------------------------------
-- PAGE 5: ANIMATION PACKS (ANIMATE SCRIPT)
-- Uses Roblox's documented Zombie animation assets and the character's
-- existing Animate script. This avoids HumanoidDescription changes.

local localPlayer = game:GetService("Players").LocalPlayer

local AnimationPacks = {
    Zombie = {
        Idle     = "rbxassetid://616158929",
        Idle2    = "rbxassetid://616160636",
        Walk     = "rbxassetid://616168032",
        Run      = "rbxassetid://616163682",
        Jump     = "rbxassetid://616161997",
        Fall     = "rbxassetid://616157476",
        Climb    = "rbxassetid://616156119",
        Swim     = "rbxassetid://616165109",
        SwimIdle = "rbxassetid://616166655",
    },

    -- adidas Community Animation Pack
    -- adidas Community
    -- These are the actual animation asset IDs behind the catalog items.
    AdidasCommunity = {
        Idle     = "rbxassetid://122257458498464",
        Idle2    = "rbxassetid://122257458498464",
        Walk     = "rbxassetid://122150855457006",
        Run      = "rbxassetid://82598234841035",
        Jump     = "rbxassetid://75290611992385",
        Fall     = "rbxassetid://98600215928904",
        Climb    = "rbxassetid://88763136693023",
        Swim     = "rbxassetid://133308483266208",
        SwimIdle = "rbxassetid://133308483266208",
    }
}
local zombieAnimationEnabled = false
local respawnConnection = nil

local function setAnimationId(parent, childName, animationId)
    local obj = parent and parent:FindFirstChild(childName)
    if obj and obj:IsA("Animation") then
        obj.AnimationId = animationId
        return true
    end
    return false
end

local function stopCurrentAnimations(humanoid)
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0.08)
        end
    end
end

local function applyAnimationPack(character, pack)
    if not character or not character.Parent or not pack then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animate = character:FindFirstChild("Animate")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

    if not humanoid or not animator then
        return false
    end

    -- Stop/remove our previous controller.
    local oldFolder = character:FindFirstChild("__JerryAnimationPack")
    if oldFolder then
        oldFolder:Destroy()
    end

    -- Disable Roblox's default Animate while this pack is active.
    if animate then
        animate.Enabled = false
    end

    local folder = Instance.new("Folder")
    folder.Name = "__JerryAnimationPack"
    folder.Parent = character

    local tracks = {}
    local function load(name, id, priority, looped)
        if not id or id == "" then return end

        local anim = Instance.new("Animation")
        anim.Name = name
        anim.AnimationId = id
        anim.Parent = folder

        local ok, track = pcall(function()
            return animator:LoadAnimation(anim)
        end)

        if ok and track then
            track.Priority = priority
            track.Looped = looped
            tracks[name] = track
        end
    end

    load("Idle", pack.Idle, Enum.AnimationPriority.Idle, true)
    load("Walk", pack.Walk, Enum.AnimationPriority.Movement, true)
    load("Run", pack.Run or pack.Walk, Enum.AnimationPriority.Movement, true)
    load("Jump", pack.Jump, Enum.AnimationPriority.Movement, false)
    load("Fall", pack.Fall, Enum.AnimationPriority.Movement, true)
    load("Climb", pack.Climb, Enum.AnimationPriority.Movement, true)
    load("Swim", pack.Swim, Enum.AnimationPriority.Movement, true)
    load("SwimIdle", pack.SwimIdle or pack.Swim, Enum.AnimationPriority.Movement, true)

    local current
    local stateConnection
    local runningConnection

    local function stopAll(fade)
        for _, track in pairs(tracks) do
            if track.IsPlaying then
                track:Stop(fade or 0.12)
            end
        end
    end

    local function play(name, speed)
        local track = tracks[name]
        if not track then return end

        if current ~= track then
            stopAll(0.12)
            current = track
            track:Play(0.12, 1, speed or 1)
        elseif speed then
            track:AdjustSpeed(speed)
        end
    end

    local function update()
        local state = humanoid:GetState()
        local moving = humanoid.MoveDirection.Magnitude > 0.05
        local speed = humanoid.WalkSpeed

        if state == Enum.HumanoidStateType.Jumping then
            play("Jump", 1)
        elseif state == Enum.HumanoidStateType.Freefall then
            play("Fall", 1)
        elseif state == Enum.HumanoidStateType.Climbing then
            play("Climb", math.max(speed / 8, 0.5))
        elseif state == Enum.HumanoidStateType.Swimming then
            if moving then
                play("Swim", math.max(speed / 8, 0.5))
            else
                play("SwimIdle", 1)
            end
        elseif moving then
            -- adidas uses a distinct skate-style walk/run.
            if speed >= 14 and tracks.Run then
                play("Run", math.max(speed / 16, 0.5))
            else
                play("Walk", math.max(speed / 8, 0.5))
            end
        else
            play("Idle", 1)
        end
    end

    stateConnection = humanoid.StateChanged:Connect(function()
        task.defer(update)
    end)

    runningConnection = humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
        task.defer(update)
    end)

    -- Clean up automatically if the character is removed.
    local ancestryConnection
    ancestryConnection = character.AncestryChanged:Connect(function(_, parent)
        if parent then return end

        if animationControllerCleanup then
            pcall(animationControllerCleanup)
            animationControllerCleanup = nil
        end
    end)

    animationControllerCleanup = function()
        if stateConnection then
            stateConnection:Disconnect()
            stateConnection = nil
        end

        if runningConnection then
            runningConnection:Disconnect()
            runningConnection = nil
        end

        if ancestryConnection then
            ancestryConnection:Disconnect()
            ancestryConnection = nil
        end

        for _, track in pairs(tracks) do
            pcall(function()
                track:Stop(0.08)
                track:Destroy()
            end)
        end

        current = nil
    end

    update()
    return next(tracks) ~= nil
end

local activeAnimationPack = nil

local function applyZombieAnimation(character)
    activeAnimationPack = "Zombie"
    return applyAnimationPack(character, AnimationPacks.Zombie)
end

local function resetAnimations(character)
    if not character or not character.Parent then return end

    -- Fully stop Jerry's custom animation controller.
    if animationControllerCleanup then
        pcall(animationControllerCleanup)
        animationControllerCleanup = nil
    end

    local animate = character:FindFirstChild("Animate")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local packFolder = character:FindFirstChild("__JerryAnimationPack")

    if humanoid then
        stopCurrentAnimations(humanoid)
    end

    if packFolder then
        packFolder:Destroy()
    end

    -- Restore Roblox's normal Animate controller.
    if animate then
        animate.Enabled = false
        task.wait(0.1)
        animate.Enabled = true
        task.wait(0.15)
    end
end

local function setupAnimationOnCharacter(character)
    if not zombieAnimationEnabled or not activeAnimationPack then
        return
    end

    local animate = character:WaitForChild("Animate", 5)
    if not animate then return end

    task.wait(0.1)
    applyAnimationPack(character, AnimationPacks[activeAnimationPack])
end

-- Re-apply Zombie animations after every respawn.
if respawnConnection then
    respawnConnection:Disconnect()
end

respawnConnection = localPlayer.CharacterAdded:Connect(function(character)
    setupAnimationOnCharacter(character)
end)

-- Reset / Default Animation button
local ResetAnimBtn = Instance.new("TextButton")
ResetAnimBtn.Size = UDim2.new(1, 0, 0, 30)
ResetAnimBtn.Position = UDim2.new(0, 0, 0, 0)
ResetAnimBtn.Text = "Reset Animation (Default)"
ResetAnimBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ResetAnimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetAnimBtn.Font = Enum.Font.SourceSansBold
ResetAnimBtn.TextSize = 14
ResetAnimBtn.Parent = AnimPage
Instance.new("UICorner", ResetAnimBtn).CornerRadius = UDim.new(0, 6)

ResetAnimBtn.MouseButton1Click:Connect(function()
    zombieAnimationEnabled = false
    activeAnimationPack = nil

    local character = localPlayer.Character
    if character then
        resetAnimations(character)
    end
end)

-- Scrolling Frame for Animation Packs
local AnimScroll = Instance.new("ScrollingFrame")
AnimScroll.Size = UDim2.new(1, 0, 1, -38)
AnimScroll.Position = UDim2.new(0, 0, 0, 38)
AnimScroll.BackgroundTransparency = 1
AnimScroll.BorderSizePixel = 0
AnimScroll.ScrollBarThickness = 4
AnimScroll.Parent = AnimPage

local AnimGrid = Instance.new("UIGridLayout")
AnimGrid.CellSize = UDim2.new(0, 105, 0, 35)
AnimGrid.CellPadding = UDim2.new(0, 8, 0, 8)
AnimGrid.Parent = AnimScroll

AnimGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AnimScroll.CanvasSize = UDim2.new(0, 0, 0, AnimGrid.AbsoluteContentSize.Y + 10)
end)

for packName, _ in pairs(AnimationPacks) do
    local btn = Instance.new("TextButton")
    btn.Text = packName
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = AnimScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        zombieAnimationEnabled = true
        activeAnimationPack = packName

        local character = localPlayer.Character
        if character then
            applyAnimationPack(character, AnimationPacks[packName])
        end
    end)
end
