local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TouchEnabled = UserInputService.TouchEnabled

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Settings = {
    Enabled = true,
    Smoothness = 0.05,
    Prediction = 0.15,
    FOV = 150, 
    WallCheck = true,
    TargetPart = "Head",
    ShowUI = true,
    
    AimMethod = "Camera",
    
    PredictionMode = "Velocity",
    AutoPrediction = true,
    
    MobileMode = TouchEnabled,
    TouchSensitivity = 1.0,
    
    ShowFOV = true,
    ShowTargetInfo = true,
    SmoothnessSteps = 0.01,
    PredictionSteps = 0.05 
}

-- Colors
local COLORS = {
    Accent = Color3.fromRGB(0, 200, 255),
    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Danger = Color3.fromRGB(255, 50, 50),
    Info = Color3.fromRGB(200, 200, 255)
}

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "R1VALSAimbot"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = Settings.ShowUI
ScreenGui.ResetOnSpawn = false

-- FOV Circle
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
FOVCircle.BackgroundColor3 = COLORS.Accent
FOVCircle.BackgroundTransparency = 0.95
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = Settings.ShowFOV
FOVCircle.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FOVCircle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = COLORS.Accent
CircleStroke.Thickness = 2
CircleStroke.Parent = FOVCircle

-- Main UI Panel - Shows ALL settings
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = COLORS.Accent
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "nikebot by nikegtag kinda priv script"
Title.TextColor3 = COLORS.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Status Text
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 0, 20)
StatusText.Position = UDim2.new(0, 5, 0, 35)
StatusText.BackgroundTransparency = 1
StatusText.Text = "⚡ ACTIVE"
StatusText.TextColor3 = COLORS.Success
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 13
StatusText.Parent = MainFrame

local SmoothText = Instance.new("TextLabel")
SmoothText.Size = UDim2.new(1, -10, 0, 18)
SmoothText.Position = UDim2.new(0, 5, 0, 55)
SmoothText.BackgroundTransparency = 1
SmoothText.Text = "Smooth: 0.05"
SmoothText.TextColor3 = COLORS.Info
SmoothText.TextXAlignment = Enum.TextXAlignment.Left
SmoothText.Font = Enum.Font.Gotham
SmoothText.TextSize = 12
SmoothText.Parent = MainFrame

local PredText = Instance.new("TextLabel")
PredText.Size = UDim2.new(1, -10, 0, 18)
PredText.Position = UDim2.new(0, 5, 0, 73)
PredText.BackgroundTransparency = 1
PredText.Text = "Prediction: 0.15"
PredText.TextColor3 = COLORS.Warning
PredText.TextXAlignment = Enum.TextXAlignment.Left
PredText.Font = Enum.Font.Gotham
PredText.TextSize = 12
PredText.Parent = MainFrame

local FOVText = Instance.new("TextLabel")
FOVText.Size = UDim2.new(1, -10, 0, 18)
FOVText.Position = UDim2.new(0, 5, 0, 91)
FOVText.BackgroundTransparency = 1
FOVText.Text = "FOV: 150"
FOVText.TextColor3 = COLORS.Accent
FOVText.TextXAlignment = Enum.TextXAlignment.Left
FOVText.Font = Enum.Font.Gotham
FOVText.TextSize = 12
FOVText.Parent = MainFrame

local MethodText = Instance.new("TextLabel")
MethodText.Size = UDim2.new(1, -10, 0, 18)
MethodText.Position = UDim2.new(0, 5, 0, 109)
MethodText.BackgroundTransparency = 1
MethodText.Text = "Method: Camera"
MethodText.TextColor3 = Color3.fromRGB(255, 255, 255)
MethodText.TextXAlignment = Enum.TextXAlignment.Left
MethodText.Font = Enum.Font.Gotham
MethodText.TextSize = 12
MethodText.Parent = MainFrame

local TargetText = Instance.new("TextLabel")
TargetText.Size = UDim2.new(1, -10, 0, 18)
TargetText.Position = UDim2.new(0, 5, 0, 127)
TargetText.BackgroundTransparency = 1
TargetText.Text = "Target: None"
TargetText.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetText.TextXAlignment = Enum.TextXAlignment.Left
TargetText.Font = Enum.Font.Gotham
TargetText.TextSize = 12
TargetText.Parent = MainFrame

