-- ====================================================================================
-- [[ ULTIMATE STEAL AN EGG: UNLOCKED ALL BIOMES & EXPANDED RANGE ]] --
-- ====================================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local guiParent = gethui and gethui() or CoreGui:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

if guiParent:FindFirstChild("StealAnEggExpandedUI") then
    guiParent.StealAnEggExpandedUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggExpandedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent

local colors = {
    bg = Color3.fromRGB(15, 15, 20),
    card = Color3.fromRGB(24, 24, 32),
    blue = Color3.fromRGB(0, 210, 255),
    purple = Color3.fromRGB(138, 43, 226),
    text = Color3.fromRGB(255, 255, 255),
    green = Color3.fromRGB(46, 204, 113),
    yellow = Color3.fromRGB(255, 215, 0)
}

-- Floating Button (⚡)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = colors.bg
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0.5, 0)
Instance.new("UIStroke", OpenBtn).Color = colors.purple

-- Main Menu (ScrollingFrame)
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = colors.bg
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Parent = ScreenGui
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 950)
MainFrame.ScrollBarThickness = 4
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = colors.blue

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding", MainFrame)
UIPadding.PaddingTop = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -20, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "⚡ UNLOCKED ALL BIOMES & EXPANDED RANGE"
Title.TextColor3 = colors.blue
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10

-- Config State
local Config = {
    AutoSteal = false,
    FlightSpeed = 400,
    MaxFlyRadius = 3000, -- ពង្រីកចម្ងាយពី 160 ទៅ 3000 ដើម្បីឱ្យដល់តំបន់ឆ្ងាយៗ
    SelectedBiomes = {
        ["All"] = true,
        ["Forest"] = false,
        ["Lake"] = false,
        ["Desert"] = false,
        ["Jungle"] = false,
        ["Snow"] = false,
        ["Volcano"] = false,
        ["Abyss Ocean"] = false,
        ["Prehistoric"] = false,
        ["Cosmic"] = false,
        ["Cherry Blossom"] = false,
        ["Titan Temple"] = false,
        ["Brainrot Eggs"] = false,
        ["Monster Eggs"] = false,
        ["Rift Eggs"] = false
    }
}

-- 🏆 តារាងកម្រិតភាពកម្រ (Rarity Tiers)
local rarityWeights = {
    ["divine"] = 10,
    ["eternal"] = 9,
    ["secret"] = 8,
    ["cosmic"] = 7,
    ["mythic"] = 6,
    ["legendary"] = 5,
    ["epic"] = 4,
    ["rare"] = 3,
    ["uncommon"] = 2,
    ["common"] = 1
}

-- អនុគមន៍បម្លែងតម្លៃ Money/s
local function parseMoneyValue(text)
    if not text then return 0 end
    text = text:lower()
    local num = 0
    
    local val = text:match("(%d+%.?%d*)%s*k")
    if val then num = tonumber(val) * 1e3 end
    
    val = text:match("(%d+%.?%d*)%s*m")
    if val then num = tonumber(val) * 1e6 end
    
    val = text:match("(%d+%.?%d*)%s*b")
    if val then num = tonumber(val) * 1e9 end
    
    val = text:match("(%d+%.?%d*)%s*t")
    if val then num = tonumber(val) * 1e12 end
    
    if num == 0 then
        local rawNum = text:match("(%d+)")
        if rawNum then num = tonumber(rawNum) end
    end
    
    return num
end

