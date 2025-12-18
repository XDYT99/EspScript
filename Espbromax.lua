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
HubFrame.Size = UDim2.new(0,240,0,250)
HubFrame.Position = UDim2.new(0,80,0,20)
HubFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
HubFrame.Active = true
HubFrame.Draggable = true
HubFrame.Visible = false
HubFrame.Parent = ScreenGui

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Size = UDim2.new(1,0,0,20)
OwnerLabel.Position = UDim2.new(0,0,0,0)
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.TextColor3 = Color3.fromRGB(255,255,255)
OwnerLabel.Text = "الاونر: XDYT99"
OwnerLabel.Parent = HubFrame

-- أزرار Hub
local Buttons = {}
local function createButton(name, pos, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,150,0,30)
    btn.Position = pos
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Parent = parent
    return btn
end

-- الصفحة الرئيسية
local MainPage = Instance.new("Frame")
MainPage.Size = UDim2.new(1,0,1,0)
MainPage.BackgroundTransparency = 1
MainPage.Parent = HubFrame

Buttons["الخطوط"] = createButton("الخطوط", UDim2.new(0,20,0,40), MainPage)
Buttons["المربعات"] = createButton("المربعات", UDim2.new(0,20,0,80), MainPage)
Buttons["المسافة"] = createButton("المسافة", UDim2.new(0,20,0,120), MainPage)
Buttons["العدو/الفريق"] = createButton("العدو", UDim2.new(0,20,0,160), MainPage)

-- الصفحة الثانية
local SecondPage = Instance.new("Frame")
SecondPage.Size = UDim2.new(1,0,1,0)
SecondPage.BackgroundColor3 = Color3.fromRGB(40,40,40)
SecondPage.Visible = false
SecondPage.Parent = HubFrame

local BackPageButton = Instance.new("TextButton")
BackPageButton.Size = UDim2.new(0,100,0,30)
BackPageButton.Position = UDim2.new(0,10,0,10)
BackPageButton.Text = "⬅️ العودة"
BackPageButton.TextColor3 = Color3.fromRGB(255,255,255)
BackPageButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
BackPageButton.Parent = SecondPage

local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Size = UDim2.new(0,200,0,30)
DistanceLabel.Position = UDim2.new(0,10,0,60)
DistanceLabel.Text = "مسافة الرؤية: 100"
DistanceLabel.TextColor3 = Color3.fromRGB(255,255,255)
DistanceLabel.BackgroundTransparency = 1
DistanceLabel.TextScaled = true
DistanceLabel.Parent = SecondPage

local DistanceSlider = Instance.new("TextBox")
DistanceSlider.Size = UDim2.new(0,200,0,30)
DistanceSlider.Position = UDim2.new(0,10,0,100)
DistanceSlider.Text = "100"
DistanceSlider.TextColor3 = Color3.fromRGB(255,255,255)
DistanceSlider.BackgroundColor3 = Color3.fromRGB(60,60,60)
DistanceSlider.Parent = SecondPage

local NextPageButton = Instance.new("TextButton")
NextPageButton.Size = UDim2.new(0,25,0,25)
NextPageButton.Position = UDim2.new(1,-30,0,5)
NextPageButton.Text = "➡️"
NextPageButton.TextColor3 = Color3.fromRGB(255,255,255)
NextPageButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
NextPageButton.Parent = MainPage

NextPageButton.MouseButton1Click:Connect(function()
    MainPage.Visible = false
    SecondPage.Visible = true
end)
BackPageButton.MouseButton1Click:Connect(function()
    SecondPage.Visible = false
    MainPage.Visible = true
end)

-- مؤشرات ESP
local espLinesEnabled, espBoxesEnabled, espDistanceEnabled = false, false, false
local targetEnemy = true
local maxDistance = 100

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
local targetIndicator = createIndicator(Buttons["العدو/الفريق"], targetEnemy)

-- أزرار التحكم
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
Buttons["العدو/الفريق"].MouseButton1Click:Connect(function()
    targetEnemy = not targetEnemy
    Buttons["العدو/الفريق"].Text = targetEnemy and "العدو" or "فريقي"
    targetIndicator.Text = targetEnemy and "ON" or "OFF"
    targetIndicator.TextColor3 = targetEnemy and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

DistanceSlider.FocusLost:Connect(function()
    local val = tonumber(DistanceSlider.Text)
    if val then
        maxDistance = val
        DistanceLabel.Text = "مسافة الرؤية: "..maxDistance
    end
end)

-- ESP رسم
local tracers, boxes, distancesText = {}, {}, {}

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

RunService.RenderStepped:Connect(function()
    local localTeam = LocalPlayer.Team
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local isTarget = targetEnemy and player.Team ~= localTeam or not targetEnemy and player.Team == localTeam
            if not isTarget then cleanESP(player) continue end

            local hrp = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
            local footPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,humanoid.HipHeight+2,0))
            local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if distance > maxDistance then cleanESP(player) continue end

            local color
            if distance <= 20 then
                color = Color3.fromRGB(128,0,128) -- بنفسجي
            elseif distance <= 50 then
                color = Color3.fromRGB(255,0,0) -- أحمر
            elseif distance <= 85 then
                color = Color3.fromRGB(255,255,0) -- أصفر
            elseif distance <= 105 then
                color = Color3.fromRGB(255,165,0) -- برتقالي
            elseif distance <= 144 then
                color = Color3.fromRGB(0,255,0) -- أخضر
            else
                color = Color3.fromRGB(255,255,255) -- أبيض
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

-- عداد ضغطات لإيقاف ESP وإخفاء السكربت
local clickCount = 0
local clickTime = 0
local CLICK_LIMIT_HIDE = 15
local TIME_LIMIT = 3

SunglassFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        HubFrame.Visible = not HubFrame.Visible
        local currentTime = tick()
        if currentTime - clickTime > TIME_LIMIT then
            clickCount = 0
        end
        clickTime = currentTime
        clickCount = clickCount + 1

        if clickCount >= CLICK_LIMIT_HIDE then
            espLinesEnabled = false
            espBoxesEnabled = false
            espDistanceEnabled = false
            lineIndicator.Text = "OFF"
            lineIndicator.TextColor3 = Color3.fromRGB(255,0,0)
            boxIndicator.Text = "OFF"
            boxIndicator.TextColor3 = Color3.fromRGB(255,0,0)
            distanceIndicator.Text = "OFF"
            distanceIndicator.TextColor3 = Color3.fromRGB(255,0,0)

            for _, player in ipairs(Players:GetPlayers()) do
                if tracers[player] then tracers[player].Visible = false end
                if boxes[player] then boxes[player].Visible = false end
                if distancesText[player] then distancesText[player].Visible = false end
            end

            ScreenGui:Destroy()
            print("تم إيقاف ESP وإخفاء السكربت!")
        end
    end
end)
