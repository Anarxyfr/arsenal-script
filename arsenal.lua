local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicationStorage = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players") -- Corrected service reference

-- ESP Configuration
local ESPS = {}
local ENABLED_ESP = false

-- Function to determine team color
local function getTeamColor(player)
    if player == player or player.Team == player.Team then
        return Color3.fromRGB(0, 255, 0) -- Green for teammates or self
    else
        return Color3.fromRGB(255, 0, 0) -- Red for enemies
    end
end

-- Function to create ESP for a player
local function createESP(player)
    if player == player then return end
    local box = Drawing.new("Square")
    box.Filled = false
    box.Thickness = 2
    box.Transparency = 0.9
    box.Color = getTeamColor(player)
    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Transparency = 0.9
    tracer.Color = box.Color
    ESPS[player] = {box = box, tracer = tracer}
end

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do -- Corrected to Players:GetPlayers()
    createESP(player)
end

-- Handle new players joining
Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Handle players leaving
Players.PlayerRemoving:Connect(function(player)
    if ESPS[player] then
        ESPS[player].box:Remove()
        ESPS[player].tracer:Remove()
        ESPS[player] = nil
    end
end)

-- Update ESP every frame
local function updateESP()
    for player, esp in pairs(ESPS) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local rootPos, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(character.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position - Vector3.new(0, 4, 0))
                local headPos2D = Vector2.new(headPos.X, headPos.Y)
                local legPos2D = Vector2.new(legPos.X, legPos.Y)
                local height = (headPos2D - legPos2D).Y
                local width = height / 2
                esp.box.Size = Vector2.new(width, height)
                esp.box.Position = Vector2.new(headPos2D.X - width / 2, headPos2D.Y + height * 0.5)
                esp.box.Visible = ENABLED_ESP
                esp.box.Color = getTeamColor(player)
                esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.tracer.To = legPos2D
                esp.tracer.Visible = ENABLED_ESP
                esp.tracer.Color = esp.box.Color
            else
                esp.box.Visible = false
                esp.tracer.Visible = false
            end
        else
            esp.box.Visible = false
            esp.tracer.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- Create GUI
local Main = Instance.new("ScreenGui")
local ModsFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Header = Instance.new("Frame")
local HeaderCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Sidebar = Instance.new("Frame")
local SidebarCorner = Instance.new("UICorner")
local AmmoButton = Instance.new("TextButton")
local FireRateButton = Instance.new("TextButton")
local RecoilButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local LowQualityButton = Instance.new("TextButton")
local Content = Instance.new("Frame")
local ContentCorner = Instance.new("UICorner")
local Notification = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

Main.Name = "Main"
Main.Parent = playerGui
Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Main.ResetOnSpawn = false
Main.DisplayOrder = 9999

ModsFrame.Name = "ModsFrame"
ModsFrame.Parent = Main
ModsFrame.Active = true
ModsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ModsFrame.BorderSizePixel = 0
ModsFrame.Draggable = true
ModsFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
ModsFrame.Size = UDim2.new(0, 350, 0, 450)

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ModsFrame

Header.Name = "Header"
Header.Parent = ModsFrame
Header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 60)

HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

Title.Name = "Title"
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Enhanced Mods"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24

Sidebar.Name = "Sidebar"
Sidebar.Parent = ModsFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 100, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)

SidebarCorner.CornerRadius = UDim.new(0, 15)
SidebarCorner.Parent = Sidebar

AmmoButton.Name = "AmmoButton"
AmmoButton.Parent = Sidebar
AmmoButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AmmoButton.BorderSizePixel = 0
AmmoButton.Size = UDim2.new(0.9, 0, 0, 60)
AmmoButton.Position = UDim2.new(0, 5, 0, 10)
AmmoButton.Text = "Infinite Ammo"
AmmoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AmmoButton.TextSize = 16
AmmoButton.Font = Enum.Font.Gotham

FireRateButton.Name = "FireRateButton"
FireRateButton.Parent = Sidebar
FireRateButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FireRateButton.BorderSizePixel = 0
FireRateButton.Size = UDim2.new(0.9, 0, 0, 60)
FireRateButton.Position = UDim2.new(0, 5, 0, 80)
FireRateButton.Text = "Fire Rate"
FireRateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FireRateButton.TextSize = 16
FireRateButton.Font = Enum.Font.Gotham

RecoilButton.Name = "RecoilButton"
RecoilButton.Parent = Sidebar
RecoilButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RecoilButton.BorderSizePixel = 0
RecoilButton.Size = UDim2.new(0.9, 0, 0, 60)
RecoilButton.Position = UDim2.new(0, 5, 0, 150)
RecoilButton.Text = "Recoil"
RecoilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RecoilButton.TextSize = 16
RecoilButton.Font = Enum.Font.Gotham

ESPButton.Name = "ESPButton"
ESPButton.Parent = Sidebar
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPButton.BorderSizePixel = 0
ESPButton.Size = UDim2.new(0.9, 0, 0, 60)
ESPButton.Position = UDim2.new(0, 5, 0, 220)
ESPButton.Text = "ESP"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 16
ESPButton.Font = Enum.Font.Gotham

