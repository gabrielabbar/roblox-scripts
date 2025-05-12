loadstring([[
-- UI Creation
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"
gui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Open"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = gui

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 0, 0, 0)
panel.Position = UDim2.new(0, 10, 0, 50)
panel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
panel.ClipsDescendants = true
panel.Parent = gui

local buttons = {
    {Name = "StaminaINF", Script = nil, Enabled = false},
    {Name = "AutoBlockOP", Script = nil, Enabled = false},
    {Name = "KillAura", Script = nil, Enabled = false}
}

-- Store thread refs to stop later
local runningThreads = {}

local function createOption(index, buttonInfo)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, (index - 1) * 40 + 10)
    btn.Text = buttonInfo.Name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = panel

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 60, 0, 30)
    status.Position = UDim2.new(0, 140, 0, (index - 1) * 40 + 10)
    status.Text = "OFF"
    status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.Parent = panel

    btn.MouseButton1Click:Connect(function()
        buttonInfo.Enabled = not buttonInfo.Enabled
        if buttonInfo.Enabled then
            status.Text = "ON"
            status.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

            if buttonInfo.Name == "AutoBlockOP" then
                local function autoBlock()
                    while true do
                        wait(0.1)
                        if not buttonInfo.Enabled then break end
                        local args = {"SwingTag", "SwingBlock"}
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Saber_RS")
                            :WaitForChild("RemoteEvents")
                            :WaitForChild("LightsaberEvent30"):FireServer(unpack(args))
                    end
                end
                runningThreads[buttonInfo.Name] = coroutine.create(autoBlock)
                coroutine.resume(runningThreads[buttonInfo.Name])
            elseif buttonInfo.Name == "StaminaINF" then
                local function regenLoop()
                    while true do
                        task.wait()
                        if not buttonInfo.Enabled then break end
                        local args = {"BlockRegen", 2}
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Saber_RS")
                            :WaitForChild("RemoteEvents")
                            :WaitForChild("LightsaberEvent30"):FireServer(unpack(args))
                    end
                end
                runningThreads[buttonInfo.Name] = coroutine.create(regenLoop)
                coroutine.resume(runningThreads[buttonInfo.Name])
            elseif buttonInfo.Name == "KillAura" then
                local function killaura()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local saber = character:WaitForChild("RightHand"):WaitForChild("Saber")
                    local radius = 60
                    while true do
                        wait(0.1)
                        if not buttonInfo.Enabled then break end
                        for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
                            if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (targetPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if dist <= radius then
                                    local args = {
                                        "Attack",
                                        targetPlayer.Character:WaitForChild("HumanoidRootPart"),
                                        saber,
                                        8,
                                        0,
                                        0,
                                        os.clock(),
                                        targetPlayer.UserId
                                    }
                                    game:GetService("ReplicatedStorage"):WaitForChild("Saber_RS")
                                        :WaitForChild("RemoteEvents"):WaitForChild("LightsaberEvent30"):FireServer(unpack(args))
                                end
                            end
                        end
                    end
                end
                runningThreads[buttonInfo.Name] = coroutine.create(killaura)
                coroutine.resume(runningThreads[buttonInfo.Name])
            end
        else
            status.Text = "OFF"
            status.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
end

-- Crear botones
for i, info in ipairs(buttons) do
    createOption(i, info)
end

-- Toggle menu animation
local open = false
local tweenService = game:GetService("TweenService")
toggleButton.MouseButton1Click:Connect(function()
    open = not open
    toggleButton.Text = open and "Close" or "Open"
    local goal = {}
    goal.Size = open and UDim2.new(0, 220, 0, 140) or UDim2.new(0, 0, 0, 0)
    local tween = tweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), goal)
    tween:Play()
end)
]])()
