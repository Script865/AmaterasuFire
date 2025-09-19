-- Script: AmaterasuSkill.lua
-- حطه في StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- إعدادات القدرة
local DAMAGE = 1000
local FIRE_SIZE = Vector3.new(4,6,4)
local FIRE_LIFETIME = 10 -- تختفي بعد 10 ثواني

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AmaterasuGui"
screenGui.Parent = playerGui

-- زر نصي مطابق لشكل الأزرار الأصلية
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,100,0,50)
button.Position = UDim2.new(0.65,0,0.85,0) -- اضبطناه بحيث يجي جنب الأزرار الأصلية
button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.BackgroundTransparency = 0.3
button.Text = "Amaterasu"
button.TextColor3 = Color3.fromRGB(255,255,255)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Parent = screenGui

-- دالة إنشاء نار الأماتيراسو
local function spawnAmaterasu(owner)
    local pos = camera.CFrame.Position + camera.CFrame.LookVector * 20

    local firePart = Instance.new("Part")
    firePart.Size = FIRE_SIZE
    firePart.Anchored = true
    firePart.CanCollide = false
    firePart.Material = Enum.Material.Neon
    firePart.Color = Color3.fromRGB(10,10,10) -- أسود
    firePart.Transparency = 0.2
    firePart.Position = pos
    firePart.Name = "AmaterasuFire"
    firePart.Parent = workspace

    -- مؤثرات النار السوداء
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364"
    emitter.Rate = 80
    emitter.Lifetime = NumberRange.new(0.5,1)
    emitter.Speed = NumberRange.new(5,8)
    emitter.Rotation = NumberRange.new(0,360)
    emitter.SpreadAngle = Vector2.new(360,360)
    emitter.LightEmission = 1
    emitter.Parent = firePart

    -- ضرر عند اللمس
    firePart.Touched:Connect(function(hit)
        local character = hit.Parent
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local plr = hum and Players:GetPlayerFromCharacter(character)

        -- ما يضر اللاعب اللي أطلق القدرة
        if hum and plr ~= owner then
            hum:TakeDamage(DAMAGE)
        end
    end)

    -- حذف النار بعد 10 ثواني
    game:GetService("Debris"):AddItem(firePart, FIRE_LIFETIME)
end

-- ربط الزر بالقدرة (بدون كولدوان)
button.MouseButton1Click:Connect(function()
    spawnAmaterasu(player)
end)
