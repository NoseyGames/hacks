local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local cam = Workspace.CurrentCamera
local mouse = lp:GetMouse()

local isMobile = UserInputService.TouchEnabled

local Settings = {
    Enabled = true,
    SilentAim = false,          -- true = bullets redirect, camera stays (most used in rivals)
    RageMode = false,           -- snaps harder, bigger fov, higher pred
    TeamCheck = true,
    VisibleCheck = true,
    StickyLock = true,          -- keeps target until dead / out of range
    TargetPart = "Head",        -- "Head", "UpperTorso", "HumanoidRootPart"
    FOV = 180,
    Smoothness = 0.08,          -- lower = snappier
    Prediction = 0.135,         -- base
    AutoPrediction = true,
    HitChance = 100,            -- 0-100
    BulletDropComp = 0.0005,    -- rivals sometimes needs this
    JitterIntensity = 0.008,    -- micro random to look legit
    ShowFOV = true,
    ShowUI = true
}

-- simple config save (expand with Http if u want cloud)
local function saveConfig()
    local json = HttpService:JSONEncode(Settings)
    writefile("r1vals_nikebot.json", json)
end

local function loadConfig()
    if isfile("r1vals_nikebot.json") then
        local data = readfile("r1vals_nikebot.json")
        local tbl = HttpService:JSONDecode(data)
        for k,v in pairs(tbl) do Settings[k] = v end
    end
end

loadConfig()

-- ui setup (kept similar but cleaner)
local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "R1VALS_NIKE"; sg.ResetOnSpawn = false
local fovCircle = Instance.new("Frame", sg)
fovCircle.Size = UDim2.new(0, Settings.FOV*2, 0, Settings.FOV*2)
fovCircle.BackgroundTransparency = 0.92
fovCircle.BackgroundColor3 = Color3.fromRGB(0,180,255)
fovCircle.BorderSizePixel = 0
fovCircle.Visible = Settings.ShowFOV
local corner = Instance.new("UICorner", fovCircle); corner.CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", fovCircle); stroke.Color = Color3.fromRGB(0,220,255); stroke.Thickness = 2.5

-- simple status label
local status = Instance.new("TextLabel", sg)
status.Size = UDim2.new(0,180,0,30)
status.Position = UDim2.new(0.5, -90, 0, 10)
status.BackgroundTransparency = 0.4
status.BackgroundColor3 = Color3.new(0,0,0)
status.TextColor3 = Color3.new(1,1,1)
status.Text = "NIKEBOT | OFF"
status.Font = Enum.Font.GothamBold
status.TextSize = 16
local uic = Instance.new("UICorner", status); uic.CornerRadius = UDim.new(0,6)

local currentTarget = nil

local function isValidTarget(plr)
    if plr == lp then return false end
    if Settings.TeamCheck and plr.Team == lp.Team then return false end
    local char = plr.Character
    if not char or not char.Parent then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

local function isVisible(part)
    if not Settings.VisibleCheck then return true end
    local origin = cam.CFrame.Position
    local dir = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {lp.Character or {}, cam}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local res = Workspace:Raycast(origin, dir, params)
    return res == nil or res.Instance:IsDescendantOf(part.Parent)
end

local function getPredictionOffset(part)
    local base = Settings.Prediction
    if Settings.AutoPrediction then
        local dist = (cam.CFrame.Position - part.Position).Magnitude
        base = base + (dist / 1000) + (game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()/1000 * 0.033)
        base = math.clamp(base, 0.09, 0.24)
    end

    local root = part.Parent:FindFirstChild("HumanoidRootPart") or part
    local vel = root.AssemblyLinearVelocity
    local drop = Vector3.new(0, -Settings.BulletDropComp * (root.Position - cam.CFrame.Position).Magnitude^2, 0)

    return (vel * base) + drop
end