LowQualityButton.Name = "LowQualityButton"
LowQualityButton.Parent = Sidebar
LowQualityButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LowQualityButton.BorderSizePixel = 0
LowQualityButton.Size = UDim2.new(0.9, 0, 0, 60)
LowQualityButton.Position = UDim2.new(0, 5, 0, 290)
LowQualityButton.Text = "Low Quality"
LowQualityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LowQualityButton.TextSize = 16
LowQualityButton.Font = Enum.Font.Gotham

Content.Name = "Content"
Content.Parent = ModsFrame
Content.BackgroundTransparency = 1
Content.Size = UDim2.new(1, -110, 1, -60)
Content.Position = UDim2.new(0, 100, 0, 60)

ContentCorner.CornerRadius = UDim.new(0, 15)
ContentCorner.Parent = Content

Notification.Name = "Notification"
Notification.Parent = Content
Notification.BackgroundTransparency = 1
Notification.Size = UDim2.new(1, -20, 0, 40)
Notification.Position = UDim2.new(0, 10, 0, 10)
Notification.Font = Enum.Font.Gotham
Notification.Text = "The box in the ESP is offset for some reason, sorry!"
Notification.TextColor3 = Color3.fromRGB(255, 100, 100)
Notification.TextSize = 14

CloseButton.Name = "CloseButton"
CloseButton.Parent = ModsFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 10)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold

-- Hover Effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        ts:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    button.MouseLeave:Connect(function()
        ts:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
end

addHoverEffect(AmmoButton)
addHoverEffect(FireRateButton)
addHoverEffect(RecoilButton)
addHoverEffect(ESPButton)
addHoverEffect(LowQualityButton)

-- Function: Infinite Ammo
local ammoToggled = false
AmmoButton.MouseButton1Click:Connect(function()
    ammoToggled = not ammoToggled
    AmmoButton.Text = "Infinite Ammo" .. (ammoToggled and " (ON)" or " (OFF)")
    if ammoToggled then
        spawn(function()
            while ammoToggled do
                local weapons = replicationStorage:FindFirstChild("Weapons")
                if weapons then
                    for _, weapon in pairs(weapons:GetChildren()) do
                        local ammo = weapon:FindFirstChild("Ammo")
                        local storedAmmo = weapon:FindFirstChild("StoredAmmo")
                        if ammo and ammo:IsA("IntValue") and storedAmmo and storedAmmo:IsA("IntValue") then
                            ammo.Value = 999
                            storedAmmo.Value = 300
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

-- Function: Fire Rate Mod
local fireRateToggled = false
FireRateButton.MouseButton1Click:Connect(function()
    fireRateToggled = not fireRateToggled
    FireRateButton.Text = "Fire Rate" .. (fireRateToggled and " (ON)" or " (OFF)")
    while fireRateToggled and wait() do
        local weapons = replicationStorage:FindFirstChild("Weapons")
        if weapons then
            for _, v in pairs(weapons:GetDescendants()) do
                if v.Name == "Auto" and v:IsA("BoolValue") then
                    v.Value = true
                end
                if v.Name == "FireRate" and v:IsA("NumberValue") then
                    v.Value = 0.02
                end
            end
        end
    end
end)

-- Function: Recoil Mod
local recoilToggled = false
RecoilButton.MouseButton1Click:Connect(function()
    recoilToggled = not recoilToggled
    RecoilButton.Text = "Recoil" .. (recoilToggled and " (ON)" or " (OFF)")
    while recoilToggled and wait() do
        local weapons = replicationStorage:FindFirstChild("Weapons")
        if weapons then
            for _, v in pairs(weapons:GetDescendants()) do
                if v.Name == "RecoilControl" and v:IsA("NumberValue") then
                    v.Value = 0
                end
                if v.Name == "MaxSpread" and v:IsA("NumberValue") then
                    v.Value = 0
                end
            end
        end
    end
end)

-- Toggle ESP
ESPButton.MouseButton1Click:Connect(function()
    ENABLED_ESP = not ENABLED_ESP
    ESPButton.Text = "ESP" .. (ENABLED_ESP and " (ON)" or " (OFF)")
end)

-- Low Quality FPS Booster
LowQualityButton.MouseButton1Click:Connect(function()
    _G.Settings = {
        Players = {
            ["Ignore Me"] = true,
            ["Ignore Others"] = true
        },
        Meshes = {
            Destroy = false,
            LowDetail = true
        },
        Images = {
            Invisible = true,
            LowDetail = false,
            Destroy = false
        },
        ["No Particles"] = true,
        ["No Camera Effects"] = true,
        ["No Explosions"] = true,
        ["No Clothes"] = true,
        ["Low Water Graphics"] = true,
        ["No Shadows"] = true,
        ["Low Rendering"] = true,
        ["Low Quality Parts"] = true
    }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
end)

-- Close GUI
CloseButton.MouseButton1Click:Connect(function()
    ModsFrame:Destroy()
end)

-- Initial Appearance
local appear = ts:Create(ModsFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
appear:Play()
