local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- النظارة
local SunglassFrame = Instance.new("Frame")
SunglassFrame.Size = UDim2.new(0,50,0,50)
SunglassFrame.Position = UDim2.new(0,20,0,20)
SunglassFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
SunglassFrame.Active = true
SunglassFrame.Draggable = true
SunglassFrame.Parent = ScreenGui

local SunglassLabel = Instance.new("TextLabel")
SunglassLabel.Size = UDim2.new(1,0,1,0)
SunglassLabel.Text = "🕶️"
SunglassLabel.TextScaled = true
SunglassLabel.BackgroundTransparency = 1
SunglassLabel.Parent = SunglassFrame

-- Hub
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0,220,0,200)
HubFrame.Position = UDim2.new(0,80,0,20)
HubFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
HubFrame.Active = true
HubFrame.Draggable = true
HubFrame.Visible = false
HubFrame.Parent = ScreenGui

-- اسم صاحب الحقوق
local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1,0,0,20)
OwnerLabel.Position = UDim2.new(0,0,0,0)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.TextColor3 = Color3.fromRGB(255,255,255)
OwnerLabel.Text = "الاونر: XDYT99"
OwnerLabel.Parent = HubFrame

-- صفحة القوانين
local RulesFrame = Instance.new("Frame")
RulesFrame.Size = HubFrame.Size
RulesFrame.Position = HubFrame.Position
RulesFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
RulesFrame.Visible = false
RulesFrame.Active = true
RulesFrame.Draggable = true
RulesFrame.Parent = ScreenGui

local RulesLabel = Instance.new("TextLabel")
RulesLabel.Size = UDim2.new(1,-10,1,-40)
RulesLabel.Position = UDim2.new(0,5,0,5)
RulesLabel.BackgroundTransparency = 1
RulesLabel.TextColor3 = Color3.fromRGB(255,255,255)
RulesLabel.TextWrapped = true
RulesLabel.Text = "اسلام عليكم ورحمة الله وبركاته\nالسكربت الي انت تستخدمه من صنع XDYT99 مصمم مستقل للسكربتات على gethub\n(يمنع مشاركة السكربت بدون اذني)\nاذا ودك تنشر السكربت اطلب اذني على حسابي الانستا(rtx_xd7) \nوشكرا 🖐🏽"
RulesLabel.Parent = RulesFrame

local BackButton = Instance.new("TextButton")
BackButton.Size = UDim2.new(0,100,0,25)
BackButton.Position = UDim2.new(0.5,-50,1,-30)
BackButton.Text = "العودة"
BackButton.TextColor3 = Color3.fromRGB(255,255,255)
BackButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
BackButton.Parent = RulesFrame

-- أزرار Hub
local Buttons = {}
local function createButton(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,150,0,30)
    btn.Position = pos
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Parent = HubFrame
    return btn
end

Buttons["الخطوط"] = createButton("الخطوط", UDim2.new(0,20,0,40))
Buttons["المربعات"] = createButton("المربعات", UDim2.new(0,20,0,80))
Buttons["المسافة"] = createButton("المسافة", UDim2.new(0,20,0,120))
local RulesButton = createButton("القوانين", UDim2.new(0,20,0,160))

RulesButton.MouseButton1Click:Connect(function()
    RulesFrame.Visible = true
    HubFrame.Visible = false
end)

BackButton.MouseButton1Click:Connect(function()
    RulesFrame.Visible = false
    HubFrame.Visible = true
end)

-- عداد الضغطات لإخفاء السكربت
local clickCount = 0
local clickTime = 0
local CLICK_LIMIT = 10
local TIME_LIMIT = 3

SunglassFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        HubFrame.Visible = not HubFrame.Visible
        RulesFrame.Visible = false

        local currentTime = tick()
        if currentTime - clickTime > TIME_LIMIT then clickCount = 0 end
        clickTime = currentTime
        clickCount = clickCount + 1
        if clickCount >= CLICK_LIMIT then
            ScreenGui:Destroy()
            print("تم إخفاء السكربت!")
        end
    end
