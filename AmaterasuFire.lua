-- سكربت AmaterasuAbility

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")

-- إعدادات القدرة
local AMATERASU_DAMAGE = 1000
local FIRE_SIZE = Vector3.new(4, 6, 4)
local FIRE_RADIUS = 6
local FIRE_COLOR = Color3.fromRGB(10, 10, 10) -- أسود متوهج

-- إنشاء ScreenGui + زر
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AmaterasuGUI"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, -75, 0.9, 0)
button.Text = "Amaterasu"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

-- دالة إنشاء النار على الهدف
local function spawnAmaterasu(ownerPlayer, targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local char = targetPlayer.Character
    local hrp = char.HumanoidRootPart

    -- إزالة أي قدرة سابقة
    if char:FindFirstChild("AmaterasuEffect") then
        char.AmaterasuEffect:Destroy()
    end

    -- Part يشبه القدرات الأصلية
    local firePart = Instance.new("Part")
    firePart.Name = "AmaterasuEffect"
    firePart.Size = FIRE_SIZE
    firePart.Anchored = true
    firePart.CanCollide = false
    firePart.Material = Enum.Material.Neon
    firePart.BrickColor = BrickColor.new("Really black")
    firePart.Transparency = 0.3
    firePart.Parent = char

    -- ParticleEmitter للنار
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364" -- نفس شكل القدرات الأصلية
    emitter.Rate = 60
    emitter.Lifetime = NumberRange.new(0.5, 1)
    emitter.Speed = NumberRange.new(5, 8)
    emitter.VelocitySpread = 180
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.SpreadAngle = Vector2.new(360, 360)
    emitter.LightEmission = 1
    emitter.Parent = firePart

    -- تتبع اللاعب
    game:GetService("RunService").Heartbeat:Connect(function()
        if hrp.Parent then
            firePart.Position = hrp.Position
        else
            firePart:Destroy()
        end
    end)

    -- ضرب اللاعبين الآخرين فقط
    game:GetService("RunService").Heartbeat:Connect(function()
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= ownerPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                local otherHRP = other.Character.HumanoidRootPart
                if (otherHRP.Position - firePart.Position).Magnitude <= FIRE_RADIUS then
                    local hum = other.Character:FindFirstChild("Humanoid")
                    if hum then
                        hum:TakeDamage(AMATERASU_DAMAGE)
                    end
                end
            end
        end
    end)
end

-- عند الضغط على الزر
button.MouseButton1Click:Connect(function()
    local target = mouse.Target and Players:GetPlayerFromCharacter(mouse.Target.Parent)
    if target then
        spawnAmaterasu(player, target)
    end
end)