-- 🚀 Speed TextBox (10 - 1000)
local SpeedFrame = Instance.new("Frame", MainFrame)
SpeedFrame.Size = UDim2.new(1, -30, 0, 38)
SpeedFrame.BackgroundColor3 = colors.card
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SpeedFrame).Color = colors.blue

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Size = UDim2.new(0.65, 0, 1, 0)
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "✈️ Speed (10 - 1000):"
SpeedLabel.TextColor3 = colors.text
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 11
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedBox = Instance.new("TextBox", SpeedFrame)
SpeedBox.Size = UDim2.new(0, 70, 0, 24)
SpeedBox.Position = UDim2.new(1, -80, 0.5, -12)
SpeedBox.BackgroundColor3 = colors.bg
SpeedBox.Text = tostring(Config.FlightSpeed)
SpeedBox.TextColor3 = colors.yellow
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 12
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", SpeedBox).Color = colors.yellow

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val then
        val = math.clamp(val, 10, 1000)
        Config.FlightSpeed = val
        SpeedBox.Text = tostring(val)
    else
        SpeedBox.Text = tostring(Config.FlightSpeed)
    end
end)

-- 🌐 Max Fly Radius TextBox (ចម្ងាយហោះទៅតំបន់ផ្សេងៗ)
local RadiusFrame = Instance.new("Frame", MainFrame)
RadiusFrame.Size = UDim2.new(1, -30, 0, 38)
RadiusFrame.BackgroundColor3 = colors.card
Instance.new("UICorner", RadiusFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RadiusFrame).Color = colors.purple

local RadiusLabel = Instance.new("TextLabel", RadiusFrame)
RadiusLabel.Size = UDim2.new(0.65, 0, 1, 0)
RadiusLabel.Position = UDim2.new(0, 10, 0, 0)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "🌐 Max Range (Fly Distance):"
RadiusLabel.TextColor3 = colors.text
RadiusLabel.Font = Enum.Font.GothamSemibold
RadiusLabel.TextSize = 11
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left

local RadiusBox = Instance.new("TextBox", RadiusFrame)
RadiusBox.Size = UDim2.new(0, 70, 0, 24)
RadiusBox.Position = UDim2.new(1, -80, 0.5, -12)
RadiusBox.BackgroundColor3 = colors.bg
RadiusBox.Text = tostring(Config.MaxFlyRadius)
RadiusBox.TextColor3 = colors.yellow
RadiusBox.Font = Enum.Font.GothamBold
RadiusBox.TextSize = 12
Instance.new("UICorner", RadiusBox).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", RadiusBox).Color = colors.yellow

RadiusBox.FocusLost:Connect(function()
    local val = tonumber(RadiusBox.Text)
    if val then
        Config.MaxFlyRadius = math.clamp(val, 100, 10000)
        RadiusBox.Text = tostring(Config.MaxFlyRadius)
    else
        RadiusBox.Text = tostring(Config.MaxFlyRadius)
    end
end)

-- 📌 Set Safe Zone / Center Position
local SetBaseBtn = Instance.new("TextButton", MainFrame)
SetBaseBtn.Size = UDim2.new(1, -30, 0, 35)
SetBaseBtn.BackgroundColor3 = colors.card
SetBaseBtn.Text = "📌 Set Center Safe Zone"
SetBaseBtn.TextColor3 = colors.yellow
SetBaseBtn.Font = Enum.Font.GothamBold
SetBaseBtn.TextSize = 11
Instance.new("UICorner", SetBaseBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", SetBaseBtn).Color = colors.yellow

local savedBaseCFrame = nil
SetBaseBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedBaseCFrame = char.HumanoidRootPart.CFrame
        SetBaseBtn.Text = "📌 Center Locked Successfully!"
        task.delay(1.5, function()
            SetBaseBtn.Text = "📌 Set Center Safe Zone"
        end)
    end
end)

