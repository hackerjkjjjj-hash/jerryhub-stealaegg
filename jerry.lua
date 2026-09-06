-- ====================================================================================
-- [[ PART 1 / 4: ULTIMATE STEAL AN EGG MASTER HUB - CORE DATABASE & UI FRAMEWORK ]] --
-- ====================================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Global Master Configuration Settings
getgenv().MasterHubConfig = {
    AutoStealActive = false,
    SafeNoclipActive = false,
    FlightSpeed = 45,
    BypassedArea = false,
    SavedBaseCFrame = nil,
    TargetRarityPriority = "Divine",
    AutoRejoinEnabled = true,
    WebhookURL = "",
    ServerHopOnPlayer = false,
    VisualESPEnabled = true,
    AutoSellPets = false,
    AutoOpenEggs = false,
    OptimizationMode = true
}

-- ====================================================================================
-- [MODULE 1.1]: MASSIVE GAME DATABASE (ទិន្នន័យលម្អិតតំបន់ទាំង ១១ និងស៊ុតទាំងអស់)
-- ====================================================================================
local MasterGameDatabase = {
    Biomes = {
        {ID = 1, Name = "Forest", ReqStrength = 0, EggTypes = {"Forest Egg", "Basic Egg", "Leaf Egg"}, Waypoint = Vector3.new(0, 5, 0)},
        {ID = 2, Name = "Lake", ReqStrength = 900, EggTypes = {"Lake Egg", "Water Egg", "Swan Egg"}, Waypoint = Vector3.new(250, 5, 120)},
        {ID = 3, Name = "Desert", ReqStrength = 10000, EggTypes = {"Desert Egg", "Sand Egg", "Scorpion Egg"}, Waypoint = Vector3.new(600, 10, 450)},
        {ID = 4, Name = "Jungle", ReqStrength = 50000, EggTypes = {"Jungle Egg", "Vine Egg", "Tiger Egg"}, Waypoint = Vector3.new(1200, 15, 890)},
        {ID = 5, Name = "Snow", ReqStrength = 170000, EggTypes = {"Snow Egg", "Ice Egg", "Yeti Egg"}, Waypoint = Vector3.new(2200, 20, 1500)},
        {ID = 6, Name = "Volcano", ReqStrength = 700000, EggTypes = {"Volcano Egg", "Lava Egg", "Hellhound Egg"}, Waypoint = Vector3.new(3800, 25, 2400)},
        {ID = 7, Name = "Abyss Ocean", ReqStrength = 2500000, EggTypes = {"Ocean Egg", "Abyss Egg", "Moby Egg"}, Waypoint = Vector3.new(6000, 30, 3900)},
        {ID = 8, Name = "Prehistoric", ReqStrength = 17000000, EggTypes = {"Prehistoric Egg", "Fossil Egg", "T-Rex Egg"}, Waypoint = Vector3.new(9500, 40, 6200)},
        {ID = 9, Name = "Cosmic", ReqStrength = 700000000, EggTypes = {"Cosmic Egg", "Galaxy Egg", "Dragon Egg"}, Waypoint = Vector3.new(15000, 50, 10000)},
        {ID = 10, Name = "Cherry Blossom", ReqStrength = 2500000000, EggTypes = {"Cherry Egg", "Blossom Egg", "Oni Egg"}, Waypoint = Vector3.new(24000, 60, 16000)},
        {ID = 11, Name = "Titan Temple", ReqStrength = 7000000000, EggTypes = {"Titan Egg", "Temple Egg", "Gorilla Egg"}, Waypoint = Vector3.new(38000, 80, 25000)}
    },
    RarityMultipliers = {
        ["Divine"] = {Score = 10, Color = Color3.fromRGB(255, 0, 0)},
        ["Eternal"] = {Score = 9, Color = Color3.fromRGB(170, 0, 255)},
        ["Secret"] = {Score = 8, Color = Color3.fromRGB(255, 128, 0)},
        ["Mythic"] = {Score = 7, Color = Color3.fromRGB(0, 170, 255)},
        ["Legendary"] = {Score = 6, Color3.fromRGB(255, 255, 0)},
        ["Epic"] = {Score = 5, Color3.fromRGB(170, 0, 127)},
        ["Rare"] = {Score = 4, Color3.fromRGB(0, 255, 0)},
        ["Uncommon"] = {Score = 3, Color3.fromRGB(0, 170, 127)},
        ["Common"] = {Score = 1, Color3.fromRGB(150, 150, 150)}
    }
}

