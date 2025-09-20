local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local head = char:WaitForChild("Head")

-- زر GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton")
button.Text = "Amaterasu"
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0.3, 0, 0.85, 0) -- عدل مكانه
button.TextScaled = true
button.Parent = screenGui

-- انيميشن
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://YOUR_ANIMATION_ID"
local animTrack = humanoid:LoadAnimation(anim)

-- صوت Itachi
local voice = Instance.new("Sound")
voice.SoundId = "rbxassetid://YOUR_ITACHI_VOICE_ID"
voice.Volume = 3
voice.Parent = head

button.MouseButton1Click:Connect(function()
	-- يشغل الانيميشن والصوت
	if not animTrack.IsPlaying then
		animTrack:Play()
	end
	voice:Play()

	-- يطلق Ray من العين
	local camera = workspace.CurrentCamera
	local origin = head.Position + (head.CFrame.RightVector * -0.3)
	local direction = camera.CFrame.LookVector * 5000

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {char}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(origin, direction, params)

	if result then
		-- يولد نار
		local firePart = Instance.new("Part")
		firePart.Size = Vector3.new(4, 4, 4)
		firePart.Anchored = true
		firePart.CanCollide = false
		firePart.Transparency = 1
		firePart.Position = result.Position
		firePart.Parent = workspace

		local fire = Instance.new("Fire")
		fire.Color = Color3.new(0,0,0)
		fire.SecondaryColor = Color3.new(0.2,0.2,0.2)
		fire.Heat = 25
		fire.Size = 10
		fire.Parent = firePart

		-- صوت الاشتعال
		local ignite = Instance.new("Sound")
		ignite.SoundId = "rbxassetid://YOUR_IGNITE_SOUND_ID"
		ignite.Volume = 2
		ignite.Parent = firePart
		ignite:Play()

		-- ضرر إذا لمس لاعب
		if result.Instance and result.Instance.Parent:FindFirstChild("Humanoid") then
			local hum = result.Instance.Parent:FindFirstChild("Humanoid")
			if hum and result.Instance.Parent ~= char then
				hum:TakeDamage(1000)
			end
		end

		-- يختفي بعد 10 ثواني
		Debris:AddItem(firePart, 10)
	end
end)
