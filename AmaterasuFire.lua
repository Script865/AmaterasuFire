-- Script: AmaterasuSkill.lua
-- ضعه في StarterPlayerScripts

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- إعدادات
local DAMAGE = 1000
local FIRE_DURATION = 10 -- يختفي بعد 10 ثواني

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AmaterasuGui"
screenGui.Parent = playerGui

-- زر نصي بنفس حجم الأزرار الأصلية
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,100,0,50)
button.Position = UDim2.new(0.75,0,0.85,0)
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.BackgroundTransparency = 0.3
button.Text = "Amaterasu"
button.TextColor3 = Color3.fromRGB(255,255,255)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Parent = screenGui

-- دالة إطلاق الأماتيراسو
local function castAmaterasu(owner)
    local rayOrigin = camera.CFrame.Position
    local rayDirection = camera.CFrame.LookVector * 99999 -- مدى لانهائي تقريبًا

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {owner.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if not result then
        return -- لو ما أصاب أي شيء ما يطلع نار
    end

    local hitPos = result.Position

    -- لو أصاب لاعب
    local character = result.Instance.Parent
    local hum = character:FindFirstChildOfClass("Humanoid")
    local plr = hum and Players:GetPlayerFromCharacter(character)
    if hum and plr ~= owner then
        hum:TakeDamage(DAMAGE)
    end

    -- إنشاء النار السوداء
    local firePart = Instance.new("Part")
    firePart.Size = Vector3.new(3,3,3)
    firePart.Anchored = true
    firePart.CanCollide = false
    firePart.Transparency = 1
    firePart.Position = hitPos
    firePart.Name = "AmaterasuFire"
    firePart.Parent = workspace

    -- مؤثرات النار السوداء
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364" -- شكل نار
    emitter.Color = ColorSequence.new(Color3.fromRGB(10,10,10)) -- أسود
    emitter.Rate = 100
    emitter.Lifetime = NumberRange.new(0.5,1)
    emitter.Speed = NumberRange.new(2,4)
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0,3),
        NumberSequenceKeypoint.new(1,1)
    })
    emitter.Rotation = NumberRange.new(0,360)
    emitter.SpreadAngle = Vector2.new(360,360)
    emitter.LightEmission = 1
    emitter.Parent = firePart

    -- حذف النار بعد 10 ثواني
    Debris:AddItem(firePart, FIRE_DURATION)
end

-- ربط الزر
button.MouseButton1Click:Connect(function()
    castAmaterasu(player)
end)
