-- Script: AmaterasuSkill.lua
-- ضعه في StarterPlayerScripts

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- إعدادات
local DAMAGE = 1000
local FIRE_DURATION = 10

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AmaterasuGui"
screenGui.Parent = playerGui

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

-- 🔥 دالة إنشاء نار الأماتيراسو
local function createAmaterasuFlame(position, owner, targetCharacter)
    local firePart = Instance.new("Part")
    firePart.Size = Vector3.new(3,3,3)
    firePart.Anchored = true
    firePart.CanCollide = false
    firePart.Transparency = 1
    firePart.Position = position
    firePart.Name = "AmaterasuFire"
    firePart.Parent = workspace

    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364"
    emitter.Color = ColorSequence.new(Color3.fromRGB(10,10,10))
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

    -- لو الهدف لاعب → دمج
    if targetCharacter then
        local hum = targetCharacter:FindFirstChildOfClass("Humanoid")
        local plr = Players:GetPlayerFromCharacter(targetCharacter)
        if hum and plr ~= owner then
            hum:TakeDamage(DAMAGE)
            -- خلي النار تلحق اللاعب
            firePart.Anchored = false
            firePart.CanCollide = false
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = firePart
            weld.Part1 = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Head")
            weld.Parent = firePart
        end
    end

    Debris:AddItem(firePart, FIRE_DURATION)
end

-- 🔥 دالة الإطلاق مع الأنيميشن
local function castAmaterasu(owner)
    local character = owner.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not head or not humanoid then return end

    -- ✨ 1. انيميشن: لف الراس شوي لليسار
    local neck = head:FindFirstChild("Neck") or head:FindFirstChildWhichIsA("Motor6D")
    if neck then
        local originalC0 = neck.C0
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true) -- يروح ويرجع
        local tween = TweenService:Create(neck, tweenInfo, {C0 = originalC0 * CFrame.Angles(0, math.rad(-15), 0)})
        tween:Play()
    end

    task.wait(0.25) -- بعد لف الراس شوية

    -- ✨ 2. يطلق شعاع من العين اليسار
    local eyePos = head.Position + (head.CFrame.RightVector * -0.3) + (head.CFrame.UpVector * 0.2)

    local rayOrigin = eyePos
    local rayDirection = camera.CFrame.LookVector * 99999
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if not result then return end

    -- ✨ 3. مؤثر شعاع لحظة الإطلاق
    local beamPart = Instance.new("Part")
    beamPart.Anchored = true
    beamPart.CanCollide = false
    beamPart.Color = Color3.fromRGB(20,20,20)
    beamPart.Material = Enum.Material.Neon
    beamPart.Size = Vector3.new(0.2,0.2,(result.Position - eyePos).Magnitude)
    beamPart.CFrame = CFrame.new(eyePos, result.Position) * CFrame.new(0,0,-beamPart.Size.Z/2)
    beamPart.Parent = workspace
    Debris:AddItem(beamPart, 0.2) -- يختفي بسرعة

    -- ✨ 4. لو أصاب لاعب أو بلوك يطلع نار أماتيراسو
    local targetChar = result.Instance.Parent:FindFirstChildOfClass("Humanoid") and result.Instance.Parent or nil
    createAmaterasuFlame(result.Position, owner, targetChar)
end

-- ربط الزر
button.MouseButton1Click:Connect(function()
    castAmaterasu(player)
end)