local WallText = Instance.new("TextLabel")
WallText.Size = UDim2.new(1, -10, 0, 18)
WallText.Position = UDim2.new(0, 5, 0, 145)
WallText.BackgroundTransparency = 1
WallText.Text = "Wall Check: ON"
WallText.TextColor3 = COLORS.Success
WallText.TextXAlignment = Enum.TextXAlignment.Left
WallText.Font = Enum.Font.Gotham
WallText.TextSize = 12
WallText.Parent = MainFrame

local ControlsText = Instance.new("TextLabel")
ControlsText.Size = UDim2.new(1, -10, 0, 18)
ControlsText.Position = UDim2.new(0, 5, 0, 168)
ControlsText.BackgroundTransparency = 1
ControlsText.Text = "M:Method  +/-:Pred  []:FOV"
ControlsText.TextColor3 = Color3.fromRGB(150, 150, 150)
ControlsText.TextXAlignment = Enum.TextXAlignment.Left
ControlsText.Font = Enum.Font.Gotham
ControlsText.TextSize = 9
ControlsText.Parent = MainFrame

-- Make UI draggable
local dragging = false
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

if TouchEnabled then
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 70, 0, 70)
    ToggleButton.Position = UDim2.new(1, -80, 1, -80)
    ToggleButton.BackgroundColor3 = COLORS.Success
    ToggleButton.Text = "⚡"
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.TextSize = 40
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ScreenGui
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        Settings.Enabled = not Settings.Enabled
        ToggleButton.BackgroundColor3 = Settings.Enabled and COLORS.Success or COLORS.Danger
        StatusText.Text = Settings.Enabled and "⚡ ACTIVE" or "⚡ DISABLED"
        StatusText.TextColor3 = Settings.Enabled and COLORS.Success or COLORS.Danger
    end)
end

local function IsTargetVisible(targetPart)
    if not Settings.WallCheck then return true end
    
    local character = LocalPlayer.Character
    if not character then return false end
    
    local origin = Camera.CFrame.Position
    local target = targetPart.Position
    local direction = (target - origin).Unit * (target - origin).Magnitude
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {character, targetPart.Parent, Camera}
    
    local result = Workspace:Raycast(origin, direction, rayParams)
    return result == nil
end

local function GetPredictedPosition(targetPart)
    if Settings.Prediction <= 0 then 
        return targetPart.Position 
    end
    
    local character = targetPart.Parent
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
    
    local predictionFactor = Settings.Prediction
    if Settings.AutoPrediction then
        predictionFactor = Settings.Prediction * (distance / 100)
        predictionFactor = math.min(0.3, predictionFactor) -- Cap at 0.3
    end
    
    if humanoid then
        if Settings.PredictionMode == "Velocity" then
            local moveDirection = humanoid.MoveDirection
            local walkSpeed = humanoid.WalkSpeed
            
            if moveDirection.Magnitude > 0 then
                local velocity = moveDirection * walkSpeed
                local predictedPos = targetPart.Position + (velocity * predictionFactor)
                return predictedPos
            end
        
        elseif Settings.PredictionMode == "Direction" then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart and rootPart.AssemblyLinearVelocity.Magnitude > 1 then
                local velocity = rootPart.AssemblyLinearVelocity
                local predictedPos = targetPart.Position + (velocity * predictionFactor * 0.5)
                return predictedPos
            end
        end
    end
    
    return targetPart.Position
end

