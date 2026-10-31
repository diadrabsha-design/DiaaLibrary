--[[
    ╔══════════════════════════════════════════════════════════════════════════════════╗
    ║                                 D I A A   U I                                    ║
    ║                   Universal Engine — Version 6.0.0                               ║
    ║                                                                                  ║
    ║                                   By Diaa                                        ║
    ╚══════════════════════════════════════════════════════════════════════════════════╝
    
    100% متوافق مع منفذ Delta وجميع هواتف الأندرويد والآيفون وروبلوكس ستوديو
    خالٍ تماماً من أخطاء السنتاكس ويدعم إضافة الأزرار والتوجلز والقوائم بأبسط كود
    
    Created By Diaa (2026 Edition)
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end

-- 1. كاشف الحاوية الآمنة لجميع المنفذين بدون استثناء
local function GetSafeGuiContainer()
    local success, hui = pcall(function()
        local g = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
        return g
    end)
    if success and hui then
        return hui
    end

    local cgSuccess, cg = pcall(function()
        return game:GetService("CoreGui")
    end)
    if cgSuccess and cg and not RunService:IsStudio() then
        local writeSuccess = pcall(function()
            local test = Instance.new("Folder")
            test.Parent = cg
            test:Destroy()
        end)
        if writeSuccess then
            return cg
        end
    end

    local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    return pGui or game:GetService("CoreGui")
end

local Container = GetSafeGuiContainer()

-- إزالة أي نسخة قديمة لتجنب التكرار
local existing = Container:FindFirstChild("DiaaUI_UniversalContainer")
if existing then
    existing:Destroy()
end

local DiaaUI = {
    Version = "6.0.0",
    Author = "Diaa",
    Flags = {},
    Connections = {},
    Themes = {
        Obsidian = {
            Accent = Color3.fromRGB(56, 189, 248),
            Background = Color3.fromRGB(10, 14, 22),
            Surface = Color3.fromRGB(17, 24, 39),
            SurfaceHover = Color3.fromRGB(24, 34, 56),
            Border = Color3.fromRGB(37, 51, 78),
            Text = Color3.fromRGB(241, 245, 249),
            TextMuted = Color3.fromRGB(148, 163, 184)
        }
    }
}

local function SpringTween(instance, duration, properties, easingStyle, easingDirection)
    local info = TweenInfo.new(
        duration,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(instance, info, properties)
    t:Play()
    return t
end

-- الشاشة الحاضنة الأساسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DiaaUI_UniversalContainer"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Container

-- نظام الإشعارات
local ToastHolder = Instance.new("Frame")
ToastHolder.Name = "Diaa_ToastHolder"
ToastHolder.Size = UDim2.new(0, 310, 1, -70)
ToastHolder.Position = UDim2.new(1, -320, 0, 35)
ToastHolder.BackgroundTransparency = 1
ToastHolder.Parent = ScreenGui

local ToastList = Instance.new("UIListLayout")
ToastList.SortOrder = Enum.SortOrder.LayoutOrder
ToastList.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastList.Padding = UDim.new(0, 8)
ToastList.Parent = ToastHolder

function DiaaUI:Notify(options)
    local title = options.Title or "DiaaUI"
    local content = options.Content or ""
    local duration = options.Duration or 3.5

    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(1, 0, 0, 68)
    Toast.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
    Toast.BorderSizePixel = 0
    Toast.BackgroundTransparency = 1
    Toast.ClipsDescendants = true

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 10)
    TCorner.Parent = Toast

    local TStroke = Instance.new("UIStroke")
    TStroke.Color = Color3.fromRGB(56, 189, 248)
    TStroke.Thickness = 1.2
    TStroke.Transparency = 1
    TStroke.Parent = Toast

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Toast

    local TTitle = Instance.new("TextLabel")
    TTitle.Text = title
    TTitle.Font = Enum.Font.GothamBold
    TTitle.TextSize = 13
    TTitle.TextColor3 = Color3.fromRGB(248, 250, 252)
    TTitle.Size = UDim2.new(1, -60, 0, 18)
    TTitle.Position = UDim2.new(0, 14, 0, 10)
    TTitle.BackgroundTransparency = 1
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.Parent = Toast

    local TBy = Instance.new("TextLabel")
    TBy.Text = "By Diaa"
    TBy.Font = Enum.Font.GothamBold
    TBy.TextSize = 10
    TBy.TextColor3 = Color3.fromRGB(56, 189, 248)
    TBy.Size = UDim2.new(0, 50, 0, 18)
    TBy.Position = UDim2.new(1, -56, 0, 10)
    TBy.BackgroundTransparency = 1
    TBy.TextXAlignment = Enum.TextXAlignment.Right
    TBy.Parent = Toast

    local TDesc = Instance.new("TextLabel")
    TDesc.Text = content
    TDesc.Font = Enum.Font.Gotham
    TDesc.TextSize = 11
    TDesc.TextColor3 = Color3.fromRGB(148, 163, 184)
    TDesc.Size = UDim2.new(1, -24, 0, 28)
    TDesc.Position = UDim2.new(0, 14, 0, 28)
    TDesc.BackgroundTransparency = 1
    TDesc.TextXAlignment = Enum.TextXAlignment.Left
    TDesc.TextWrapped = true
    TDesc.Parent = Toast

    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(1, 0, 0, 2)
    Progress.Position = UDim2.new(0, 0, 1, -2)
    Progress.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
    Progress.BorderSizePixel = 0
    Progress.Parent = Toast

    Toast.Parent = ToastHolder
    SpringTween(Toast, 0.3, {BackgroundTransparency = 0.05})
    SpringTween(TStroke, 0.3, {Transparency = 0.4})
    SpringTween(Progress, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        SpringTween(Toast, 0.25, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
        SpringTween(TStroke, 0.25, {Transparency = 1})
        task.wait(0.3)
        Toast:Destroy()
    end)
end

-- بناء النافذة الرئيسية
local Window = {}
Window.__index = Window

function DiaaUI:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)
    local theme = DiaaUI.Themes.Obsidian
    local toggleKey = config.Keybind or Enum.KeyCode.RightControl
    local showMobileToggle = true
    if config.MobileToggle ~= nil then
        showMobileToggle = config.MobileToggle
    end

    self.Theme = theme
    self.Tabs = {}
    self.AllElements = {}
    self.Visible = true

    local cam = workspace.CurrentCamera
    local viewport = Vector2.new(800, 600)
    if cam and cam.ViewportSize then
        viewport = cam.ViewportSize
    end
    local winW = math.clamp(viewport.X - 26, 310, 560)
    local winH = math.clamp(viewport.Y - 36, 250, 360)

    local Main = Instance.new("Frame")
    Main.Name = "DiaaWindow"
    Main.Size = UDim2.new(0, winW, 0, winH)
    Main.Position = UDim2.new(0.5, -math.floor(winW/2), 0.5, -math.floor(winH/2))
    Main.BackgroundColor3 = theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = false
    Main.Parent = ScreenGui

    local MCorner = Instance.new("UICorner")
    MCorner.CornerRadius = UDim.new(0, 12)
    MCorner.Parent = Main

    local MStroke = Instance.new("UIStroke")
    MStroke.Color = theme.Border
    MStroke.Thickness = 1.3
    MStroke.Parent = Main
    self.Main = Main

    -- رأس النافذة
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 48)
    Header.BackgroundColor3 = theme.Surface
    Header.BorderSizePixel = 0
    Header.Parent = Main

    local HCorner = Instance.new("UICorner")
    HCorner.CornerRadius = UDim.new(0, 12)
    HCorner.Parent = Header

    local HMask = Instance.new("Frame")
    HMask.Size = UDim2.new(1, 0, 0, 14)
    HMask.Position = UDim2.new(0, 0, 1, -14)
    HMask.BackgroundColor3 = theme.Surface
    HMask.BorderSizePixel = 0
    HMask.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Text = config.Title or "Diaa Luxury Hub"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = theme.Text
    Title.Size = UDim2.new(0, 180, 0, 20)
    Title.Position = UDim2.new(0, 14, 0, 8)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Text = config.Subtitle or "By Diaa"
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.TextSize = 11
    Subtitle.TextColor3 = theme.Accent
    Subtitle.Size = UDim2.new(0, 180, 0, 14)
    Subtitle.Position = UDim2.new(0, 14, 0, 26)
    Subtitle.BackgroundTransparency = 1
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    -- شريط البحث الفوري
    local SearchBox = Instance.new("TextBox")
    SearchBox.PlaceholderText = "🔍 Search..."
    SearchBox.Text = ""
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 11
    SearchBox.TextColor3 = theme.Text
    SearchBox.PlaceholderColor3 = theme.TextMuted
    SearchBox.BackgroundColor3 = theme.Background
    SearchBox.Size = UDim2.new(0, 115, 0, 26)
    SearchBox.Position = UDim2.new(1, -175, 0.5, -13)
    SearchBox.BorderSizePixel = 0
    SearchBox.Parent = Header

    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 6)
    SCorner.Parent = SearchBox

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "✕"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.TextColor3 = Color3.fromRGB(248, 113, 113)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    CloseBtn.BackgroundTransparency = 0.85
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = Header

    local CCorner = Instance.new("UICorner")
    CCorner.CornerRadius = UDim.new(0, 6)
    CCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function() self:Toggle() end)

    -- سحب النافذة باللمس على شاشة الهاتف والماوس
    local isDragging = false
    local dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- الشريط الجانبي
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 120, 1, -56)
    Sidebar.Position = UDim2.new(0, 8, 0, 50)
    Sidebar.BackgroundColor3 = theme.Surface
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = theme.Accent
    Sidebar.Parent = Main

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 8)
    SideCorner.Parent = Sidebar

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 6)
    SideLayout.Parent = Sidebar

    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 8)
    SidePadding.PaddingLeft = UDim.new(0, 6)
    SidePadding.PaddingRight = UDim.new(0, 6)
    SidePadding.Parent = Sidebar
    self.Sidebar = Sidebar

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -140, 1, -56)
    Content.Position = UDim2.new(0, 132, 0, 50)
    Content.BackgroundColor3 = theme.Surface
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Parent = Main

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = Content
    self.Content = Content

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = SearchBox.Text:lower()
        for _, elem in ipairs(self.AllElements) do
            elem.Frame.Visible = (q == "" or elem.Name:lower():find(q) ~= nil)
        end
    end)

    -- زر الهاتف العائم (⚡)
    if showMobileToggle then
        local MobBtn = Instance.new("TextButton")
        MobBtn.Name = "DiaaMobileFAB"
        MobBtn.Size = UDim2.new(0, 48, 0, 48)
        MobBtn.Position = UDim2.new(0, 20, 0.35, 0)
        MobBtn.BackgroundColor3 = theme.Background
        MobBtn.Text = "⚡"
        MobBtn.Font = Enum.Font.GothamBold
        MobBtn.TextSize = 22
        MobBtn.TextColor3 = theme.Accent
        MobBtn.BorderSizePixel = 0
        MobBtn.Parent = ScreenGui

        local MobCorner = Instance.new("UICorner")
        MobCorner.CornerRadius = UDim.new(1, 0)
        MobCorner.Parent = MobBtn

        local MobStroke = Instance.new("UIStroke")
        MobStroke.Color = theme.Accent
        MobStroke.Thickness = 1.8
        MobStroke.Parent = MobBtn

        local mDrag = false
        local mStart, mPos
        MobBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mDrag = true
                mStart = input.Position
                mPos = MobBtn.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if mDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - mStart
                MobBtn.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + delta.X, mPos.Y.Scale, mPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mDrag = false
            end
        end)

        MobBtn.MouseButton1Click:Connect(function() self:Toggle() end)
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            self:Toggle()
        end
    end)

    return self
