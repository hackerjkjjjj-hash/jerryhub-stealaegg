--========================================================
-- STEAL AN EGG - HUB (SPEED, AUTO EGG, TITAN & EVENT)
-- Put in: StarterPlayer > StarterPlayerScripts (LocalScript)
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- States & Values
local speedEnabled = false
local highSpeedVal = 240
local lowSpeedVal = 50
local isHighSpeedMode = false

local autoEggEnabled = false
local isProcessingEgg = false

local flying = false
local flySpeed = 80
local flyBodyVel, flyBodyGyro

local espEnabled = false
local savedCoords = {}

-- New Update States (Titan Temple & Hungry Frog Event)
local autoStealTitan = false
local autoFeedFrog = false
local godModeEnabled = false
local instantSteal = false

-- Helper functions
local function parseSpeedValue(val)
    if typeof(val) == "number" then return val end
    if typeof(val) == "string" then
        local numStr = val:match("[%d%.]+")
        if not numStr then return 0 end
        local num = tonumber(numStr) or 0
        if val:find("B") or val:find("b") then return num * 1e9
        elseif val:find("M") or val:find("m") then return num * 1e6
        elseif val:find("K") or val:find("k") then return num * 1e3
        end
        return num
    end
    return 0
end

local function checkCurrentServerSpeed()
    local maxAllowedSpeed = 100 * 1e6
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local leaderstats = p:FindFirstChild("leaderstats")
            if leaderstats then
                local speedStat = leaderstats:FindFirstChild("Speed")
                if speedStat and parseSpeedValue(speedStat.Value) >= maxAllowedSpeed then
                    return false
                end
            end
        end
    end
    return true
end

local function disableCollisionForModel(model)
    if not model then return end
    if model:IsA("BasePart") then
        model.CanCollide = false
    end
    for _, child in ipairs(model:GetDescendants()) do
        if child:IsA("BasePart") then
            child.CanCollide = false
        end
    end
end

--========================================================
-- 1. SPEED ENGINE
--========================================================

RunService.Heartbeat:Connect(function()
    if not speedEnabled then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if isProcessingEgg then
            hum.WalkSpeed = math.min(lowSpeedVal, 60)
        else
            hum.WalkSpeed = isHighSpeedMode and highSpeedVal or lowSpeedVal
        end
    end
end)

--========================================================
-- 2. ESP PLAYERS SYSTEM
--========================================================

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    
    local function applyHighlight(char)
        if not char then return end
        
        local highlight = char:FindFirstChild("ESPHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = char
        end
        highlight.Enabled = espEnabled

        local head = char:WaitForChild("Head", 3)
        if head and not head:FindFirstChild("ESPBillboard") then
            local bb = Instance.new("BillboardGui")
            bb.Name = "ESPBillboard"
            bb.Size = UDim2.new(0, 100, 0, 30)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Parent = head

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1, 0, 1, 0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            txt.TextStrokeTransparency = 0
            txt.Font = Enum.Font.GothamBold
            txt.TextSize = 11
            txt.Text = targetPlayer.Name
            txt.Parent = bb

            task.spawn(function()
                while bb and bb.Parent and char and char:FindFirstChild("HumanoidRootPart") do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        txt.Text = targetPlayer.Name .. " [" .. math.floor(dist) .. "m]"
                    end
                    bb.Enabled = espEnabled
                    task.wait(0.2)
                end
            end)
        end
    end

    if targetPlayer.Character then
        applyHighlight(targetPlayer.Character)
    end
    targetPlayer.CharacterAdded:Connect(applyHighlight)
end

local function toggleESP(state)
    espEnabled = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            createESP(p)
            if p.Character then
                local hl = p.Character:FindFirstChild("ESPHighlight")
                if hl then hl.Enabled = espEnabled end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if espEnabled then
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            createESP(p)
        end)
    end
end)

--========================================================
-- 3. AUTO EGG & TITAN TEMPLE LOGIC
--========================================================

