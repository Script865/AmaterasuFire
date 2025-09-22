-- LocalScript in StarterGui
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- RemoteEvent setup
local remote = ReplicatedStorage:FindFirstChild("FreezeFakeRemote")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "FreezeFakeRemote"
	remote.Parent = ReplicatedStorage
end

-- صنع GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FreezeGui"
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0.5, -90, 0.9, 0)
button.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
button.Text = "تجميد وهمي"
button.Parent = ScreenGui

-- حركة بسيطة للزر
RunService.RenderStepped:Connect(function()
	button.Rotation = math.sin(tick()*2) * 3
end)

-- حالة النسخة
local fakeActive = false

-- عند الضغط
button.MouseButton1Click:Connect(function()
	local player = Players.LocalPlayer
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	if fakeActive then
		remote:FireServer("Remove")
		fakeActive = false
		button.Text = "تجميد وهمي"
	else
		remote:FireServer("Create", char.HumanoidRootPart.CFrame)
		fakeActive = true
		button.Text = "إزالة الوهم"
	end
end)

--------------------------------------------------------------------
-- سكربت سيرفر يتصنع تلقائيًا
--------------------------------------------------------------------
if not _G.FreezeFakeServer then
	_G.FreezeFakeServer = true

	local serverScript = Instance.new("Script")
	serverScript.Name = "FreezeFakeServer"
	serverScript.Parent = game:GetService("ServerScriptService")

	serverScript.Source = [[
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Debris = game:GetService("Debris")

		local remote = ReplicatedStorage:FindFirstChild("FreezeFakeRemote")
		if not remote then
			remote = Instance.new("RemoteEvent")
			remote.Name = "FreezeFakeRemote"
			remote.Parent = ReplicatedStorage
		end

		local fakeClones = {}

		remote.OnServerEvent:Connect(function(player, action, cframe)
			if action == "Create" then
				-- إزالة نسخة قديمة
				if fakeClones[player.UserId] then
					fakeClones[player.UserId]:Destroy()
					fakeClones[player.UserId] = nil
				end

				local char = player.Character
				if char then
					local clone = char:Clone()
					for _,v in pairs(clone:GetDescendants()) do
						if v:IsA("LocalScript") then v:Destroy() end
					end
					clone.Name = player.Name.."_FrozenFake"
					clone.Parent = workspace
					if clone:FindFirstChild("HumanoidRootPart") then
						clone:MoveTo(cframe.Position)
						clone.HumanoidRootPart.Anchored = true
					end
					fakeClones[player.UserId] = clone
					Debris:AddItem(clone,120) -- يختفي بعد دقيقتين
				end

			elseif action == "Remove" then
				if fakeClones[player.UserId] then
					fakeClones[player.UserId]:Destroy()
					fakeClones[player.UserId] = nil
				end
			end
		end)
	]]
end