-- Toggle Auto Steal
local ToggleFrame = Instance.new("Frame", MainFrame)
ToggleFrame.Size = UDim2.new(1, -30, 0, 40)
ToggleFrame.BackgroundColor3 = colors.card
Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Auto Steal (All Biomes Unlocked)"
ToggleLabel.TextColor3 = colors.text
ToggleLabel.Font = Enum.Font.GothamSemibold
ToggleLabel.TextSize = 11
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleBtn = Instance.new("TextButton", ToggleFrame)
ToggleBtn.Size = UDim2.new(0, 36, 0, 18)
ToggleBtn.Position = UDim2.new(1, -48, 0.5, -9)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Text = ""
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Checkbox Header
local CheckboxHeader = Instance.new("TextLabel", MainFrame)
CheckboxHeader.Size = UDim2.new(1, -30, 0, 24)
CheckboxHeader.BackgroundTransparency = 1
CheckboxHeader.Text = "🗺 Select Biomes & Egg Types:"
CheckboxHeader.TextColor3 = colors.yellow
CheckboxHeader.Font = Enum.Font.GothamBold
CheckboxHeader.TextSize = 11
CheckboxHeader.TextXAlignment = Enum.TextXAlignment.Left

-- Checkboxes for All Biomes from Guide
local biomesList = {
    "All", "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano", 
    "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", 
    "Titan Temple", "Brainrot Eggs", "Monster Eggs", "Rift Eggs"
}

for _, biomeName in ipairs(biomesList) do
    local cbRow = Instance.new("Frame", MainFrame)
    cbRow.Size = UDim2.new(1, -30, 0, 30)
    cbRow.BackgroundColor3 = colors.card
    Instance.new("UICorner", cbRow).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", cbRow)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "• " .. biomeName
    lbl.TextColor3 = colors.text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextButton", cbRow)
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(1, -28, 0.5, -10)
    box.BackgroundColor3 = (Config.SelectedBiomes[biomeName] and colors.green or Color3.fromRGB(50, 50, 50))
    box.Text = Config.SelectedBiomes[biomeName] and "✓" or ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box.MouseButton1Click:Connect(function()
        Config.SelectedBiomes[biomeName] = not Config.SelectedBiomes[biomeName]
        box.BackgroundColor3 = Config.SelectedBiomes[biomeName] and colors.green or Color3.fromRGB(50, 50, 50)
        box.Text = Config.SelectedBiomes[biomeName] and "✓" or ""
    end)
end

-- Stable Noclip & Anti-Fling Setup
local noclipConn = nil
local function setNoclip(state)
    pcall(function()
        if state then
            if not noclipConn then
                noclipConn = RunService.Stepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end)
            end
        else
            if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end)
end