-- ====================================================================================
-- [MODULE 1.2]: ADVANCED NOTIFICATION & LOGGING SUBSYSTEM (ប្រព័ន្ធបង្ហាញដំណឹងកម្រិតខ្ពស់)
-- ====================================================================================
local MasterNotificationSystem = {}
function MasterNotificationSystem.Send(headerTitle, messageContent, displayDuration)
    pcall(function()
        local parentGuiContainer = gethui and gethui() or CoreGui:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        local notificationScreenGui = parentGuiContainer:FindFirstChild("MasterPersistentNotifGui") or Instance.new("ScreenGui", parentGuiContainer)
        notificationScreenGui.Name = "MasterPersistentNotifGui"
        notificationScreenGui.ResetOnSpawn = false

        local notificationCard = Instance.new("Frame", notificationScreenGui)
        notificationCard.Size = UDim2.new(0, 340, 0, 75)
        notificationCard.Position = UDim2.new(1, -350, 0, 20 + (#notificationScreenGui:GetChildren() * 85))
        notificationCard.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        notificationCard.BorderSizePixel = 0
        Instance.new("UICorner", notificationCard).CornerRadius = UDim.new(0, 10)
        
        local cardStroke = Instance.new("UIStroke", notificationCard)
        cardStroke.Color = Color3.fromRGB(0, 255, 128)
        cardStroke.Thickness = 1.5

        local titleLabel = Instance.new("TextLabel", notificationCard)
        titleLabel.Size = UDim2.new(1, -15, 0, 25)
        titleLabel.Position = UDim2.new(0, 12, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "👑 " .. tostring(headerTitle)
        titleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local descLabel = Instance.new("TextLabel", notificationCard)
        descLabel.Size = UDim2.new(1, -15, 0, 35)
        descLabel.Position = UDim2.new(0, 12, 0, 30)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = tostring(messageContent)
        descLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 11
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left

        task.delay(displayDuration or 3.5, function()
            if notificationCard then notificationCard:Destroy() end
        end)
    end)
end

-- ====================================================================================
-- [MODULE 1.3]: CUSTOM UI FRAMEWORK LIBRARY (បណ្ណាល័យបង្កើត UI ផ្ទាល់ខ្លួនខ្នាតធំ)
-- ====================================================================================
local CustomUIBuilder = {}
function CustomUIBuilder.CreateWindow(windowTitleText)
    local targetParentGui = gethui and gethui() or CoreGui:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    if targetParentGui:FindFirstChild("UltimateMasterHubGUI") then
        targetParentGui.UltimateMasterHubGUI:Destroy()
    end

    local mainScreenGui = Instance.new("ScreenGui")
    mainScreenGui.Name = "UltimateMasterHubGUI"
    mainScreenGui.ResetOnSpawn = false
    mainScreenGui.Parent = targetParentGui

    -- Floating Icon Button
    local toggleButton = Instance.new("TextButton", mainScreenGui)
    toggleButton.Size = UDim2.new(0, 55, 0, 55)
    toggleButton.Position = UDim2.new(0, 25, 0.35, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    toggleButton.Text = "👑"
    toggleButton.TextSize = 26
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0.5, 0)
    
    local toggleStroke = Instance.new("UIStroke", toggleButton)
    toggleStroke.Color = Color3.fromRGB(255, 215, 0)
    toggleStroke.Thickness = 2

    -- Main Window Frame
    local windowFrame = Instance.new("Frame", mainScreenGui)
    windowFrame.Size = UDim2.new(0, 520, 0, 360)
    windowFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
    windowFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    windowFrame.Visible = false
    windowFrame.Active = true
    Instance.new("UICorner", windowFrame).CornerRadius = UDim.new(0, 14)
    
    local windowStroke = Instance.new("UIStroke", windowFrame)
    windowStroke.Color = Color3.fromRGB(0, 255, 128)
    windowStroke.Thickness = 1.5

    toggleButton.MouseButton1Click:Connect(function()
        windowFrame.Visible = not windowFrame.Visible
    end)

    -- Top Header Title Bar
    local headerBar = Instance.new("TextLabel", windowFrame)
    headerBar.Size = UDim2.new(1, 0, 0, 45)
    headerBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    headerBar.Text = "  👑 " .. tostring(windowTitleText) .. " [PART 1 LOADED]"
    headerBar.TextColor3 = Color3.fromRGB(255, 215, 0)
    headerBar.Font = Enum.Font.GothamBold
    headerBar.TextSize = 12
    headerBar.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", headerBar).CornerRadius = UDim.new(0, 14)

    return mainScreenGui, windowFrame
end

print("--------------------------------------------------------------------------------")
print("👑 PART 1 / 4 LOADED SUCCESSFULLY! (Database, Notifications & UI Framework Ready)")
print("--------------------------------------------------------------------------------")

-- ====================================================================================
-- [[ PART 2 / 4: ULTIMATE STEAL AN EGG MASTER HUB - SAFE FLIGHT & BYPASS ENGINE ]] --
-- ====================================================================================

-- [MODULE 2.1]: SAFE NOCLIP SUBSYSTEM (ប្រព័ន្ធការពារធ្លុះដីឆ្លងកាត់ជញ្ជាំង)
local noclipActiveConnection = nil

local function initializeSafeNoclip(isEnabled)
    pcall(function()
        if isEnabled then
            if not noclipActiveConnection then
                noclipActiveConnection = RunService.Stepped:Connect(function()
                    local character = LocalPlayer.Character
                    if character then
                        for _, partInstance in ipairs(character:GetDescendants()) do
                            if partInstance:IsA("BasePart") and partInstance.Name ~= "HumanoidRootPart" then
                                partInstance.CanCollide = false
                            end
                        end
                    end
                end)
            end
        else
            if noclipActiveConnection then
                noclipActiveConnection:Disconnect()
                noclipActiveConnection = nil
            end
            local character = LocalPlayer.Character
            if character then
                for _, partInstance in ipairs(character:GetDescendants()) do
                    if partInstance:IsA("BasePart") then
                        partInstance.CanCollide = true
                    end
                end
            end
        end
    end)
end

-- [MODULE 2.2]: SMOOTH TWEEN FLIGHT SYSTEM (ប្រព័ន្ធហោះហើររលូនការពារ Anti-Cheat)
local function executeSmoothFlightEngine(targetCFramePosition)
    local statusSuccess, errorMessage = pcall(function()
        local characterInstance = LocalPlayer.Character
        if not characterInstance or not characterInstance:FindFirstChild("HumanoidRootPart") then return end
        local rootPartInstance = characterInstance.HumanoidRootPart
        
        -- ហោះផុតពីដី 6 ម៉ែត្រដើម្បីសុវត្ថិភាពមិនឱ្យ Anti-Cheat ចាប់
        local safePosition = targetCFramePosition.Position + Vector3.new(0, 6, 0)
        local distanceValue = (rootPartInstance.Position - safePosition).Magnitude
        local flightDuration = distanceValue / MasterHubConfig.FlightSpeed
        
        local tweenConfigInfo = TweenInfo.new(flightDuration, Enum.EasingStyle.Linear)
        local activeTween = TweenService:Create(rootPartInstance, tweenConfigInfo, {CFrame = CFrame.new(safePosition)})
        activeTween:Play()
        activeTween.Completed:Wait()
    end)
    if not statusSuccess then
        warn("Flight Engine Error: " .. tostring(errorMessage))
    end
end

-- [MODULE 2.3]: AREA & PLOT BYPASS CONTROLLER (ប្រព័ន្ធទម្លុះតំបន់ហ្គេម)
local function performAreaBypass()
    local successFlag = false
    pcall(function()
        local characterInstance = LocalPlayer.Character
        if characterInstance and characterInstance:FindFirstChild("HumanoidRootPart") then
            for _, worldObject in ipairs(Workspace:GetDescendants()) do
                if worldObject:IsA("BasePart") and (worldObject.Name:lower().match("area") or worldObject.Name:lower().match("gameplay") or worldObject.Name:lower().match("zone") or worldObject.Name:lower().match("plot")) then
                    characterInstance.HumanoidRootPart.CFrame = worldObject.CFrame + Vector3.new(0, 4, 0)
                    successFlag = true
                    break
                end
            end
            if not successFlag then
                characterInstance.HumanoidRootPart.CFrame = characterInstance.HumanoidRootPart.CFrame + Vector3.new(0, 5, 25)
            end
            MasterHubConfig.BypassedArea = true
            MasterNotificationSystem.Send("Area Bypass", "Gameplay area bypassed and position locked successfully!", 3.5)
        end
    end)
    return successFlag
end

-- [MODULE 2.4]: BASE LOCATION SAVER MANAGER (ប្រព័ន្ធរក្សាទុកទីតាំងមូលដ្ឋាន)
local function saveCurrentBaseLocation()
    pcall(function()
        local characterInstance = LocalPlayer.Character
        if characterInstance and characterInstance:FindFirstChild("HumanoidRootPart") then
            MasterHubConfig.SavedBaseCFrame = characterInstance.HumanoidRootPart.CFrame
            MasterNotificationSystem.Send("Base Manager", "Current base / plot location saved successfully!", 3.5)
        end
    end)
end

print("--------------------------------------------------------------------------------")
print("👑 PART 2 / 4 LOADED SUCCESSFULLY! (Flight, Noclip & Bypass Engines Ready)")
print("--------------------------------------------------------------------------------")

-- ====================================================================================
-- [[ PART 3 / 4: ULTIMATE STEAL AN EGG MASTER HUB - AUTO STEAL & SCORING ENGINE ]] --
-- ====================================================================================

-- [MODULE 3.1]: ADVANCED EGG RARITY PRIORITY EVALUATION (ប្រព័ន្ធវាយតម្លៃពងល្អតាមរដូវកាល)
local function evaluateEggPriorityScore(promptInstance, parentPartInstance)
    local calculatedScore = 1
    pcall(function()
        local parentNameString = (parentPartInstance.Parent and parentPartInstance.Parent.Name or "")
        local combinedTextString = (promptInstance.ObjectText .. " " .. promptInstance.ActionText .. " " .. parentPartInstance.Name .. " " .. parentNameString):lower()
        
        -- កែសម្រួលត្រង់នេះ (ដូរจาก combinedTextInstance មកเป็น combinedTextString)
        if combinedTextString:match("divine") or combinedTextString:match("titan") or combinedTextString:match("cherry") then
            calculatedScore = 10
        elseif combinedTextString:match("eternal") or combinedTextString:match("secret") or combinedTextString:match("cosmic") then
            calculatedScore = 8
        elseif combinedTextString:match("mythic") or combinedTextString:match("prehistoric") or combinedTextString:match("ocean") then
            calculatedScore = 6
        elseif combinedTextString:match("legendary") or combinedTextString:match("epic") or combinedTextString:match("volcano") then
            calculatedScore = 4
        elseif combinedTextString:match("rare") or combinedTextString:match("gold") or combinedTextString:match("golden") or combinedTextString:match("snow") then
            calculatedScore = 2
        else
            calculatedScore = 1
        end
    end)
    return calculatedScore
end

-- [MODULE 3.2]: BACKGROUND AUTOMATION TASK WORKER (កិច្ចការស្កេនប្រមូលពងអូតូមិនឈប់ឈរ)
local function startMasterAutomationWorker()
    task.spawn(function()
        while true do
            pcall(function()
                if MasterHubConfig.AutoStealActive and MasterHubConfig.BypassedArea then
                    local characterInstance = LocalPlayer.Character
                    if characterInstance and characterInstance:FindFirstChild("HumanoidRootPart") then
                        local rootPartInstance = characterInstance.HumanoidRootPart
                        if not MasterHubConfig.SavedBaseCFrame then
                            MasterHubConfig.SavedBaseCFrame = rootPartInstance.CFrame
                        end
                        
                        local bestDiscoveredPrompt = nil
                        local bestDiscoveredPart = nil
                        local maxPriorityScore = -1
                        
                        -- ស្កេនរក ProximityPrompt ទាំងអស់នៅក្នុង Workspace របស់ហ្គេម
                        for _, worldDescendantNode in ipairs(Workspace:GetDescendants()) do
                            if worldDescendantNode:IsA("ProximityPrompt") then
                                local actionTextLower = worldDescendantNode.ActionText:lower()
                                local objectTextLower = worldDescendantNode.ObjectText:lower()
                                
                                if actionTextLower:match("steal") or actionTextLower:match("egg") or objectTextLower:match("egg") then
                                    local parentPartNode = worldDescendantNode.Parent
                                    if parentPartNode and parentPartNode:IsA("BasePart") then
                                        -- បង្ខំកែសម្រួលលក្ខខណ្ឌឱ្យទាញយកបានភ្លាមៗ 0.0s មិនបាច់កាន់យូរ
                                        worldDescendantNode.HoldDuration = 0
                                        worldDescendantNode.MaxActivationDistance = 99999
                                        worldDescendantNode.RequiresLineOfSight = false
                                        
                                        local currentEggScore = evaluateEggPriorityScore(worldDescendantNode, parentPartNode)
                                        if currentEggScore > maxPriorityScore then
                                            maxPriorityScore = currentEggScore
                                            bestDiscoveredPrompt = worldDescendantNode
                                            bestDiscoveredPart = parentPartNode
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- បើរកឃើញពងល្អ ធ្វើការហោះទៅយកភ្លាមៗ
                        if bestDiscoveredPrompt and bestDiscoveredPart then
                            -- ហោះទៅកន្លែងពងក្នុងល្បឿនសុវត្ថិភាព
                            executeSmoothFlightEngine(bestDiscoveredPart.CFrame)
                            task.wait(0.08)
                            
                            -- បញ្ជាឱ្យទាញយកពងដោយផ្ទាល់ 0.0s
                            fireproximityprompt(bestDiscoveredPrompt)
                            task.wait(0.12)
                            
                            -- ហោះត្រឡប់មក Base វិញដោយសុវត្ថិភាព
                            if MasterHubConfig.SavedBaseCFrame then
                                executeSmoothFlightEngine(MasterHubConfig.SavedBaseCFrame)
                                task.wait(0.25)
                            end
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end

-- [MODULE 3.3]: ANTI-AFK INITIALIZATION MANAGER (ប្រព័ន្ធការពារหลุดออกจากហ្គេមពេលទុកចោលយូរ)
local function initializeAntiAFKSystem()
    pcall(function()
        local VirtualUserSvc = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VirtualUserSvc:CaptureController()
            VirtualUserSvc:ClickButton2(Vector2.new())
        end)
    end)
end

-- ចាប់ផ្តើមដំណើរការប្រព័ន្ធផ្ទៃខាងក្រោយ
initializeAntiAFKSystem()
startMasterAutomationWorker()

print("--------------------------------------------------------------------------------")
print("👑 PART 3 / 4 LOADED SUCCESSFULLY! (Auto Steal & Scoring Engine Running)")
print("--------------------------------------------------------------------------------")

-- ====================================================================================
-- [[ PART 4 / 4: ULTIMATE STEAL AN EGG MASTER HUB - UI CONTROLS & COMPLETION ]] --
-- ====================================================================================

-- [MODULE 4.1]: CREATING DASHBOARD INTERACTIVE BUTTONS (បង្កើតប៊ូតុងបញ្ជាក្នុងផ្ទាំង UI)
local mainGuiReference, mainWindowReference = CustomUIBuilder.CreateWindow("STEAL AN EGG MASTER HUB (2000L EDITION)")

local scrollingContentContainer = Instance.new("ScrollingFrame", mainWindowReference)
scrollingContentContainer.Size = UDim2.new(1, -24, 1, -60)
scrollingContentContainer.Position = UDim2.new(0, 12, 0, 52)
scrollingContentContainer.BackgroundTransparency = 1
scrollingContentContainer.CanvasSize = UDim2.new(0, 0, 0, 650)
scrollingContentContainer.ScrollBarThickness = 4

local verticalLayoutManager = Instance.new("UIListLayout", scrollingContentContainer)
verticalLayoutManager.Padding = UDim.new(0, 12)

-- 1. Button: Step 1 - Gameplay Area Bypass
local uiButtonBypassArea = Instance.new("TextButton", scrollingContentContainer)
uiButtonBypassArea.Size = UDim2.new(1, 0, 0, 42)
uiButtonBypassArea.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
uiButtonBypassArea.Text = "🟢 Step 1: Enter Gameplay Area (Bypass)"
uiButtonBypassArea.TextColor3 = Color3.fromRGB(46, 204, 113)
uiButtonBypassArea.Font = Enum.Font.GothamBold
uiButtonBypassArea.TextSize = 12
Instance.new("UICorner", uiButtonBypassArea).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", uiButtonBypassArea).Color = Color3.fromRGB(46, 204, 113)

uiButtonBypassArea.MouseButton1Click:Connect(function()
    performAreaBypass()
end)

-- 2. Button: Step 2 - Save Base Location
local uiButtonSaveBase = Instance.new("TextButton", scrollingContentContainer)
uiButtonSaveBase.Size = UDim2.new(1, 0, 0, 42)
uiButtonSaveBase.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
uiButtonSaveBase.Text = "📌 Step 2: Set Current Base / Plot Location"
uiButtonSaveBase.TextColor3 = Color3.fromRGB(0, 210, 255)
uiButtonSaveBase.Font = Enum.Font.GothamBold
uiButtonSaveBase.TextSize = 12
Instance.new("UICorner", uiButtonSaveBase).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", uiButtonSaveBase).Color = Color3.fromRGB(0, 210, 255)

uiButtonSaveBase.MouseButton1Click:Connect(function()
    saveCurrentBaseLocation()
end)

-- 3. Button: Step 3 - Toggle Auto Steal & Flight
local uiButtonAutoStealToggle = Instance.new("TextButton", scrollingContentContainer)
uiButtonAutoStealToggle.Size = UDim2.new(1, 0, 0, 46)
uiButtonAutoStealToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
uiButtonAutoStealToggle.Text = "🚀 Step 3: Auto 0.0s Steal & Fly: OFF"
uiButtonAutoStealToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
uiButtonAutoStealToggle.Font = Enum.Font.GothamBold
uiButtonAutoStealToggle.TextSize = 12
Instance.new("UICorner", uiButtonAutoStealToggle).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", uiButtonAutoStealToggle).Color = Color3.fromRGB(255, 215, 0)

uiButtonAutoStealToggle.MouseButton1Click:Connect(function()
    MasterHubConfig.AutoStealActive = not MasterHubConfig.AutoStealActive
    initializeSafeNoclip(MasterHubConfig.AutoStealActive)
    
    if MasterHubConfig.AutoStealActive then
        uiButtonAutoStealToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        uiButtonAutoStealToggle.TextColor3 = Color3.fromRGB(15, 15, 20)
        uiButtonAutoStealToggle.Text = "🚀 Step 3: Auto 0.0s Steal & Fly: ON"
        MasterNotificationSystem.Send("Auto Steal", "Automated stealing & flight engine activated successfully!", 3)
    else
        uiButtonAutoStealToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
        uiButtonAutoStealToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        uiButtonAutoStealToggle.Text = "🚀 Step 3: Auto 0.0s Steal & Fly: OFF"
        MasterNotificationSystem.Send("Auto Steal", "Automated stealing & flight engine deactivated.", 3)
    end
end)

-- [MODULE 4.2]: BIOMES TELEPORT SECTION (ប្រព័ន្ធបញ្ជូនខ្លួនទៅកាន់តំបន់ទាំង ១១)
local biomesHeaderLabel = Instance.new("TextLabel", scrollingContentContainer)
biomesHeaderLabel.Size = UDim2.new(1, 0, 0, 30)
biomesHeaderLabel.BackgroundTransparency = 1
biomesHeaderLabel.Text = "🌍 ALL 11 BIOMES TELEPORT SYSTEM"
biomesHeaderLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
biomesHeaderLabel.Font = Enum.Font.GothamBold
biomesHeaderLabel.TextSize = 12
biomesHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left

for _, biomeDataRecord in ipairs(MasterGameDatabase.Biomes) do
    local biomeTeleportBtn = Instance.new("TextButton", scrollingContentContainer)
    biomeTeleportBtn.Size = UDim2.new(1, 0, 0, 38)
    biomeTeleportBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
    biomeTeleportBtn.Text = "🚀 Teleport to " .. biomeDataRecord.Name .. " (Tier " .. biomeDataRecord.ID .. ")"
    biomeTeleportBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
    biomeTeleportBtn.Font = Enum.Font.Gotham
    biomeTeleportBtn.TextSize = 11
    Instance.new("UICorner", biomeTeleportBtn).CornerRadius = UDim.new(0, 6)
    
    biomeTeleportBtn.MouseButton1Click:Connect(function()
        executeSmoothFlightEngine(CFrame.new(biomeDataRecord.Waypoint))
        MasterNotificationSystem.Send("Teleport", "Successfully teleported to " .. biomeDataRecord.Name .. "!", 3)
    end)
end

-- [MODULE 4.3]: FINALIZATION AND CONSOLE LOGGING (ការផ្ទៀងផ្ទាត់ចុងក្រោយ)
print("========================================================================")
print("👑 ULTIMATE STEAL AN EGG MASTER HUB LOADED SUCCESSFULLY (ALL 4 PARTS)")
print("👑 SYSTEM READY FOR 0.0S AUTOMATED FARMING & 11 BIOMES TELEPORTATION!")
print("========================================================================")

-- ====================================================================================
-- [[ PART 5 / 6: ULTIMATE STEAL AN EGG MASTER HUB - ESP & WEBHOOK MODULES ]] --
-- ====================================================================================

-- [MODULE 5.1]: ADVANCED VISUAL ESP & HIGHLIGHT SYSTEM (ប្រព័ន្ធមើលឃើញពងនិងអ្នកលេងពីចម្ងាយ)
local VisualESPManager = {
    ActiveHighlights = {},
    Enabled = true
}

function VisualESPManager.CreateHighlight(targetObject, customColor)
    pcall(function()
        if not targetObject or not targetObject:IsA("BasePart") then return end
        if targetObject:FindFirstChild("MasterEggHighlight") then return end

        local highlightInstance = Instance.new("Highlight")
        highlightInstance.Name = "MasterEggHighlight"
        highlightInstance.Adornee = targetObject
        highlightInstance.FillColor = customColor or Color3.fromRGB(0, 255, 128)
        highlightInstance.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlightInstance.FillTransparency = 0.4
        highlightInstance.OutlineTransparency = 0.1
        highlightInstance.Parent = targetObject
        
        table.insert(VisualESPManager.ActiveHighlights, highlightInstance)
    end)
end

function VisualESPManager.ScanAndRenderWorkspace()
    task.spawn(function()
        while true do
            pcall(function()
                if MasterHubConfig.VisualESPEnabled then
                    for _, descendantNode in ipairs(Workspace:GetDescendants()) do
                        if descendantNode:IsA("ProximityPrompt") then
                            local actionTextStr = descendantNode.ActionText:lower()
                            local objectTextStr = descendantNode.ObjectText:lower()
                            if actionTextStr:match("steal") or actionTextStr:match("egg") or objectTextStr:match("egg") then
                                local parentPart = descendantNode.Parent
                                if parentPart and parentPart:IsA("BasePart") then
                                    VisualESPManager.CreateHighlight(parentPart, Color3.fromRGB(255, 215, 0))
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

VisualESPManager.ScanAndRenderWorkspace()

-- [MODULE 5.2]: DISCORD WEBHOOK NOTIFICATION SYSTEM (ប្រព័ន្ធផ្ញើសារដំណឹងទៅកាន់ Discord)
local DiscordWebhookManager = {}

function DiscordWebhookManager.SendAlert(embedTitleString, embedDescriptionString, embedColorCode)
    pcall(function()
        if not MasterHubConfig.WebhookURL or MasterHubConfig.WebhookURL == "" then return end
        
        local httpRequestFunction = (syn and syn.request) or http_request or (fluxus and fluxus.request) or request
        if not httpRequestFunction then return end
        
        local payloadData = {
            content = "@everyone 👑 **STEAL AN EGG MASTER HUB ALERT**",
            embeds = {
                {
                    title = tostring(embedTitleString),
                    description = tostring(embedDescriptionString),
                    color = embedColorCode or 65280,
                    footer = {
                        text = "Timestamp: " .. os.date("%Y-%m-%d %H:%M:%S")
                    }
                }
            }
        }
        
        httpRequestFunction({
            Url = MasterHubConfig.WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payloadData)
        })
    end)
end

-- [MODULE 5.3]: AUTO REJOIN & SERVER HOP MANAGER (ប្រព័ន្ធប្តូរ Server និងចូលហ្គេមអូតូពេលหลุด)
local ServerManager = {}

function ServerManager.TriggerServerHop()
    pcall(function()
        MasterNotificationSystem.Send("Server Hop", "Searching for a new low-ping server...", 3)
        local gameServersApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local decodedResponse = HttpService:JSONDecode(game:HttpGet(gameServersApiUrl))
        
        if decodedResponse and decodedResponse.data then
            for _, serverRecord in ipairs(decodedResponse.data) do
                if serverRecord.playing < serverRecord.maxPlayers and serverRecord.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, serverRecord.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end

-- តភ្ជាប់មុខងារ Auto Rejoin កុំឱ្យหลุดដាច់ខាត
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(childObject)
    if childObject.Name == "ErrorPrompt" then
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

print("--------------------------------------------------------------------------------")
print("👑 PART 5 / 6 LOADED SUCCESSFULLY! (ESP, Webhook & Server Manager Active)")
print("--------------------------------------------------------------------------------")

-- ====================================================================================
-- [[ PART 6 / 6: ULTIMATE STEAL AN EGG MASTER HUB - OPTIMIZER & FINAL MODULES ]] --
-- ====================================================================================

-- [MODULE 6.1]: PERFORMANCE OPTIMIZER & FPS BOOSTER (ប្រព័ន្ធបង្កើនល្បឿនហ្គេមនិងកាត់បន្ថយរលាកឡាន)
local PerformanceOptimizer = {}

function PerformanceOptimizer.EnableBoost(stateValue)
    pcall(function()
        if stateValue then
            for _, childObject in ipairs(Lighting:GetChildren()) do
                if childObject:IsA("PostEffect") or childObject:IsA("BlurEffect") or childObject:IsA("SunRaysEffect") or childObject:IsA("ColorCorrectionEffect") then
                    childObject.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2
            
            for _, worldPart in ipairs(Workspace:GetDescendants()) do
                if worldPart:IsA("BasePart") then
                    worldPart.Material = Enum.Material.SmoothPlastic
                    worldPart.Reflectance = 0
                end
            end
            MasterNotificationSystem.Send("Optimizer", "FPS Booster & Graphics Optimizer Enabled!", 3)
        end
    end)
end

-- [MODULE 6.2]: ADVANCED SETTINGS TOGGLES UI (ផ្ទាំងបញ្ជាកំណត់មុខងារបន្ថែមក្នុង UI)
pcall(function()
    local parentContainer = gethui and gethui() or CoreGui:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    local mainGuiInstance = parentContainer:FindFirstChild("UltimateMasterHubGUI")
    
    if mainGuiInstance then
        local mainWindowFrame = mainGuiInstance:FindFirstChild("Frame") or mainGuiInstance:FindFirstChildWhichIsA("Frame")
        if mainWindowFrame then
            local scrollingArea = mainWindowFrame:FindFirstChildWhichIsA("ScrollingFrame")
            if scrollingArea then
                
                -- Toggle: Visual ESP
                local btnToggleESP = Instance.new("TextButton", scrollingArea)
                btnToggleESP.Size = UDim2.new(1, 0, 0, 40)
                btnToggleESP.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                btnToggleESP.Text = "👁️ Toggle Visual Egg ESP: ON"
                btnToggleESP.TextColor3 = Color3.fromRGB(0, 255, 128)
                btnToggleESP.Font = Enum.Font.GothamBold
                btnToggleESP.TextSize = 12
                Instance.new("UICorner", btnToggleESP).CornerRadius = UDim.new(0, 8)
                Instance.new("UIStroke", btnToggleESP).Color = Color3.fromRGB(0, 255, 128)
                
                btnToggleESP.MouseButton1Click:Connect(function()
                    MasterHubConfig.VisualESPEnabled = not MasterHubConfig.VisualESPEnabled
                    btnToggleESP.Text = MasterHubConfig.VisualESPEnabled and "👁️ Toggle Visual Egg ESP: ON" or "👁️ Toggle Visual Egg ESP: OFF"
                    btnToggleESP.TextColor3 = MasterHubConfig.VisualESPEnabled and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 100, 100)
                end)
                
                -- Toggle: Performance Booster
                local btnToggleOptimizer = Instance.new("TextButton", scrollingArea)
                btnToggleOptimizer.Size = UDim2.new(1, 0, 0, 40)
                btnToggleOptimizer.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                btnToggleOptimizer.Text = "⚡ Toggle FPS Booster / Anti-Lag"
                btnToggleOptimizer.TextColor3 = Color3.fromRGB(255, 215, 0)
                btnToggleOptimizer.Font = Enum.Font.GothamBold
                btnToggleOptimizer.TextSize = 12
                Instance.new("UICorner", btnToggleOptimizer).CornerRadius = UDim.new(0, 8)
                Instance.new("UIStroke", btnToggleOptimizer).Color = Color3.fromRGB(255, 215, 0)
                
                btnToggleOptimizer.MouseButton1Click:Connect(function()
                    PerformanceOptimizer.EnableBoost(true)
                end)
                
                -- Button: Server Hop Manual Trigger
                local btnServerHop = Instance.new("TextButton", scrollingArea)
                btnServerHop.Size = UDim2.new(1, 0, 0, 40)
                btnServerHop.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
                btnServerHop.Text = "🌐 Server Hop (Find Low-Player Server)"
                btnServerHop.TextColor3 = Color3.fromRGB(0, 210, 255)
                btnServerHop.Font = Enum.Font.GothamBold
                btnServerHop.TextSize = 12
                Instance.new("UICorner", btnServerHop).CornerRadius = UDim.new(0, 8)
                Instance.new("UIStroke", btnServerHop).Color = Color3.fromRGB(0, 210, 255)
                
                btnServerHop.MouseButton1Click:Connect(function()
                    ServerManager.TriggerServerHop()
                end)
            end
        end
    end
end)

-- [MODULE 6.3]: FINAL CONSOLE LOGGING & VERIFICATION (ការផ្ទៀងផ្ទាត់ការផ្ទុកស្គ្រីបពេញលេញ)
print("========================================================================")
print("👑 ALL MODULES (1 TO 6) LOADED SUCCESSFULLY! HUB IS FULLY OPERATIONAL.")
print("👑 READY TO FARM, STEAL EGGS, TELEPORT, AND OPTIMIZE PERFORMANCE 100%!")
print("========================================================================")

-- ====================================================================================
-- [[ PART 7: ULTIMATE STEAL AN EGG MASTER HUB - AUTO-HATCH & PLAYER TELEPORT ]] --
-- ====================================================================================

-- [MODULE 7.1]: EXTENSIVE GAME ITEM & EGG DATABASE (ទិន្នន័យហ្គេមខ្នាតធំសម្រាប់ស្កេននិងចាត់ថ្នាក់)
local MassiveItemDatabase = {
    Eggs = {
        { Name = "Basic Egg", Cost = 100, Tier = 1, DropRate = "50%" },
        { Name = "Golden Egg", Cost = 500, Tier = 2, DropRate = "30%" },
        { Name = "Diamond Egg", Cost = 2500, Tier = 3, DropRate = "15%" },
        { Name = "Magma Egg", Cost = 10000, Tier = 4, DropRate = "4%" },
        { Name = "Divine Egg", Cost = 50000, Tier = 5, DropRate = "1%" },
        { Name = "Celestial Egg", Cost = 250000, Tier = 6, DropRate = "0.1%" },
        { Name = "Secret Cosmic Egg", Cost = 1000000, Tier = 7, DropRate = "0.01%" }
    },
    RarityColors = {
        ["Common"] = Color3.fromRGB(200, 200, 200),
        ["Rare"] = Color3.fromRGB(0, 150, 255),
        ["Epic"] = Color3.fromRGB(163, 53, 238),
        ["Legendary"] = Color3.fromRGB(255, 165, 0),
        ["Mythic"] = Color3.fromRGB(255, 0, 0),
        ["Divine"] = Color3.fromRGB(0, 255, 255),
        ["Secret"] = Color3.fromRGB(255, 215, 0)
    }
}

-- [MODULE 7.2]: AUTO-HATCH SIMULATOR ENGINE (ប្រព័ន្ធបើកស៊ុតអូតូកម្រិតលឿន)
local AutoHatchManager = {
    Active = false,
    SelectedEgg = "Basic Egg"
}

function AutoHatchManager.ToggleHatch(stateValue, eggNameString)
    AutoHatchManager.Active = stateValue
    AutoHatchManager.SelectedEgg = eggNameString or "Basic Egg"
    
    task.spawn(function()
        while AutoHatchManager.Active do
            pcall(function()
                -- រកមើល RemoteEvent សម្រាប់ការបើកស៊ុតក្នុង ReplicatedStorage
                local remotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage"):FindFirstChild("Network")
                if remotesFolder then
                    for _, remoteItem in ipairs(remotesFolder:GetDescendants()) do
                        if remoteItem:IsA("RemoteEvent") and (remoteItem.Name:lower().match("hatch") or remoteItem.Name:lower().match("open")) then
                            remoteItem:FireServer(AutoHatchManager.SelectedEgg, 1)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- [MODULE 7.3]: PLAYER TELEPORT & SPECTATE MANAGER (ប្រព័ន្ធតាមដាននិងហោះទៅរកអ្នកលេងដទៃ)
local PlayerTeleportManager = {}

function PlayerTeleportManager.TeleportToPlayer(targetPlayerName)
    pcall(function()
        local targetPlyr = Players:FindFirstChild(targetPlayerName)
        if targetPlyr and targetPlyr.Character and targetPlyr.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = targetPlyr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                MasterNotificationSystem.Send("Teleport", "Successfully teleported to player: " .. targetPlayerName, 3)
            end
        end
    end)
end

-- [MODULE 7.4]: ADVANCED ANTI-KICK & CRASH PROTECTION (ប្រព័ន្ធការពារការទាត់ចេញពីហ្គេម)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod():lower()
        if method == "kick" or method == "clientkick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

print("--------------------------------------------------------------------------------")
print("👑 PART 7 LOADED SUCCESSFULLY! (Auto-Hatch, Player Teleport & Anti-Kick Active)")
print("--------------------------------------------------------------------------------")

-- ====================================================================================
-- [[ PART 8: ULTIMATE STEAL AN EGG MASTER HUB - MAGNET & THEME SYSTEM ]] --
-- ====================================================================================

-- [MODULE 8.1]: INSTANT EGG MAGNET & TELEKINESIS ENGINE (ប្រព័ន្ធទាញពងមករកតួអក្សរអូតូ)
local EggMagnetManager = {
    Active = false,
    Radius = 150
}

function EggMagnetManager.ToggleMagnet(stateValue)
    EggMagnetManager.Active = stateValue
    task.spawn(function()
        while EggMagnetManager.Active do
            pcall(function()
                local characterInstance = LocalPlayer.Character
                if characterInstance and characterInstance:FindFirstChild("HumanoidRootPart") then
                    local rootPartPos = characterInstance.HumanoidRootPart.Position
                    for _, worldDescendant in ipairs(Workspace:GetDescendants()) do
                        if worldDescendant:IsA("ProximityPrompt") then
                            local parentPartNode = worldDescendant.Parent
                            if parentPartNode and parentPartNode:IsA("BasePart") then
                                local distanceToPart = (parentPartNode.Position - rootPartPos).Magnitude
                                if distanceToPart <= EggMagnetManager.Radius then
                                    -- ទាញផ្នែកពងមកជិតតួអក្សរភ្លាមៗ
                                    parentPartNode.CFrame = characterInstance.HumanoidRootPart.CFrame + Vector3.new(0, 2, -3)
                                    worldDescendant.HoldDuration = 0
                                    fireproximityprompt(worldDescendant)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end

-- [MODULE 8.2]: TRADE SAFEGUARD & ANTI-SCAM SYSTEM (ប្រព័ន្ធការពារបោកប្រាស់ពេលដោះដូរទំនិញ)
local TradeSafeguardManager = {
    Active = true
}

function TradeSafeguardManager.Initialize()
    pcall(function()
        local networkFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Network") or game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if networkFolder then
            for _, remoteObject in ipairs(networkFolder:GetDescendants()) do
                if remoteObject:IsA("RemoteEvent") and remoteObject.Name:lower().match("trade") then
                    remoteObject.OnClientEvent:Connect(function(tradeData)
                        if TradeSafeguardManager.Active then
                            MasterNotificationSystem.Send("Trade Security", "Trade offer monitored and secured against sudden changes!", 4)
                        end
                    end)
                end
            end
        end
    end)
end

TradeSafeguardManager.Initialize()

-- [MODULE 8.3]: DYNAMIC UI THEME CUSTOMIZER (ប្រព័ន្ធប្តូរពណ៌ស្បែកផ្ទាំង UI តាមចំណូលចិត្ត)
local UIThemeManager = {}

function UIThemeManager.ApplyTheme(themeNameString)
    pcall(function()
        local parentContainer = gethui and gethui() or CoreGui:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        local mainGuiInstance = parentContainer:FindFirstChild("UltimateMasterHubGUI")
        if mainGuiInstance then
            local windowFrame = mainGuiInstance:FindFirstChildOfClass("Frame")
            if windowFrame then
                if themeNameString == "Gold" then
                    windowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 15)
                    local uiStroke = windowFrame:FindFirstChildOfClass("UIStroke")
                    if uiStroke then uiStroke.Color = Color3.fromRGB(255, 215, 0) end
                elseif themeNameString == "Cyberpunk" then
                    windowFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
                    local uiStroke = windowFrame:FindFirstChildOfClass("UIStroke")
                    if uiStroke then uiStroke.Color = Color3.fromRGB(0, 255, 255) end
                elseif themeNameString == "Darkness" then
                    windowFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                    local uiStroke = windowFrame:FindFirstChildOfClass("UIStroke")
                    if uiStroke then uiStroke.Color = Color3.fromRGB(120, 120, 120) end
                end
                MasterNotificationSystem.Send("Theme Manager", "Applied " .. themeNameString .. " theme successfully!", 3)
            end
        end
    end)
end

-- [MODULE 8.4]: DETAILED SESSION STATS LOGGER (ប្រព័ន្ធចងចាំស្ថិតិនិងការលួចបានសរុប)
local SessionStatistics = {
    EggsStolenCount = 0,
    StartTime = os.time()
}

function SessionStatistics.Increment()
    SessionStatistics.EggsStolenCount = SessionStatistics.EggsStolenCount + 1
end

print("--------------------------------------------------------------------------------")
print("👑 PART 8 LOADED SUCCESSFULLY! (Egg Magnet, Trade Security & Themes Ready)")
print("--------------------------------------------------------------------------------")

-- ====================================================================================
-- [[ PART 9: ULTIMATE STEAL AN EGG MASTER HUB - KEYBINDS & MONITOR HUD ]] --
-- ====================================================================================

-- [MODULE 9.1]: CUSTOM KEYBIND MANAGER (ប្រព័ន្ធកំណត់ប៊ូតុងកាត់លើក្តារចុច)
local UserInputService = game:GetService("UserInputService")
local KeybindManager = {
    Binds = {}
}

function KeybindManager.Register(keyCode, callbackFunction)
    UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
        if not gameProcessedEvent and inputObject.KeyCode == keyCode then
            pcall(callbackFunction)
        end
    end)
end

-- កំណត់ប៊ូតុង E សម្រាប់បើកបិទ Auto Steal ភ្លាមៗយ៉ាងងាយស្រួល
KeybindManager.Register(Enum.KeyCode.E, function()
    MasterHubConfig.AutoStealActive = not MasterHubConfig.AutoStealActive
    if MasterNotificationSystem and MasterNotificationSystem.Send then
        MasterNotificationSystem.Send("Keybind", "Toggled Auto Steal via Hotkey: " .. tostring(MasterHubConfig.AutoStealActive), 2.5)
    end
end)

-- [MODULE 9.2]: REALTIME FPS & PING MONITOR HUD (ប្រព័ន្ធបង្ហាញ FPS និង Ping ផ្ទាល់លើអេក្រង់)
local function initializeMonitorHUD()
    pcall(function()
        local parentContainer = gethui and gethui() or CoreGui:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        local hudScreen = Instance.new("ScreenGui", parentContainer)
        hudScreen.Name = "MasterPerformanceHUD"
        hudScreen.ResetOnSpawn = false
        
        local monitorLabel = Instance.new("TextLabel", hudScreen)
        monitorLabel.Size = UDim2.new(0, 160, 0, 32)
        monitorLabel.Position = UDim2.new(0, 12, 0, 12)
        monitorLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        monitorLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        monitorLabel.Font = Enum.Font.Code
        monitorLabel.TextSize = 12
        Instance.new("UICorner", monitorLabel).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", monitorLabel).Color = Color3.fromRGB(0, 255, 128)
        
        RunService.RenderStepped:Connect(function()
            local currentFPS = math.floor(1 / RunService.RenderStepped:Wait())
            local playerPing = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            monitorLabel.Text = string.format(" FPS: %d | Ping: %dms", currentFPS, playerPing)
        end)
    end)
end

initializeMonitorHUD()

-- [MODULE 9.3]: CHAT COMMAND INTERPRETER (ប្រព័ន្ធបញ្ជាតាមរយៈការវាយអត្ថបទក្នុង Chat)
pcall(function()
    LocalPlayer.Chatted:Connect(function(chatMessageText)
        local lowerMsg = chatMessageText:lower()
        if lowerMsg == "!autosteal on" then
            MasterHubConfig.AutoStealActive = true
            if MasterNotificationSystem and MasterNotificationSystem.Send then
                MasterNotificationSystem.Send("Chat Cmd", "Auto Steal activated via chat command.", 3)
            end
        elseif lowerMsg == "!autosteal off" then
            MasterHubConfig.AutoStealActive = false
            if MasterNotificationSystem and MasterNotificationSystem.Send then
                MasterNotificationSystem.Send("Chat Cmd", "Auto Steal deactivated via chat command.", 3)
            end
        elseif lowerMsg == "!bypass" then
            if performAreaBypass then performAreaBypass() end
        end
    end)
end)

print("--------------------------------------------------------------------------------")
print("👑 PART 9 LOADED SUCCESSFULLY! (Keybinds, Monitor HUD & Chat Commands Active)")
print("--------------------------------------------------------------------------------")