end

function Window:Toggle()
    self.Visible = not self.Visible
    local winW = self.Main.AbsoluteSize.X
    local winH = self.Main.AbsoluteSize.Y

    if self.Visible then
        self.Main.Visible = true
        SpringTween(self.Main, 0.28, {Position = UDim2.new(0.5, -math.floor(winW/2), 0.5, -math.floor(winH/2))}, Enum.EasingStyle.Back)
    else
        local t = SpringTween(self.Main, 0.2, {Position = UDim2.new(0.5, -math.floor(winW/2), 0.5, -math.floor(winH/2) + 20)})
        t.Completed:Connect(function()
            if not self.Visible then self.Main.Visible = false end
        end)
    end
end

-- نظام التبويبات والعناصر المتعددة
local Tab = {}
Tab.__index = Tab

function Window:CreateTab(options)
    local selfTab = setmetatable({}, Tab)
    local name = (type(options) == "table" and options.Name) or options or "Tab"
    local theme = self.Theme

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = theme.Background
    Btn.BackgroundTransparency = 0.6
    Btn.Text = "  " .. name
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 12
    Btn.TextColor3 = theme.TextMuted
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Btn.Parent = self.Sidebar

    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = Btn

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = theme.Accent
    Scroll.Visible = false
    Scroll.Parent = self.Content

    local SLayout = Instance.new("UIListLayout")
    SLayout.Padding = UDim.new(0, 6)
    SLayout.Parent = Scroll

    local SPad = Instance.new("UIPadding")
    SPad.PaddingTop = UDim.new(0, 8)
    SPad.PaddingBottom = UDim.new(0, 8)
    SPad.PaddingLeft = UDim.new(0, 10)
    SPad.PaddingRight = UDim.new(0, 10)
    SPad.Parent = Scroll

    selfTab.Btn = Btn
    selfTab.Scroll = Scroll
    selfTab.Window = self
    selfTab.Theme = theme

    Btn.MouseButton1Click:Connect(function() self:SelectTab(selfTab) end)
    table.insert(self.Tabs, selfTab)

    if #self.Tabs == 1 then self:SelectTab(selfTab) end
    return selfTab
