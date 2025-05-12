loadstring([[
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
    {Name = "StaminaINF", Enabled = false},
    {Name = "AutoBlockOP", Enabled = false},
    {Name = "KillAura", Enabled = false},
    {Name = "ESP", Enabled = false},
    {Name = "Hitbox", Enabled = false}
}

local runningThreads = {}
local espConnection
local hitboxConnection
local hitboxSize = 50
local hitboxTransparency = 0.7

local function clearESP()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        local c = p.Character
        if c and c:FindFirstChild("ESP") then
            c:FindFirstChild("ESP"):Destroy()
        end
    end
end

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
        status.Text = buttonInfo.Enabled and "ON" or "OFF"
        status.BackgroundColor3 = buttonInfo.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

        if buttonInfo.Name == "AutoBlockOP" then
            if buttonInfo.Enabled then
                local function autoBlock()
                    while buttonInfo.Enabled do
                        wait(0.1)
                        local args = {"SwingTag", "SwingBlock"}
                        game:GetService("ReplicatedStorage").Saber_RS.RemoteEvents.LightsaberEvent30:FireServer(unpack(args))
                    end
                end
                runningThreads[buttonInfo.Name] = coroutine.create(autoBlock)
                coroutine.resume(runningThreads[buttonInfo.Name])
            end
        elseif buttonInfo.Name == "StaminaINF" then
            if buttonInfo.Enabled then
                local function regenLoop()
                    while buttonInfo.Enabled do
                        task.wait()
                        local args = {"BlockRegen", 2}
                        game:GetService("ReplicatedStorage").Saber_RS.RemoteEvents.LightsaberEvent30:FireServer(unpack(args))
                    end
                end
                runningThreads[buttonInfo.Name] = coroutine.create(regenLoop)
                coroutine.resume(runningThreads[buttonInfo.Name])
            end
        elseif buttonInfo.Name == "KillAura" then
            if buttonInfo.Enabled then
                local function killaura()
                    local character = player.Character or player.CharacterAdded:Wait()
                    local saber = character:WaitForChild("RightHand"):WaitForChild("Saber")
                    while buttonInfo.Enabled do
                        wait(0.1)
                        for _, target in pairs(game.Players:GetPlayers()) do
                            if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (target.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if dist <= 60 then
                                    game:GetService("ReplicatedStorage").Saber_RS.RemoteEvents.LightsaberEvent30:FireServer(
                                        "Attack",
                                        target.Character.HumanoidRootPart,
                                        saber,
                                        8, 0, 0,
                                        os.clock(),
                                        target.UserId
                                    )
                                end
                            end
                        end
                    end
                end
                runningThreads[buttonInfo.Name] = coroutine.create(killaura)
                coroutine.resume(runningThreads[buttonInfo.Name])
            end
        elseif buttonInfo.Name == "ESP" then
            if buttonInfo.Enabled then
                espConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    for _, plr in pairs(game.Players:GetPlayers()) do
                        local char = plr.Character
                        if char and not char:FindFirstChild("ESP") and plr ~= player then
                            local head = char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
                            if head then
                                local billboard = Instance.new("BillboardGui", char)
                                billboard.Name = "ESP"
                                billboard.Adornee = head
                                billboard.Size = UDim2.new(0, 200, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 3, 0)
                                billboard.AlwaysOnTop = true

                                local label = Instance.new("TextLabel", billboard)
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Color3.new(1,1,1)
                                label.TextStrokeTransparency = 0
                                label.Font = Enum.Font.SourceSansBold
                                label.TextScaled = true
                                label.Name = "ESPText"
                            end
                        end

                        local esp = char and char:FindFirstChild("ESP")
                        if esp then
                            local label = esp:FindFirstChild("ESPText")
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            local stamina = char:FindFirstChild("BlockValue")
                            if label and humanoid and stamina then
                                label.Text = plr.Name .. " | HP: " .. math.floor(humanoid.Health) .. " | Stamina: " .. math.floor(stamina.Value)
                            end
                        end
                    end
                end)
            else
                if espConnection then espConnection:Disconnect() end
                clearESP()
            end
        elseif buttonInfo.Name == "Hitbox" then
            if buttonInfo.Enabled then
                hitboxConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local part = p.Character.HumanoidRootPart
                            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            part.Transparency = hitboxTransparency
                            part.BrickColor = BrickColor.new("Really blue")
                            part.Material = Enum.Material.Neon
                            part.CanCollide = false
                        end
                    end
                end)

                -- Botones de tamaño
                local plus = Instance.new("TextButton", panel)
                plus.Text = "+"
                plus.Position = UDim2.new(0, 10, 0, (#buttons + 0) * 40 + 10)
                plus.Size = UDim2.new(0, 30, 0, 30)
                plus.MouseButton1Click:Connect(function() hitboxSize = hitboxSize + 5 end)

                local minus = Instance.new("TextButton", panel)
                minus.Text = "-"
                minus.Position = UDim2.new(0, 50, 0, (#buttons + 0) * 40 + 10)
                minus.Size = UDim2.new(0, 30, 0, 30)
                minus.MouseButton1Click:Connect(function() hitboxSize = math.max(5, hitboxSize - 5) end)

                local moreVis = Instance.new("TextButton", panel)
                moreVis.Text = "+"
                moreVis.Position = UDim2.new(0, 100, 0, (#buttons + 0) * 40 + 10)
                moreVis.Size = UDim2.new(0, 30, 0, 30)
                moreVis.MouseButton1Click:Connect(function()
                    hitboxTransparency = math.clamp(hitboxTransparency - 0.1, 0, 1)
                end)

                local lessVis = Instance.new("TextButton", panel)
                lessVis.Text = "-"
                lessVis.Position = UDim2.new(0, 140, 0, (#buttons + 0) * 40 + 10)
                lessVis.Size = UDim2.new(0, 30, 0, 30)
                lessVis.MouseButton1Click:Connect(function()
                    hitboxTransparency = math.clamp(hitboxTransparency + 0.1, 0, 1)
                end)
            else
                if hitboxConnection then hitboxConnection:Disconnect() end
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                        p.Character.HumanoidRootPart.Transparency = 1
                    end
                end
            end
        end
    end)
end

for i, info in ipairs(buttons) do
    createOption(i, info)
end

local open = false
local tweenService = game:GetService("TweenService")
toggleButton.MouseButton1Click:Connect(function()
    open = not open
    toggleButton.Text = open and "Close" or "Open"
    local goal = {}
    goal.Size = open and UDim2.new(0, 220, 0, 300) or UDim2.new(0, 0, 0, 0)
    local tween = tweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), goal)
    tween:Play()
end)
]])()