local function GetClosestTarget()
    local closestTarget = nil
    local closestDistance = Settings.FOV
    
    local inputPos
    if TouchEnabled then
        local touches = UserInputService:GetTouchInputs()
        if #touches > 0 then
            inputPos = Vector2.new(touches[#touches].Position.X, touches[#touches].Position.Y)
        else
            inputPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        end
    else
        inputPos = UserInputService:GetMouseLocation()
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local targetPart = character:FindFirstChild(Settings.TargetPart) or
                          character:FindFirstChild("HumanoidRootPart") or
                          character:FindFirstChild("Head")
        
        if not targetPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        
        if onScreen then
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - inputPos).Magnitude
            
            if distance < closestDistance then
                if IsTargetVisible(targetPart) then
                    closestTarget = targetPart
                    closestDistance = distance
                end
            end
        end
    end
    
    return closestTarget
end

local function AimAtTarget(target)
    if not target then return end
    
    local targetPos = GetPredictedPosition(target)
    
    local smoothness = 1 - Settings.Smoothness
    
    if Settings.AimMethod == "Camera" then
        Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, targetPos),
            smoothness
        )
    
    elseif Settings.AimMethod == "Mouse" then
        local screenPos = Camera:WorldToViewportPoint(targetPos)
        local currentPos = UserInputService:GetMouseLocation()
        
        local deltaX = (screenPos.X - currentPos.X) * smoothness
        local deltaY = (screenPos.Y - currentPos.Y) * smoothness

        if math.abs(deltaX) < 100 and math.abs(deltaY) < 100 then
            mousemoverel(deltaX, deltaY)
        end
    
    elseif Settings.AimMethod == "Both" then
        -- Camera movement
        Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, targetPos),
            smoothness
        )
        
        local screenPos = Camera:WorldToViewportPoint(targetPos)
        local currentPos = UserInputService:GetMouseLocation()
        local deltaX = (screenPos.X - currentPos.X) * 0.1
        local deltaY = (screenPos.Y - currentPos.Y) * 0.1
        
        if math.abs(deltaX) < 30 and math.abs(deltaY) < 30 then
            mousemoverel(deltaX, deltaY)
        end
    
    elseif Settings.AimMethod == "CFrame" then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            local lookAt = CFrame.lookAt(root.Position, targetPos)
            root.CFrame = root.CFrame:Lerp(lookAt, smoothness)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if Settings.ShowFOV then
        local inputPos
        if TouchEnabled then
            local touches = UserInputService:GetTouchInputs()
            if #touches > 0 then
                inputPos = Vector2.new(touches[#touches].Position.X, touches[#touches].Position.Y)
                FOVCircle.Position = UDim2.new(0, inputPos.X - Settings.FOV, 0, inputPos.Y - Settings.FOV)
                FOVCircle.Visible = true
            else
                FOVCircle.Visible = false
            end
        else
            inputPos = UserInputService:GetMouseLocation()
            FOVCircle.Position = UDim2.new(0, inputPos.X - Settings.FOV, 0, inputPos.Y - Settings.FOV)
            FOVCircle.Visible = true
        end
    else
        FOVCircle.Visible = false
    end
    
    if Settings.Enabled then
        local target = GetClosestTarget()
        
        if target then
            AimAtTarget(target)
            
            -- Update UI
            if Settings.ShowTargetInfo then
                TargetText.Text = "Target: " .. target.Parent.Name
                TargetText.TextColor3 = COLORS.Success
                
                -- Show if predicting
                local character = target.Parent
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.MoveDirection.Magnitude > 0.1 then
                    TargetText.Text = TargetText.Text .. " (leading)"
                end
            end
        else
            TargetText.Text = "Target: None"
            TargetText.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        StatusText.Text = "⚡ ACTIVE"
        StatusText.TextColor3 = COLORS.Success
    else
        StatusText.Text = "⚡ DISABLED"
        StatusText.TextColor3 = COLORS.Danger
        TargetText.Text = "Target: None"
    end
end)

-- Keybinds - FULL CONTROL
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if not TouchEnabled then
        -- Toggle aimbot
        if input.KeyCode == Enum.KeyCode.RightShift then
            Settings.Enabled = not Settings.Enabled
        end
        
        -- Toggle UI
        if input.KeyCode == Enum.KeyCode.F1 then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
        
        -- CYCLE AIM METHODS (M key)
        if input.KeyCode == Enum.KeyCode.M then
            if Settings.AimMethod == "Camera" then
                Settings.AimMethod = "Mouse"
            elseif Settings.AimMethod == "Mouse" then
                Settings.AimMethod = "Both"
            elseif Settings.AimMethod == "Both" then
                Settings.AimMethod = "CFrame"
            else
                Settings.AimMethod = "Camera"
            end
            MethodText.Text = "Method: " .. Settings.AimMethod
            print("Aim method:", Settings.AimMethod)
        end
        
        -- ADJUST PREDICTION (+ and - keys)
        if input.KeyCode == Enum.KeyCode.Equals then
            Settings.Prediction = math.min(0.3, Settings.Prediction + Settings.PredictionSteps)
            PredText.Text = "Prediction: " .. string.format("%.2f", Settings.Prediction)
        end
        
        if input.KeyCode == Enum.KeyCode.Minus then
            Settings.Prediction = math.max(0, Settings.Prediction - Settings.PredictionSteps)
            PredText.Text = "Prediction: " .. string.format("%.2f", Settings.Prediction)
        end
        
        -- ADJUST FOV ([ and ] keys)
        if input.KeyCode == Enum.KeyCode.RightBracket then -- ]
            Settings.FOV = math.min(500, Settings.FOV + 10)
            FOVCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
            FOVText.Text = "FOV: " .. Settings.FOV
        end
        
        if input.KeyCode == Enum.KeyCode.LeftBracket then -- [
            Settings.FOV = math.max(50, Settings.FOV - 10)
            FOVCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
            FOVText.Text = "FOV: " .. Settings.FOV
        end
        
        -- ADJUST SMOOTHNESS (; and ' keys)
        if input.KeyCode == Enum.KeyCode.Semicolon then -- ;
            Settings.Smoothness = math.min(0.2, Settings.Smoothness + 0.01)
            SmoothText.Text = "Smooth: " .. string.format("%.2f", Settings.Smoothness)
        end
        
        if input.KeyCode == Enum.KeyCode.Quote then -- '
            Settings.Smoothness = math.max(0.01, Settings.Smoothness - 0.01)
            SmoothText.Text = "Smooth: " .. string.format("%.2f", Settings.Smoothness)
        end
        
        -- Toggle wall check (W key)
        if input.KeyCode == Enum.KeyCode.W then
            Settings.WallCheck = not Settings.WallCheck
            WallText.Text = "Wall Check: " .. (Settings.WallCheck and "ON" or "OFF")
            WallText.TextColor3 = Settings.WallCheck and COLORS.Success or COLORS.Danger
        end
        
        -- Toggle prediction mode (P key)
        if input.KeyCode == Enum.KeyCode.P then
            Settings.PredictionMode = Settings.PredictionMode == "Velocity" and "Direction" or "Velocity"
            print("Prediction mode:", Settings.PredictionMode)
        end
    end
end)

-- Update UI periodically
spawn(function()
    while true do
        StatusText.Text = Settings.Enabled and "⚡ ACTIVE" or "⚡ DISABLED"
        StatusText.TextColor3 = Settings.Enabled and COLORS.Success or COLORS.Danger
        SmoothText.Text = "Smooth: " .. string.format("%.2f", Settings.Smoothness)
        PredText.Text = "Prediction: " .. string.format("%.2f", Settings.Prediction)
        FOVText.Text = "FOV: " .. Settings.FOV
        MethodText.Text = "Method: " .. Settings.AimMethod
        WallText.Text = "Wall Check: " .. (Settings.WallCheck and "ON" or "OFF")
        WallText.TextColor3 = Settings.WallCheck and COLORS.Success or COLORS.Danger
        wait(0.1)
    end
end)

print([[
╔══════════════════════════════════════════════╗
║   nikebot - by nikegtag              ║
╠══════════════════════════════════════════════╣
║                                              ║
║  YOUR SETTINGS:                              ║
║  • Smoothness: 0.05 (ultra smooth)           ║
║  • Prediction: 0.15 (leads targets)          ║
║  • FOV: 150 (detection radius)               ║
║  • Wall Check: ON                             ║
║                                              ║
║  CONTROLS:                                    ║
║  Right Shift - Toggle Aimbot                  ║
║  M - Cycle Aim Methods                         ║
║  + / - - Adjust Prediction                     ║
║  [ / ] - Adjust FOV                            ║
║  ; / ' - Adjust Smoothness                      ║
║  W - Toggle Wall Check                          ║
║  P - Toggle Prediction Mode                     ║
║  F1 - Hide/Show UI                              ║
║                                                  ║
║  AIM METHODS:                                    ║
║  • Camera - Smooth camera movement               ║
║  • Mouse - Mouse cursor movement                 ║
║  • Both - Combined approach                      ║
║  • CFrame - Character rotation                   ║
║                                                  ║
╚══════════════════════════════════════════════╝
]])