-- 🚀 Strict Bounded Flight Function
local function flyToStrictTarget(targetCF)
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        
        local targetPos = targetCF.Position + Vector3.new(0, 4, 0)
        
        if savedBaseCFrame then
            local basePos = savedBaseCFrame.Position
            local offset = targetPos - basePos
            if offset.Magnitude > Config.MaxFlyRadius then
                offset = offset.Unit * Config.MaxFlyRadius
                targetPos = basePos + offset
            end
        end
        
        local currentPos = root.Position
        local distance = (currentPos - targetPos).Magnitude
        local speed = math.clamp(Config.FlightSpeed, 10, 1000)
        
        if distance > 100 and speed > 350 then
            local steps = math.ceil(distance / 120)
            for i = 1, steps do
                local alpha = i / steps
                root.CFrame = CFrame.new(currentPos:Lerp(targetPos, alpha))
                task.wait(0.01)
            end
        else
            local timeTaken = distance / speed
            local tween = TweenService:Create(root, TweenInfo.new(timeTaken, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

-- 🔍 ពិនិត្យពាក្យ "Drop" ពេលកាន់ពងលើដៃ
local function hasDropAction()
    local hasDrop = false
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local action = v.ActionText:lower()
                if action:match("drop") or action:match("^drop$") then
                    hasDrop = true
                    break
                end
            end
        end
        local char = LocalPlayer.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") and item.Name:lower():match("drop") then
                    hasDrop = true
                end
            end
        end
    end)
    return hasDrop
end

local connection = nil
local loopTask = nil

ToggleBtn.MouseButton1Click:Connect(function()
    Config.AutoSteal = not Config.AutoSteal
    ToggleBtn.BackgroundColor3 = Config.AutoSteal and colors.green or Color3.fromRGB(50, 50, 50)
    setNoclip(Config.AutoSteal)

    if Config.AutoSteal then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and not savedBaseCFrame then
            savedBaseCFrame = char.HumanoidRootPart.CFrame
        end

        connection = Workspace.DescendantAdded:Connect(function(v)
            if Config.AutoSteal and v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                v.RequiresLineOfSight = false
            end
        end)

        loopTask = task.spawn(function()
            while Config.AutoSteal do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        if not savedBaseCFrame then savedBaseCFrame = root.CFrame end

                        local availableEggs = {}

                        -- 🔬 Scan All Biomes & Distances
                        for _, v in ipairs(Workspace:GetDescendants()) do
                            if v:IsA("ProximityPrompt") then
                                local action = v.ActionText:lower()
                                local objText = v.ObjectText:lower()
                                if action:match("steal") or action:match("egg") or objText:match("egg") then
                                    v.HoldDuration = 0
                                    v.RequiresLineOfSight = false

                                    local parentPart = v.Parent
                                    if parentPart and parentPart:IsA("BasePart") then
                                        local distFromBase = (parentPart.Position - savedBaseCFrame.Position).Magnitude
                                        if distFromBase <= Config.MaxFlyRadius then
                                            local pName = (parentPart.Parent and parentPart.Parent.Name or "")
                                            local fullText = (v.ObjectText .. " " .. v.ActionText .. " " .. parentPart.Name .. " " .. pName):lower()

                                            local foundMoneyValue = 0
                                            local foundRarityScore = 1

                                            for _, desc in ipairs(parentPart:GetDescendants()) do
                                                if desc:IsA("TextLabel") then
                                                    local labelText = desc.Text
                                                    local parsed = parseMoneyValue(labelText)
                                                    if parsed > foundMoneyValue then
                                                        foundMoneyValue = parsed
                                                    end
                                                end
                                            end

                                            for rName, score in pairs(rarityWeights) do
                                                if fullText:match(rName) then
                                                    foundRarityScore = math.max(foundRarityScore, score)
                                                end
                                            end

                                            local shouldSteal = false
                                            if Config.SelectedBiomes["All"] then
                                                shouldSteal = true
                                            else
                                                for biomeName, isSelected in pairs(Config.SelectedBiomes) do
                                                    if isSelected and biomeName ~= "All" then
                                                        if fullText:match(biomeName:lower()) then
                                                            shouldSteal = true
                                                            break
                                                        end
                                                    end
                                                end
                                            end

                                            if shouldSteal then
                                                local finalScore = (foundMoneyValue > 0) and foundMoneyValue or (foundRarityScore * 1e5)

                                                table.insert(availableEggs, {
                                                    prompt = v,
                                                    part = parentPart,
                                                    score = finalScore,
                                                    dist = distFromBase
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        -- 📊 តម្រៀបពងតម្លៃខ្ពស់មកមុនគេ ទោះបីនៅឆ្ងាយក៏ដោយ
                        table.sort(availableEggs, function(a, b)
                            if a.score ~= b.score then
                                return a.score > b.score
                            else
                                return a.dist < b.dist
                            end
                        end)

                        -- ⚡ ហោះទៅយកពងតាមលំដាប់តំបន់ទាំងអស់
                        if #availableEggs > 0 then
                            for _, eggData in ipairs(availableEggs) do
                                if not Config.AutoSteal then break end
                                if eggData.prompt and eggData.prompt.Parent and eggData.part then
                                    flyToStrictTarget(eggData.part.CFrame)
                                    task.wait(0.02)
                                    fireproximityprompt(eggData.prompt)
                                    task.wait(0.05)

                                    if hasDropAction() or savedBaseCFrame then
                                        flyToStrictTarget(savedBaseCFrame)
                                        task.wait(0.1)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    else
        if connection then connection:Disconnect() end
        if loopTask then task.cancel(loopTask) end
    end
end)

print("⚡ All Biomes Unlocked & Expanded Stealer Loaded Successfully!")