local function findGlowingEgg()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Highlight") or obj:IsA("SelectionBox") or obj:IsA("ParticleEmitter") then
            local targetPart = obj.Parent
            if targetPart and targetPart:IsA("BasePart") then
                return targetPart
            elseif targetPart and targetPart:IsA("Model") then
                return targetPart.PrimaryPart or targetPart:FindFirstChildWhichIsA("BasePart")
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.15) do
        if autoEggEnabled and not isProcessingEgg then
            local glowingEgg = findGlowingEgg()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if glowingEgg and root and hum then
                isProcessingEgg = true
                local targetPos = glowingEgg.Position
                hum:MoveTo(targetPos)
                
                local moveTimeout = 0
                repeat
                    task.wait(0.05)
                    moveTimeout = moveTimeout + 0.05
                until (root.Position - targetPos).Magnitude <= 8 or moveTimeout >= 4 or not autoEggEnabled

                if (root.Position - targetPos).Magnitude <= 10 and autoEggEnabled then
                    disableCollisionForModel(glowingEgg.Parent)
                    disableCollisionForModel(glowingEgg)
                    hum:MoveTo(root.Position)
                    task.wait(0.05)
                    
                    local prompt = glowingEgg:FindFirstChildOfClass("ProximityPrompt") 
                        or glowingEgg.Parent:FindFirstChildOfClass("ProximityPrompt")
                        or (glowingEgg.Parent and glowingEgg.Parent:FindFirstChildOfClass("ProximityPrompt"))
                    
                    if prompt then
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        else
                            prompt:InputHoldBegin()
                            task.wait(prompt.HoldDuration or 0.2)
                            prompt:InputHoldEnd()
                        end
                    end
                    
                    task.wait(0.15)
                    local spawnLocation = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawns")
                    local targetCFrame = nil

                    if spawnLocation then
                        local spawnPart = spawnLocation:IsA("BasePart") and spawnLocation or spawnLocation:FindFirstChildWhichIsA("BasePart")
                        if spawnPart then targetCFrame = spawnPart.CFrame + Vector3.new(0, 3, 0) end
                    elseif savedCoords.pos then
                        targetCFrame = savedCoords.pos
                    end

                    if targetCFrame then
                        root.CFrame = targetCFrame
                        task.wait(0.1)
                        root.CFrame = targetCFrame
                    end
                end
                task.wait(0.2)
                isProcessingEgg = false
            end
        end
    end
end)

-- Titan Temple Auto Steal Loop
task.spawn(function()
    while task.wait(0.5) do
        if autoStealTitan then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:find("Titan") or obj.Name:find("Monster")) then
                        if obj:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end
end)

-- Hungry Frog Event Loop (Infected/Parasite Eggs)
task.spawn(function()
    while task.wait(1) do
        if autoFeedFrog then
            pcall(function()
                for _, egg in pairs(Workspace:GetDescendants()) do
                    if egg.Name:find("Infected") or egg.Name:find("Parasite") then
                        if egg:FindFirstChild("PrimaryPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = egg.PrimaryPart.CFrame
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
    end
end)

-- God Mode / Guard Freeze Loop
task.spawn(function()
    while task.wait(0.5) do
        if godModeEnabled then
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                end
                for _, npc in pairs(Workspace:GetChildren()) do
                    if npc.Name:find("Gorilla") or npc.Name:find("Guard") then
                        if npc:FindFirstChild("HumanoidRootPart") then
                            npc.HumanoidRootPart.Anchored = true
                        end
                    end
                end
            end)
        end
    end
end)

--========================================================
-- 4. FLY LOGIC
--========================================================

local function startFlying()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    hum.PlatformStand = true

    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = root

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root

    task.spawn(function()
        while flying and player.Character and root and hum do
            local camCFrame = Workspace.CurrentCamera.CFrame
            local moveDir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                flyBodyVel.Velocity = moveDir.Unit * flySpeed
            else
                flyBodyVel.Velocity = Vector3.zero
            end

            flyBodyGyro.CFrame = camCFrame
            task.wait()
        end

        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if hum then hum.PlatformStand = false end
    end)
end

local function stopFlying()
    flying = false
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

--========================================================
-- 5. GUI CREATION (5 TABS: SPEED, FLY, ESP, SERVERS, TITAN)
--========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "StealAnEggHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(420, 330)
main.Position = UDim2.fromOffset(100, 100)
main.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 65, 85)
stroke.Thickness = 1.5
stroke.Parent = main

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.ZIndex = 10
closeBtn.Parent = main

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    stopFlying()
    speedEnabled = false
    autoEggEnabled = false
    autoStealTitan = false
    autoFeedFrog = false
    godModeEnabled = false
    toggleESP(false)
    gui:Destroy()
