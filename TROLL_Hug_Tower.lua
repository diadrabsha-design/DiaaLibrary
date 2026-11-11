-- ============================================================
-- Troll Hug Tower | Vortex UI | Delta Executor (Mobile)
-- ============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ============================================================
-- ✅ الدالة الأساسية للمسك
-- ============================================================
local function fireGrab(playerName)
    local args = {
        "tryGrab",
        game:GetService("Players"):WaitForChild(playerName).Character
    }
    game:GetService("ReplicatedStorage"):WaitForChild("HugRemotes"):WaitForChild("HugRequest"):FireServer(unpack(args))
end

-- ============================================================
-- ✅ دالة الكومبو المزعج (طيران + رمية + رجوع)
-- ============================================================
local function executeTrollCombo(targetName)
    if not targetName then return end
    local ok, err = pcall(fireGrab, targetName)
    if not ok then return end
    task.wait(0.2)
    
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local originalCFrame = root.CFrame
    local TARGET_Y = 1e308
    local SPEED = 56000000000000
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not root.Parent then
            if connection then connection:Disconnect() end
            return
        end
        if root.Position.Y >= TARGET_Y then
            root.AssemblyLinearVelocity = Vector3.zero
            if connection then connection:Disconnect() end
            return
        end
        root.AssemblyLinearVelocity = Vector3.new(0, SPEED, 0)
    end)
    
    task.wait(0.5)
    
    if root and root.Parent then root.AssemblyLinearVelocity = Vector3.zero end
    if connection then connection:Disconnect() end
    
    local args = { "throw" }
    game:GetService("ReplicatedStorage"):WaitForChild("HugRemotes"):WaitForChild("HugRequest"):FireServer(unpack(args))
    task.wait(0.2)
    
    if root and root.Parent then root.CFrame = originalCFrame end
end

-- ============================================================
-- Helpers
-- ============================================================
local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(names, p.Name) end
    end
    return names
end

local function getNearestPlayerWithin(maxDist)
    local myChar = LP.Character
    if not myChar then return nil end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local nearest, nearestDist = nil, maxDist
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d <= nearestDist then
                    nearestDist = d
                    nearest = p
                end
            end
        end
    end
    return nearest
end

-- ============================================================
-- تحميل المكتبة
-- ============================================================
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/diadrabsha-design/Vortex-UI/refs/heads/main/Vortex.Luau"
))()

-- ============================================================
-- النافذة والتبويب
-- ============================================================
local Window = Library:CreateWindow({
    Title = "Troll Hug Tower",
    Subtitle = "Vortex UI",
    Size = UDim2.fromOffset(500, 420),
})

local Tab = Window:CreateTab("Main")

-- ============================================================
-- 1) اختيار لاعب
-- ============================================================
local selectedPlayer = nil
local playerDropdown

playerDropdown = Tab:CreateDropdown({
    Name = "اختر لاعب",
    Options = getPlayerNames(),
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(option)
        if type(option) == "table" then
            selectedPlayer = option[1]
        else
            selectedPlayer = option
        end
    end,
})

Players.PlayerAdded:Connect(function()
    task.wait(1)
    pcall(function() playerDropdown:Refresh(getPlayerNames()) end)
end)
Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    pcall(function() playerDropdown:Refresh(getPlayerNames()) end)
end)

-- ============================================================
-- 2) زر المسك العادي
-- ============================================================
Tab:CreateButton({
    Name = "🤗 مسك اللاعب المختار",
    Callback = function()
        if selectedPlayer then pcall(fireGrab, selectedPlayer) end
    end,
})

-- ============================================================
-- 3) الزر الوهمي (يمسك فقط)
-- ============================================================
Tab:CreateButton({
    Name = "📊 تحديث إحصائيات اللاعب",
    Callback = function()
        if selectedPlayer then pcall(fireGrab, selectedPlayer) end
    end,
})

-- ============================================================
-- 4) المسك العشوائي
-- ============================================================
local randomActive = false
local randomThread = nil

Tab:CreateToggle({
    Name = "🎲 المسك العشوائي",
    CurrentValue = false,
    Callback = function(v)
        randomActive = v
        if v then
            randomThread = task.spawn(function()
                while randomActive do
                    local names = getPlayerNames()
                    if #names > 0 then
                        local pick = names[math.random(1, #names)]
                        pcall(fireGrab, pick)
                    end
                    task.wait(0.7)
                end
            end)
        else
            if randomThread then
                task.cancel(randomThread)
                randomThread = nil
            end
        end
    end,
})

-- ============================================================
-- 5) المسك عن بعد
-- ============================================================
local remoteActive = false
local remoteDistance = 30

Tab:CreateToggle({
    Name = "🎯 المسك عن بعد",
    CurrentValue = false,
    Callback = function(v) remoteActive = v end,
})

Tab:CreateSlider({
    Name = "المسافة",
    Range = {0, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 30,
    Callback = function(v) remoteDistance = v end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not remoteActive then return end
    if input.UserInputType ~= Enum.UserInputType.Touch
    and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

    local target = getNearestPlayerWithin(remoteDistance)
    if target then pcall(fireGrab, target.Name) end
end)

-- ============================================================
-- 6) الزر الطويل (تحت آخر شي) - كومبو الطيران
-- ============================================================
Tab:CreateButton({
    Name = "اعطيه واجهة اتصال (مزعج جدا لدرجة يضطر يطلع ويدخل اللعبة لكي ينفك عنه)",
    Callback = function()
        if selectedPlayer then
            task.spawn(executeTrollCombo, selectedPlayer)
        end
    end,
})

-- ============================================================
-- إشعار بدء
-- ============================================================
Library:Notify({Title = "Troll Hug Tower", Content = "تم التحميل بنجاح ✅", Duration = 4})
