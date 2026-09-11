
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
local HomePage = Instance.new("Frame", PageContainer)
HomePage.Size = UDim2.new(1, 0, 1, 0)
HomePage.BackgroundTransparency = 1

local PlayerPage = Instance.new("Frame", PageContainer)
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1

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
-- PROXIMITY PROMPT: SAFE MONITOR TOGGLE
-- This only monitors/counts prompts locally.
-- It does NOT activate, modify, or bypass prompts.
---------------------------------------------------------
local PromptMonitorEnabled = false
local PromptMonitorConnection = nil

local PromptToggle = Instance.new("TextButton", StealPage)
PromptToggle.Size = UDim2.new(1, -20, 0, 42)
PromptToggle.Position = UDim2.new(0, 10, 0, 135)
PromptToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PromptToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
PromptToggle.Font = Enum.Font.SourceSansBold
PromptToggle.TextSize = 16
PromptToggle.Text = "ProximityPrompt Monitor: OFF"
Instance.new("UICorner", PromptToggle).CornerRadius = UDim.new(0, 6)

local PromptCount = Instance.new("TextLabel", StealPage)
PromptCount.Size = UDim2.new(1, -20, 0, 35)
PromptCount.Position = UDim2.new(0, 10, 0, 185)
PromptCount.BackgroundTransparency = 1
PromptCount.TextColor3 = Color3.fromRGB(180, 180, 180)
PromptCount.Font = Enum.Font.SourceSans
PromptCount.TextSize = 14
PromptCount.Text = "Detected ProximityPrompts: 0"

local function updatePromptCount()
    local count = 0

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            count += 1
        end
    end

    PromptCount.Text = "Detected ProximityPrompts: " .. tostring(count)
end

local function stopPromptMonitor()
    PromptMonitorEnabled = false

    if PromptMonitorConnection then
        PromptMonitorConnection:Disconnect()
        PromptMonitorConnection = nil
    end

    PromptToggle.Text = "ProximityPrompt Monitor: OFF"
end

local function startPromptMonitor()
    PromptMonitorEnabled = true
    PromptToggle.Text = "ProximityPrompt Monitor: ON"
    updatePromptCount()

    PromptMonitorConnection = RunService.Heartbeat:Connect(function()
        if not PromptMonitorEnabled then
            return
        end

        -- Update occasionally without changing or activating prompts.
        if math.floor(os.clock() * 2) % 2 == 0 then
            updatePromptCount()
        end
    end)
end

PromptToggle.MouseButton1Click:Connect(function()
    if PromptMonitorEnabled then
        stopPromptMonitor()
    else
        startPromptMonitor()
    end
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