end)

-- Tab Bar (5 Tabs)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -45, 0, 35)
tabBar.Position = UDim2.fromOffset(8, 8)
tabBar.BackgroundColor3 = Color3.fromRGB(25, 27, 36)
tabBar.Parent = main
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabs, pages = {}, {}

local function createTab(name, pos, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, -4)
    btn.Position = pos
    btn.BackgroundColor3 = index == 1 and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(35, 37, 48)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -60)
    page.Position = UDim2.fromOffset(10, 50)
    page.BackgroundTransparency = 1
    page.Visible = (index == 1)
    page.Parent = main
    
    tabs[index] = btn
    pages[index] = page
    
    btn.MouseButton1Click:Connect(function()
        for i, pageObj in ipairs(pages) do
            pageObj.Visible = (i == index)
            tabs[i].BackgroundColor3 = (i == index) and Color3.fromRGB(65, 105, 225) or Color3.fromRGB(35, 37, 48)
        end
    end)
    
    return page
end

local speedPage = createTab("⚡ SPEED", UDim2.new(0, 2, 0, 2), 1)
local flyPage   = createTab("🕊️ FLY", UDim2.new(0.2, 0, 0, 2), 2)
local espPage   = createTab("👁️ ESP", UDim2.new(0.4, -2, 0, 2), 3)
local tpPage    = createTab("🌀 SERVERS", UDim2.new(0.6, -4, 0, 2), 4)
local titanPage = createTab("🦖 TITAN", UDim2.new(0.8, -6, 0, 2), 5)

-- Dragging Logic
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--========================================================
-- TAB 1: SPEED & AUTO EGG
--========================================================

local walkToggle = Instance.new("TextButton")
walkToggle.Size = UDim2.new(0.5, -5, 0, 32)
walkToggle.Position = UDim2.fromOffset(0, 2)
walkToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
walkToggle.Text = "SPEED: OFF"
walkToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
walkToggle.Font = Enum.Font.GothamBold
walkToggle.TextSize = 11
walkToggle.Parent = speedPage
Instance.new("UICorner", walkToggle).CornerRadius = UDim.new(0, 8)

local switchSpeedBtn = Instance.new("TextButton")
switchSpeedBtn.Size = UDim2.new(0.5, -5, 0, 32)
switchSpeedBtn.Position = UDim2.new(0.5, 5, 0, 2)
switchSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 200)
switchSpeedBtn.Text = "🔄 MODE: LOW (50)"
switchSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
switchSpeedBtn.Font = Enum.Font.GothamBold
switchSpeedBtn.TextSize = 9
switchSpeedBtn.Parent = speedPage
Instance.new("UICorner", switchSpeedBtn).CornerRadius = UDim.new(0, 8)

local highSpeedInput = Instance.new("TextBox")
highSpeedInput.Size = UDim2.new(0.5, -5, 0, 32)
highSpeedInput.Position = UDim2.fromOffset(0, 38)
highSpeedInput.BackgroundColor3 = Color3.fromRGB(32, 34, 45)
highSpeedInput.Text = "240"
highSpeedInput.PlaceholderText = "High Speed"
highSpeedInput.TextColor3 = Color3.fromRGB(255, 80, 80)
highSpeedInput.Font = Enum.Font.GothamBold
highSpeedInput.TextSize = 11
highSpeedInput.ClearTextOnFocus = false
highSpeedInput.Parent = speedPage
Instance.new("UICorner", highSpeedInput).CornerRadius = UDim.new(0, 8)