end

function Window:SelectTab(targetTab)
    for _, tab in ipairs(self.Tabs) do
        tab.Scroll.Visible = false
        SpringTween(tab.Btn, 0.2, {TextColor3 = self.Theme.TextMuted, BackgroundTransparency = 0.6})
    end
    targetTab.Scroll.Visible = true
    SpringTween(targetTab.Btn, 0.2, {TextColor3 = self.Theme.Accent, BackgroundTransparency = 0.1})
end

-- ==============================================================================
-- دوال إضافة العناصر البسيطة جداً (سهلة الاستخدام مستقبلاً)
-- ==============================================================================

-- 1. إضافة زر بكلمة واحدة
function Tab:AddButton(name, callback)
    callback = callback or function() end
    local theme = self.Theme

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = theme.Background
    Btn.Text = "  " .. name
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.TextColor3 = theme.Text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Btn.Parent = self.Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    local Tag = Instance.new("TextLabel")
    Tag.Text = "RUN"
    Tag.Font = Enum.Font.GothamBold
    Tag.TextSize = 9
    Tag.TextColor3 = theme.Accent
    Tag.BackgroundColor3 = theme.SurfaceHover
    Tag.Size = UDim2.new(0, 32, 0, 18)
    Tag.Position = UDim2.new(1, -40, 0.5, -9)
    Tag.BorderSizePixel = 0
    Tag.Parent = Btn

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 4)
    TCorner.Parent = Tag

    Btn.MouseButton1Click:Connect(function()
        SpringTween(Btn, 0.08, {Size = UDim2.new(0.98, 0, 0, 34)})
        task.wait(0.08)
        SpringTween(Btn, 0.12, {Size = UDim2.new(1, 0, 0, 36)})
        callback()
    end)

    table.insert(self.Window.AllElements, { Name = name, Frame = Btn })
    return Btn