end)

-- ESP
local tracers, boxes, distancesText = {}, {}, {}
local espLinesEnabled, espBoxesEnabled, espDistanceEnabled = false, false, false

local function createTracer()
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = Color3.fromRGB(0,255,0)
    line.Visible = false
    return line
end

local function createBox()
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(0,255,0)
    box.Filled = false
    box.Visible = false
    return box
end

local function createIndicator(button, isEnabled)
    local ind = Instance.new("TextLabel")
    ind.Size = UDim2.new(0,30,0,15)
    ind.Position = UDim2.new(1,0,0,0)
    ind.AnchorPoint = Vector2.new(1,0)
    ind.BackgroundTransparency = 1
    ind.Text = isEnabled and "ON" or "OFF"
    ind.TextScaled = false
    ind.Font = Enum.Font.SourceSansBold
    ind.TextColor3 = isEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    ind.Parent = button
    return ind
end

local lineIndicator = createIndicator(Buttons["الخطوط"], espLinesEnabled)
local boxIndicator = createIndicator(Buttons["المربعات"], espBoxesEnabled)
local distanceIndicator = createIndicator(Buttons["المسافة"], espDistanceEnabled)

Buttons["الخطوط"].MouseButton1Click:Connect(function()
    espLinesEnabled = not espLinesEnabled
    lineIndicator.Text = espLinesEnabled and "ON" or "OFF"
    lineIndicator.TextColor3 = espLinesEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)
Buttons["المربعات"].MouseButton1Click:Connect(function()
    espBoxesEnabled = not espBoxesEnabled
    boxIndicator.Text = espBoxesEnabled and "ON" or "OFF"
    boxIndicator.TextColor3 = espBoxesEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)
Buttons["المسافة"].MouseButton1Click:Connect(function()
    espDistanceEnabled = not espDistanceEnabled
    distanceIndicator.Text = espDistanceEnabled and "ON" or "OFF"
    distanceIndicator.TextColor3 = espDistanceEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

-- تنظيف ESP
local function cleanESP(player)
    if tracers[player] then tracers[player].Visible = false end
    if boxes[player] then boxes[player].Visible = false end
    if distancesText[player] then distancesText[player].Visible = false end
end

local function setupPlayer(player)
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then cleanESP(player) end
    end)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function() cleanESP(player) end)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then setupPlayer(player) end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then setupPlayer(player) end
end)

-- تحديث ESP
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
            local footPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,humanoid.HipHeight+2,0))
            local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if distance > 100 then cleanESP(player) continue end

            local color
            if distance <= 50 then color = Color3.fromRGB(255,0,0)
            elseif distance <= 70 then color = Color3.fromRGB(255,255,0)
            else color = Color3.fromRGB(0,255,0)
            end

            if espLinesEnabled then
                if not tracers[player] then tracers[player] = createTracer() end
                local tracer = tracers[player]
                tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                tracer.Color = color
                tracer.Visible = onScreen
            elseif tracers[player] then tracers[player].Visible = false end

            if espBoxesEnabled then
                if not boxes[player] then boxes[player] = createBox() end
                local box = boxes[player]
                local height = math.abs(headPos.Y - footPos.Y) * 1.2
                local width = (height / 1.8) * 1.2
                box.Size = Vector2.new(width,height)
                box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                box.Color = color
                box.Visible = onScreen
            elseif boxes[player] then boxes[player].Visible = false end

            if espDistanceEnabled then
                if not distancesText[player] then
                    local txt = Drawing.new("Text")
                    txt.Center = true
                    txt.Outline = true
                    txt.Size = 18
                    distancesText[player] = txt
                end
                local txt = distancesText[player]
                txt.Text = math.floor(distance).."m"
                txt.Position = Vector2.new(rootPos.X, headPos.Y - 15)
                txt.Color = color
                txt.Visible = onScreen
            elseif distancesText[player] then distancesText[player].Visible = false end
        else
            cleanESP(player)
        end
    end
end)