local lowSpeedInput = Instance.new("TextBox")
lowSpeedInput.Size = UDim2.new(0.5, -5, 0, 32)
lowSpeedInput.Position = UDim2.new(0.5, 5, 0, 38)
lowSpeedInput.BackgroundColor3 = Color3.fromRGB(32, 34, 45)
lowSpeedInput.Text = "50"
lowSpeedInput.PlaceholderText = "Low Speed"
lowSpeedInput.TextColor3 = Color3.fromRGB(100, 255, 100)
lowSpeedInput.Font = Enum.Font.GothamBold
lowSpeedInput.TextSize = 11
lowSpeedInput.ClearTextOnFocus = false
lowSpeedInput.Parent = speedPage
Instance.new("UICorner", lowSpeedInput).CornerRadius = UDim.new(0, 8)

local autoEggBtn = Instance.new("TextButton")
autoEggBtn.Size = UDim2.new(1, 0, 0, 38)
autoEggBtn.Position = UDim2.fromOffset(0, 75)
autoEggBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 160)
autoEggBtn.Text = "🥚 SAFE AUTO EGG: OFF"
autoEggBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoEggBtn.Font = Enum.Font.GothamBold
autoEggBtn.TextSize = 10
autoEggBtn.Parent = speedPage
Instance.new("UICorner", autoEggBtn).CornerRadius = UDim.new(0, 8)

walkToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    walkToggle.Text = speedEnabled and "SPEED: ON" or "SPEED: OFF"
    walkToggle.BackgroundColor3 = speedEnabled and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(45, 50, 65)
    
    if not speedEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

switchSpeedBtn.MouseButton1Click:Connect(function()
    isHighSpeedMode = not isHighSpeedMode
    if isHighSpeedMode then
        switchSpeedBtn.Text = "🔄 MODE: HIGH (" .. highSpeedVal .. ")"
        switchSpeedBtn.BackgroundColor3 = Color3.fromRGB(200, 130, 20)
    else
        switchSpeedBtn.Text = "🔄 MODE: LOW (" .. lowSpeedVal .. ")"
        switchSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 200)
    end
end)

highSpeedInput.FocusLost:Connect(function()
    local num = tonumber(highSpeedInput.Text)
    highSpeedVal = num and math.floor(num) or 240
    highSpeedInput.Text = tostring(highSpeedVal)
    if isHighSpeedMode then switchSpeedBtn.Text = "🔄 MODE: HIGH (" .. highSpeedVal .. ")" end
end)

lowSpeedInput.FocusLost:Connect(function()
    local num = tonumber(lowSpeedInput.Text)
    lowSpeedVal = num and math.floor(num) or 50
    lowSpeedInput.Text = tostring(lowSpeedVal)
    if not isHighSpeedMode then switchSpeedBtn.Text = "🔄 MODE: LOW (" .. lowSpeedVal .. ")" end
end)

autoEggBtn.MouseButton1Click:Connect(function()
    autoEggEnabled = not autoEggEnabled
    autoEggBtn.Text = autoEggEnabled and "🥚 SAFE AUTO EGG: ON" or "🥚 SAFE AUTO EGG: OFF"
    autoEggBtn.BackgroundColor3 = autoEggEnabled and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(120, 40, 160)
end)

--========================================================
-- TAB 2: FLY
--========================================================

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0.6, -5, 0, 45)
flyToggle.Position = UDim2.fromOffset(0, 25)
flyToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
flyToggle.Text = "FLY: OFF"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 13
flyToggle.Parent = flyPage
Instance.new("UICorner", flyToggle).CornerRadius = UDim.new(0, 8)