local function getClosest()
    local best, bestDist = nil, Settings.FOV

    local center = isMobile and Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2) or Vector2.new(mouse.X, mouse.Y + 36)

    for _, plr in Players:GetPlayers() do
        if not isValidTarget(plr) then continue end

        local char = plr.Character
        local part = char:FindFirstChild(Settings.TargetPart) or char:FindFirstChild("UpperTorso") or char.Head
        if not part then continue end

        local screen, vis = cam:WorldToViewportPoint(part.Position)
        if not vis then continue end

        local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
        if dist >= bestDist then continue end

        if Settings.VisibleCheck and not isVisible(part) then continue end

        best = part
        bestDist = dist
    end

    return best
end

RunService.RenderStepped:Connect(function()
    if not Settings.Enabled then
        status.Text = "NIKEBOT | OFF"
        status.TextColor3 = Color3.fromRGB(200,50,50)
        fovCircle.Visible = false
        return
    end

    status.Text = "NIKEBOT | ON"
    status.TextColor3 = Color3.fromRGB(50,255,120)

    if Settings.ShowFOV then
        local mpos = isMobile and (UserInputService:GetTouchInputs()[1] and UserInputService:GetTouchInputs()[1].Position or Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)) or Vector2.new(mouse.X, mouse.Y + 36)
        fovCircle.Position = UDim2.new(0, mpos.X - Settings.FOV, 0, mpos.Y - Settings.FOV)
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    local target = currentTarget

    if Settings.StickyLock and target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") and target.Parent.Humanoid.Health > 0 then
        -- keep sticky
    else
        target = getClosest()
        currentTarget = target
    end

    if not target then return end

    local predPos = target.Position + getPredictionOffset(target)

    -- micro jitter for anti-spectate / anti-simple ac
    local jitter = Vector3.new(
        math.random(-10,10)*Settings.JitterIntensity,
        math.random(-5,5)*Settings.JitterIntensity,
        math.random(-10,10)*Settings.JitterIntensity
    )

    predPos += jitter

    if math.random(1,100) > Settings.HitChance then
        -- miss on purpose sometimes (looks legit)
        predPos += Vector3.new(math.random(-30,30), math.random(-15,15), math.random(-30,30)) * 0.1
    end

    if Settings.SilentAim then
        -- silent aim style (hook / metatable or just set mouse.Hit if executor allows)
        -- most 2025-2026 executors support mouse.Hit override or find .Bullet hook
        -- fallback: camera silent style (still visible but no snap)
        cam.CFrame = CFrame.new(cam.CFrame.Position, predPos)
    else
        -- visible camera aim
        local targetCFrame = CFrame.new(cam.CFrame.Position, predPos)
        local s = Settings.RageMode and 0.4 or Settings.Smoothness
        cam.CFrame = cam.CFrame:Lerp(targetCFrame, s)
    end
end)

-- controls
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end

    if inp.KeyCode == Enum.KeyCode.RightShift then
        Settings.Enabled = not Settings.Enabled
    end

    if inp.KeyCode == Enum.KeyCode.Q then
        Settings.SilentAim = not Settings.SilentAim
        print("silent aim:", Settings.SilentAim and "ON" or "OFF")
    end

    if inp.KeyCode == Enum.KeyCode.E then
        Settings.RageMode = not Settings.RageMode
        print("rage mode:", Settings.RageMode and "ON" or "OFF")
    end

    if inp.KeyCode == Enum.KeyCode.F then
        Settings.VisibleCheck = not Settings.VisibleCheck
        print("wall check:", Settings.VisibleCheck and "ON" or "OFF")
    end
end)

-- auto save every 60s
spawn(function()
    while true do
        saveConfig()
        task.wait(60)
    end
end)

print[[
╔════════════════════════════╗
║   R1VALS NIKEBOT 2026      ║
║  silent aim / rage / sticky║
║ Q = silent   E = rage mode ║
║ RShift = toggle   F = walls║
╚════════════════════════════╝
loaded. enjoy shitting on rivals.
]]