end
Tab.CreateButton = function(self, opt) return self:AddButton(opt.Name, opt.Callback) end

-- 2. إضافة توجل (مفتاح تشغيل/إيقاف)
function Tab:AddToggle(name, defaultState, callback)
    local state = defaultState or false
    callback = callback or function() end
    local theme = self.Theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundColor3 = theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = self.Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextColor3 = theme.Text
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 38, 0, 20)
    Switch.Position = UDim2.new(1, -48, 0.5, -10)
    Switch.BackgroundColor3 = (state and theme.Accent) or theme.SurfaceHover
    Switch.BorderSizePixel = 0
    Switch.Parent = Frame

    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(1, 0)
    SCorner.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = (state and UDim2.new(1, -17, 0.5, -7)) or UDim2.new(0, 3, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch

    local KCorner = Instance.new("UICorner")
    KCorner.CornerRadius = UDim.new(1, 0)
    KCorner.Parent = Knob

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = Frame

    local function Set(val)
        state = val
        DiaaUI.Flags[name] = state
        if state then
            SpringTween(Switch, 0.22, {BackgroundColor3 = theme.Accent})
            SpringTween(Knob, 0.22, {Position = UDim2.new(1, -17, 0.5, -7)})
        else
            SpringTween(Switch, 0.22, {BackgroundColor3 = theme.SurfaceHover})
            SpringTween(Knob, 0.22, {Position = UDim2.new(0, 3, 0.5, -7)})
        end
        callback(state)
    end

    ClickBtn.MouseButton1Click:Connect(function() Set(not state) end)
    DiaaUI.Flags[name] = state
    table.insert(self.Window.AllElements, { Name = name, Frame = Frame })
    return { Set = Set, GetValue = function() return state end }
end
Tab.CreateToggle = function(self, opt) return self:AddToggle(opt.Name, opt.CurrentValue, opt.Callback) end

-- 3. إضافة سلايدر (شريط تمرير أرقام)
function Tab:AddSlider(name, min, max, defaultVal, step, callback)
    min = min or 0
    max = max or 100
    step = step or 1
    local current = defaultVal or min
    callback = callback or function() end
    local theme = self.Theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 46)
    Frame.BackgroundColor3 = theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = self.Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Text = name
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextColor3 = theme.Text
    Title.Size = UDim2.new(1, -60, 0, 18)
    Title.Position = UDim2.new(0, 10, 0, 6)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local ValText = Instance.new("TextLabel")
    ValText.Text = tostring(current)
    ValText.Font = Enum.Font.GothamBold
    ValText.TextSize = 11
    ValText.TextColor3 = theme.Accent
    ValText.Size = UDim2.new(0, 50, 0, 18)
    ValText.Position = UDim2.new(1, -58, 0, 6)
    ValText.BackgroundTransparency = 1
    ValText.TextXAlignment = Enum.TextXAlignment.Right
    ValText.Parent = Frame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 6)
    Track.Position = UDim2.new(0, 10, 1, -12)
    Track.BackgroundColor3 = theme.SurfaceHover
    Track.BorderSizePixel = 0
    Track.Parent = Frame

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(1, 0)
    TCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(math.clamp((current - min) / (max - min), 0, 1), 0, 1, 0)
    Fill.BackgroundColor3 = theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(1, 0)
    FCorner.Parent = Fill

    local function Update(posX)
        local rel = math.clamp((posX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local stepped = math.clamp(math.floor((min + ((max - min) * rel)) / step + 0.5) * step, min, max)
        current = stepped
        ValText.Text = tostring(current)
        Fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
        DiaaUI.Flags[name] = current
        callback(current)
    end

    local isDragging = false
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            Update(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    DiaaUI.Flags[name] = current
    table.insert(self.Window.AllElements, { Name = name, Frame = Frame })
    return { Set = function(val) Update(Track.AbsolutePosition.X + (Track.AbsoluteSize.X * ((val - min) / (max - min)))) end }
end
Tab.CreateSlider = function(self, opt) return self:AddSlider(opt.Name, opt.Range[1], opt.Range[2], opt.CurrentValue, opt.Increment, opt.Callback) end

-- 4. إضافة قائمة منسدلة (Dropdown)
function Tab:AddDropdown(name, optionsList, defaultOption, callback)
    optionsList = optionsList or {"Option 1", "Option 2"}
    local current = defaultOption or optionsList[1] or ""
    callback = callback or function() end
    local theme = self.Theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 42)
    Frame.BackgroundColor3 = theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = self.Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Text = name
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextColor3 = theme.Text
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local DropBtn = Instance.new("TextButton")
    DropBtn.Text = current .. " ▾"
    DropBtn.Font = Enum.Font.GothamSemibold
    DropBtn.TextSize = 11
    DropBtn.TextColor3 = theme.Accent
    DropBtn.Size = UDim2.new(0.44, 0, 0, 26)
    DropBtn.Position = UDim2.new(0.53, 0, 0.5, -13)
    DropBtn.BackgroundColor3 = theme.SurfaceHover
    DropBtn.BorderSizePixel = 0
    DropBtn.Parent = Frame

    local DCorner = Instance.new("UICorner")
    DCorner.CornerRadius = UDim.new(0, 4)
    DCorner.Parent = DropBtn

    local idx = 1
    DropBtn.MouseButton1Click:Connect(function()
        idx = (idx % #optionsList) + 1
        current = optionsList[idx]
        DropBtn.Text = current .. " ▾"
        DiaaUI.Flags[name] = current
        callback(current)
    end)

    DiaaUI.Flags[name] = current
    table.insert(self.Window.AllElements, { Name = name, Frame = Frame })
    return { Set = function(opt) current = opt DropBtn.Text = current .. " ▾" callback(current) end }
end
Tab.CreateDropdown = function(self, opt) return self:AddDropdown(opt.Name, opt.Options, opt.CurrentOption, opt.Callback) end

-- 5. إضافة محدد ألوان (ColorPicker)
function Tab:AddColorPicker(name, defaultColor, callback)
    local color = defaultColor or Color3.fromRGB(56, 189, 248)
    callback = callback or function() end
    local theme = self.Theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = self.Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Text = name
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12
    Title.TextColor3 = theme.Text
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Box = Instance.new("TextButton")
    Box.Size = UDim2.new(0, 36, 0, 22)
    Box.Position = UDim2.new(1, -48, 0.5, -11)
    Box.BackgroundColor3 = color
    Box.Text = ""
    Box.BorderSizePixel = 0
    Box.Parent = Frame

    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 4)
    BCorner.Parent = Box

    local palette = {
        Color3.fromRGB(56, 189, 248),
        Color3.fromRGB(245, 158, 11),
        Color3.fromRGB(16, 185, 129),
        Color3.fromRGB(239, 68, 68),
        Color3.fromRGB(168, 85, 247),
        Color3.fromRGB(255, 255, 255)
    }
    local pIdx = 1
    Box.MouseButton1Click:Connect(function()
        pIdx = (pIdx % #palette) + 1
        color = palette[pIdx]
        Box.BackgroundColor3 = color
        DiaaUI.Flags[name] = color
        callback(color)
    end)

    DiaaUI.Flags[name] = color
    table.insert(self.Window.AllElements, { Name = name, Frame = Frame })
    return { Set = function(c) color = c Box.BackgroundColor3 = c callback(c) end }
end
Tab.CreateColorPicker = function(self, opt) return self:AddColorPicker(opt.Name, opt.Color, opt.Callback) end

-- 6. إضافة عنوان قسم (Section)
function Tab:AddSection(title)
    local Label = Instance.new("TextLabel")
    Label.Text = title:upper()
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextColor3 = self.Theme.TextMuted
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = self.Scroll
    return Label
end
Tab.CreateSection = Tab.AddSection

-- 7. إضافة فقرة نصية (Paragraph)
function Tab:AddParagraph(title, content)
    local theme = self.Theme

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 52)
    Frame.BackgroundColor3 = theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = self.Scroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TText = Instance.new("TextLabel")
    TText.Text = title
    TText.Font = Enum.Font.GothamBold
    TText.TextSize = 11
    TText.TextColor3 = theme.Accent
    TText.Size = UDim2.new(1, -20, 0, 18)
    TText.Position = UDim2.new(0, 10, 0, 6)
    TText.BackgroundTransparency = 1
    TText.TextXAlignment = Enum.TextXAlignment.Left
    TText.Parent = Frame

    local CText = Instance.new("TextLabel")
    CText.Text = content
    CText.Font = Enum.Font.Gotham
    CText.TextSize = 10
    CText.TextColor3 = theme.TextMuted
    CText.Size = UDim2.new(1, -20, 0, 24)
    CText.Position = UDim2.new(0, 10, 0, 24)
    CText.BackgroundTransparency = 1
    CText.TextXAlignment = Enum.TextXAlignment.Left
    CText.TextWrapped = true
    CText.Parent = Frame

    table.insert(self.Window.AllElements, { Name = title, Frame = Frame })
    return Frame
end
Tab.CreateParagraph = function(self, opt) return self:AddParagraph(opt.Title, opt.Content) end

-- ==============================================================================
-- 3. تشغيل النافذة وتجهيز التبويبات مع أمثلة سهلة يمكنك التعديل عليها
-- ==============================================================================
local WindowInstance = DiaaUI:CreateWindow({
    Title = "Diaa Luxury Hub",
    Subtitle = "By Diaa",
    Keybind = Enum.KeyCode.RightControl,
    MobileToggle = true
})

local MainTab = WindowInstance:CreateTab("Main")
local PlayerTab = WindowInstance:CreateTab("Player")
local VisualsTab = WindowInstance:CreateTab("Visuals")

-- -------------------------------------------------------------
-- تبويب Main: أمثلة على الأزرار والإشعارات
-- -------------------------------------------------------------
MainTab:AddSection("Overview")

MainTab:AddParagraph("DiaaUI Universal Engine", "تمت البرمجة بواسطة Diaa. كود نظيف وسريع ويعمل 100% على هاتفك!")

MainTab:AddButton("Send Notification Test", function()
    DiaaUI:Notify({
        Title = "By Diaa",
        Content = "DiaaUI يعمل الآن بدون أي أخطاء سنتاكس!",
        Duration = 3
    })
end)

MainTab:AddToggle("Anti-AFK Protection", true, function(enabled)
    if enabled then
        local VirtualUser = game:GetService("VirtualUser")
        DiaaUI.Connections["AntiAFK"] = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if DiaaUI.Connections["AntiAFK"] then DiaaUI.Connections["AntiAFK"]:Disconnect() end
    end
end)

-- -------------------------------------------------------------
-- تبويب Player: أمثلة على السلايدرز والأزرار وحركة اللاعب
-- -------------------------------------------------------------
PlayerTab:AddSection("Movement & Character")

PlayerTab:AddSlider("WalkSpeed Multiplier", 16, 250, 16, 1, function(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end)

PlayerTab:AddSlider("JumpPower Height", 50, 350, 50, 5, function(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").UseJumpPower = true
        char:FindFirstChildOfClass("Humanoid").JumpPower = val
    end
end)

PlayerTab:AddToggle("Infinite Jump", false, function(enabled)
    if enabled then
        DiaaUI.Connections["InfJump"] = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if DiaaUI.Connections["InfJump"] then DiaaUI.Connections["InfJump"]:Disconnect() end
    end
end)

PlayerTab:AddToggle("NoClip (Wall Pass)", false, function(enabled)
    if enabled then
        DiaaUI.Connections["NoClip"] = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if DiaaUI.Connections["NoClip"] then DiaaUI.Connections["NoClip"]:Disconnect() end
    end
end)

-- -------------------------------------------------------------
-- تبويب Visuals: أمثلة على القوائم المنسدلة ومحدد الألوان
-- -------------------------------------------------------------
VisualsTab:AddSection("Lighting & ESP")

VisualsTab:AddToggle("FullBright (Night Vision)", false, function(enabled)
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

VisualsTab:AddToggle("Player ESP Highlights", false, function(enabled)
    if enabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("DiaaESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "DiaaESP"
                hl.FillColor = Color3.fromRGB(56, 189, 248)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = plr.Character
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("DiaaESP") then
                plr.Character["DiaaESP"]:Destroy()
            end
        end
    end
end)

VisualsTab:AddDropdown("ESP Team Filter", {"All Players", "Enemies Only", "Friends Only"}, "All Players", function(selected)
    print("[DiaaUI] ESP Filter changed to:", selected)
end)

VisualsTab:AddColorPicker("ESP Highlight Color", Color3.fromRGB(56, 189, 248), function(color)
    print("[DiaaUI] Custom color selected:", color)
end)

-- إشعار البداية
DiaaUI:Notify({
    Title = "DiaaUI v6.0 Ready",
    Content = "Welcome to Diaa Luxury Hub By Diaa.",
    Duration = 4
})

return DiaaUI