local flyInput = Instance.new("TextBox")
flyInput.Size = UDim2.new(0.4, -5, 0, 45)
flyInput.Position = UDim2.new(0.6, 5, 0, 25)
flyInput.BackgroundColor3 = Color3.fromRGB(32, 34, 45)
flyInput.Text = "80"
flyInput.PlaceholderText = "Fly Speed"
flyInput.TextColor3 = Color3.fromRGB(0, 220, 255)
flyInput.Font = Enum.Font.GothamBold
flyInput.TextSize = 14
flyInput.ClearTextOnFocus = false
flyInput.Parent = flyPage
Instance.new("UICorner", flyInput).CornerRadius = UDim.new(0, 8)

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then startFlying() else stopFlying() end
    flyToggle.Text = flying and "FLY: ON" or "FLY: OFF"
    flyToggle.BackgroundColor3 = flying and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(45, 50, 65)
end)

flyInput.FocusLost:Connect(function()
    local num = tonumber(flyInput.Text)
    flySpeed = num or 80
    flyInput.Text = tostring(flySpeed)
end)

--========================================================
-- TAB 3: ESP PLAYERS
--========================================================

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(1, 0, 0, 45)
espToggle.Position = UDim2.fromOffset(0, 25)
espToggle.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
espToggle.Text = "👁️ ESP PLAYERS: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 12
espToggle.Parent = espPage
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 8)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    toggleESP(espEnabled)
    espToggle.Text = espEnabled and "👁️ ESP PLAYERS: ON" or "👁️ ESP PLAYERS: OFF"
    espToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(45, 50, 65)
end)

--========================================================
-- TAB 4: TELEPORT / SERVERS
--========================================================

local btnSavePos = Instance.new("TextButton")
btnSavePos.Size = UDim2.new(0.5, -5, 0, 32)
btnSavePos.Position = UDim2.fromOffset(0, 2)
btnSavePos.BackgroundColor3 = Color3.fromRGB(40, 110, 180)
btnSavePos.Text = "📍 SAVE POS"
btnSavePos.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSavePos.Font = Enum.Font.GothamBold
btnSavePos.TextSize = 11
btnSavePos.Parent = tpPage
Instance.new("UICorner", btnSavePos).CornerRadius = UDim.new(0, 8)

local btnTpPos = Instance.new("TextButton")
btnTpPos.Size = UDim2.new(0.5, -5, 0, 32)
btnTpPos.Position = UDim2.new(0.5, 5, 0, 2)
btnTpPos.BackgroundColor3 = Color3.fromRGB(180, 110, 40)
btnTpPos.Text = "🌀 TP SAVED POS"
btnTpPos.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTpPos.Font = Enum.Font.GothamBold
btnTpPos.TextSize = 11
btnTpPos.Parent = tpPage
Instance.new("UICorner", btnTpPos).CornerRadius = UDim.new(0, 8)

local btn3Players = Instance.new("TextButton")
btn3Players.Size = UDim2.new(1, 0, 0, 32)
btn3Players.Position = UDim2.fromOffset(0, 40)
btn3Players.BackgroundColor3 = Color3.fromRGB(130, 50, 160)
btn3Players.Text = "👥 TP TO 3-PLAYER SERVER"
btn3Players.TextColor3 = Color3.fromRGB(255, 255, 255)
btn3Players.Font = Enum.Font.GothamBold
btn3Players.TextSize = 11
btn3Players.Parent = tpPage
Instance.new("UICorner", btn3Players).CornerRadius = UDim.new(0, 8)

local btnLowSpeed = Instance.new("TextButton")
btnLowSpeed.Size = UDim2.new(1, 0, 0, 32)
btnLowSpeed.Position = UDim2.fromOffset(0, 78)
btnLowSpeed.BackgroundColor3 = Color3.fromRGB(200, 100, 30)
btnLowSpeed.Text = "🎯 FIND SERVER (SPEED < 100M)"
btnLowSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLowSpeed.Font = Enum.Font.GothamBold
btnLowSpeed.TextSize = 10
btnLowSpeed.Parent = tpPage
Instance.new("UICorner", btnLowSpeed).CornerRadius = UDim.new(0, 8)

local tpStatus = Instance.new("TextLabel")
tpStatus.Size = UDim2.new(1, 0, 0, 25)
tpStatus.Position = UDim2.fromOffset(0, 120)
tpStatus.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
tpStatus.Text = "Ready..."
tpStatus.TextColor3 = Color3.fromRGB(170, 175, 190)
tpStatus.Font = Enum.Font.Gotham
tpStatus.TextSize = 10
tpStatus.Parent = tpPage
Instance.new("UICorner", tpStatus).CornerRadius = UDim.new(0, 6)

btnSavePos.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCoords.pos = char.HumanoidRootPart.CFrame
        tpStatus.Text = "✅ Position Saved!"
        tpStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

btnTpPos.MouseButton1Click:Connect(function()
    local char = player.Character
    if savedCoords.pos and char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = savedCoords.pos
        tpStatus.Text = "⚡ Teleported!"
        tpStatus.TextColor3 = Color3.fromRGB(100, 220, 255)
    else
        tpStatus.Text = "❌ Save a position first!"
        tpStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

btn3Players.MouseButton1Click:Connect(function()
    teleportTo3PlayerServer(tpStatus)
end)

btnLowSpeed.MouseButton1Click:Connect(function()
    findLowSpeedServer(tpStatus)
end)

--========================================================
-- TAB 5: TITAN TEMPLE & HUNGRY FROG EVENT
--========================================================

local autoTitanBtn = Instance.new("TextButton")
autoTitanBtn.Size = UDim2.new(1, 0, 0, 32)
autoTitanBtn.Position = UDim2.fromOffset(0, 2)
autoTitanBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 100)
autoTitanBtn.Text = "🦖 AUTO TITAN TEMPLE: OFF"
autoTitanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoTitanBtn.Font = Enum.Font.GothamBold
autoTitanBtn.TextSize = 10
autoTitanBtn.Parent = titanPage
Instance.new("UICorner", autoTitanBtn).CornerRadius = UDim.new(0, 8)

local autoFrogBtn = Instance.new("TextButton")
autoFrogBtn.Size = UDim2.new(1, 0, 0, 32)
autoFrogBtn.Position = UDim2.fromOffset(0, 38)
autoFrogBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
autoFrogBtn.Text = "🐸 AUTO INFECTED EGGS (FROG): OFF"
autoFrogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFrogBtn.Font = Enum.Font.GothamBold
autoFrogBtn.TextSize = 10
autoFrogBtn.Parent = titanPage
Instance.new("UICorner", autoFrogBtn).CornerRadius = UDim.new(0, 8)

local godModeBtn = Instance.new("TextButton")
godModeBtn.Size = UDim2.new(1, 0, 0, 32)
godModeBtn.Position = UDim2.fromOffset(0, 74)
godModeBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 50)
godModeBtn.Text = "🛡️ FREEZE GUARDS / GORILLA KING: OFF"
godModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godModeBtn.Font = Enum.Font.GothamBold
godModeBtn.TextSize = 9
godModeBtn.Parent = titanPage
Instance.new("UICorner", godModeBtn).CornerRadius = UDim.new(0, 8)

autoTitanBtn.MouseButton1Click:Connect(function()
    autoStealTitan = not autoStealTitan
    autoTitanBtn.Text = autoStealTitan and "🦖 AUTO TITAN TEMPLE: ON" or "🦖 AUTO TITAN TEMPLE: OFF"
    autoTitanBtn.BackgroundColor3 = autoStealTitan and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(150, 50, 100)
end)

autoFrogBtn.MouseButton1Click:Connect(function()
    autoFeedFrog = not autoFeedFrog
    autoFrogBtn.Text = autoFeedFrog and "🐸 AUTO INFECTED EGGS (FROG): ON" or "🐸 AUTO INFECTED EGGS (FROG): OFF"
    autoFrogBtn.BackgroundColor3 = autoFeedFrog and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(60, 140, 60)
end)

godModeBtn.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    godModeBtn.Text = godModeEnabled and "🛡️ FREEZE GUARDS / GORILLA KING: ON" or "🛡️ FREEZE GUARDS / GORILLA KING: OFF"
    godModeBtn.BackgroundColor3 = godModeEnabled and Color3.fromRGB(45, 170, 90) or Color3.fromRGB(200, 70, 50)
end)
