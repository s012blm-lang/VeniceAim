--[[ VENICE AIMBOT — viseur central + panneau ON/OFF
     Touche C = activer/désactiver l'aimbot
     Maintiens CLIC DROIT (ou coche "Verrouillé") pour viser
]]

local P      = game:GetService("Players")
local RS     = game:GetService("RunService")
local UIS    = game:GetService("UserInputService")
local LP     = P.LocalPlayer
local PARENT = (gethui and gethui()) or game:GetService("CoreGui")

local C = {
	bg = Color3.fromRGB(15,15,19), bar = Color3.fromRGB(25,25,32),
	row = Color3.fromRGB(32,32,40), rowOn = Color3.fromRGB(0,78,62),
	box = Color3.fromRGB(54,54,66), on = Color3.fromRGB(0,232,160),
	text = Color3.fromRGB(233,233,239), dim = Color3.fromRGB(135,135,148),
	accent = Color3.fromRGB(0,232,160), lock = Color3.fromRGB(255,70,70),
}

local function corner(o, r)
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = o
	return c
end

local old = PARENT:FindFirstChild("VeniceAim")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "VeniceAim"; gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PARENT

-- ===== VISEEUR CENTRAL =====
local ring = Instance.new("Frame")
ring.AnchorPoint = Vector2.new(0.5, 0.5)
ring.Position = UDim2.fromScale(0.5, 0.5)
ring.Size = UDim2.fromOffset(240, 240)
ring.BackgroundTransparency = 1
ring.ZIndex = 1
ring.Parent = gui
local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(1, 0); rc.Parent = ring
local ringStroke = Instance.new("UIStroke")
ringStroke.Thickness = 1.5; ringStroke.Color = Color3.fromRGB(200,200,210)
ringStroke.Transparency = 0.55; ringStroke.Parent = ring

local dot = Instance.new("Frame")
dot.AnchorPoint = Vector2.new(0.5, 0.5)
dot.Position = UDim2.fromScale(0.5, 0.5)
dot.Size = UDim2.fromOffset(6, 6)
dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
dot.ZIndex = 2
dot.Parent = gui
local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = dot
local dotStroke = Instance.new("UIStroke")
dotStroke.Thickness = 1.5; dotStroke.Color = Color3.fromRGB(0,0,0)
dotStroke.Transparency = 0.35; dotStroke.Parent = dot

-- ===== PANNEAU =====
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(228, 555)
panel.Position = UDim2.new(0, 18, 0, 40)
panel.BackgroundColor3 = C.bg
panel.BorderSizePixel = 0
panel.Active = true
panel.ZIndex = 5
panel.Parent = gui
corner(panel, 10)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(44,44,55); stroke.Thickness = 1; stroke.Parent = panel

local bar = Instance.new("TextButton")
bar.Size = UDim2.new(1, 0, 0, 32)
bar.BackgroundColor3 = C.bar
bar.Text = "  VENICE AIM  ·  [C]"
bar.TextXAlignment = Enum.TextXAlignment.Left
bar.Font = Enum.Font.GothamBold; bar.TextSize = 12; bar.TextColor3 = C.accent
bar.BorderSizePixel = 0; bar.AutoButtonColor = false; bar.Parent = panel
corner(bar, 10)

local list = Instance.new("Frame")
list.Size = UDim2.new(1, -16, 1, -46)
list.Position = UDim2.new(0, 8, 0, 40)
list.BackgroundTransparency = 1
list.Parent = panel
local lay = Instance.new("UIListLayout")
lay.Padding = UDim.new(0, 3); lay.SortOrder = Enum.SortOrder.LayoutOrder
lay.Parent = list

local dragging, dragStart, startPos
bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = i.Position; startPos = panel.Position
		i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
bar.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(22, 22); mini.Position = UDim2.new(1, -28, 0, 5)
mini.BackgroundColor3 = C.row; mini.Text = "–"
mini.Font = Enum.Font.GothamBold; mini.TextSize = 14; mini.TextColor3 = C.text
mini.BorderSizePixel = 0; mini.Parent = bar
corner(mini, 5)
mini.MouseButton1Click:Connect(function()
	list.Visible = not list.Visible
	panel.Size = list.Visible and UDim2.fromOffset(228, 555) or UDim2.fromOffset(228, 32)
end)

-- ===== WIDGETS =====
local function makeHeader(text, order)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 15)
	l.BackgroundTransparency = 1; l.Text = text
	l.Font = Enum.Font.GothamBold; l.TextSize = 11; l.TextColor3 = C.dim
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.LayoutOrder = order; l.Parent = list
	return l
end

local function makeCheck(text, order, default, onChange)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, 0, 0, 26)
	row.BackgroundColor3 = C.row; row.Text = ""
	row.BorderSizePixel = 0; row.AutoButtonColor = false
	row.LayoutOrder = order; row.Parent = list
	corner(row, 6)

	local box = Instance.new("Frame")
	box.Size = UDim2.fromOffset(15, 15)
	box.Position = UDim2.new(0, 8, 0.5, -7.5)
	box.BackgroundColor3 = C.box; box.BorderSizePixel = 0; box.Parent = row
	corner(box, 4)

	local tick = Instance.new("TextLabel")
	tick.Size = UDim2.fromScale(1,1); tick.BackgroundTransparency = 1
	tick.Text = "✓"; tick.Font = Enum.Font.GothamBold; tick.TextSize = 11
	tick.TextColor3 = Color3.fromRGB(12,12,12); tick.TextTransparency = 1
	tick.Parent = box

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -36, 1, 0); lbl.Position = UDim2.new(0, 32, 0, 0)
	lbl.BackgroundTransparency = 1; lbl.Text = text
	lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextColor3 = C.text
	lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row

	local state = default
	local function render()
		box.BackgroundColor3 = state and C.on or C.box
		tick.TextTransparency = state and 0 or 1
		row.BackgroundColor3 = state and C.rowOn or C.row
	end
	render()

	local obj
	obj = {
		set = function(v) state = v render() onChange(v) end,
		get = function() return state end,
	}
	row.MouseButton1Click:Connect(function() obj.set(not state) end)
	return obj
end

local function makeNumRow(text, order, min, max, step, value, onChange)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 26)
	row.BackgroundColor3 = C.row; row.BorderSizePixel = 0
	row.LayoutOrder = order; row.Parent = list
	corner(row, 6)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 80, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
	lbl.BackgroundTransparency = 1; lbl.Text = text
	lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextColor3 = C.text
	lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row

	local val = Instance.new("TextLabel")
	val.Size = UDim2.fromOffset(30, 26); val.Position = UDim2.new(1, -96, 0, 0)
	val.BackgroundTransparency = 1; val.Text = tostring(value)
	val.Font = Enum.Font.GothamBold; val.TextSize = 12; val.TextColor3 = C.accent
	val.Parent = row

	local function mk(dir)
		local b = Instance.new("TextButton")
		b.Size = UDim2.fromOffset(24, 20)
		b.Position = dir > 0 and UDim2.new(1, -30, 0.5, -10) or UDim2.new(1, -58, 0.5, -10)
		b.BackgroundColor3 = C.box; b.Text = dir > 0 and "+" or "–"
		b.TextColor3 = C.text; b.Font = Enum.Font.GothamBold; b.TextSize = 14
		b.BorderSizePixel = 0; b.Parent = row
		corner(b, 5)
		b.MouseButton1Click:Connect(function()
			value = math.clamp(value + dir * step, min, max)
			val.Text = tostring(value); onChange(value)
		end)
	end
	mk(1); mk(-1)
	return row
end

local function makeButton(text, order, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 24)
	b.BackgroundColor3 = C.row; b.Text = text; b.TextColor3 = C.text
	b.Font = Enum.Font.Gotham; b.TextSize = 12
	b.BorderSizePixel = 0; b.LayoutOrder = order; b.Parent = list
	corner(b, 6)
	b.MouseButton1Click:Connect(cb)
	return b
end

-- ===== LOGIQUE =====
local aimOn, aimLock, visOnly, snap = false, false, false, true
local showRing, showDot = true, true
local FOV, SMOOTH = 120, 20
local speed, jumpPower = 60, 80
local infJump, noclip, flying, espOn = true, false, false, false

local function hum() local c = LP.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function stats()
	local h = hum()
	if h then h.WalkSpeed = speed; h.UseJumpPower = true; h.JumpPower = jumpPower end
end

UIS.JumpRequest:Connect(function()
	local h = hum()
	if infJump and h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

local ncParts, ncRun = {}, false
local function noclipLoop()
	if ncRun then return end
	ncRun = true
	while noclip do
		local c = LP.Character
		if c then
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("BasePart") and d.CanCollide then ncParts[d] = true; d.CanCollide = false end
			end
		end
		task.wait(0.15)
	end
	for p in pairs(ncParts) do if p.Parent then p.CanCollide = true end end
	ncParts = {}; ncRun = false
end

local bv, flyConn
local function stopFly()
	if bv then bv:Destroy(); bv = nil end
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	flying = false
end
local function startFly()
	local r = root() if not r then return end
	stopFly()
	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Velocity = Vector3.zero; bv.Parent = r
	flyConn = RS.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local d = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.yAxis end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then d -= Vector3.yAxis end
		if d.Magnitude > 0 then d = d.Unit end
		bv.Velocity = d * speed
	end)
	flying = true
end

local function attachESP(char)
	if not char or char:FindFirstChild("VeniceHL") then return end
	local hl = Instance.new("Highlight")
	hl.Name = "VeniceHL"; hl.FillColor = C.accent; hl.OutlineColor = C.accent
	hl.FillTransparency = 0.6; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
end
local function refreshESP()
	for _, p in ipairs(P:GetPlayers()) do
		if p ~= LP and p.Character then
			if espOn then attachESP(p.Character)
			else
				local hl = p.Character:FindFirstChild("VeniceHL")
				if hl then hl:Destroy() end
			end
		end
	end
end
local function hook(p)
	if p == LP then return end
	p.CharacterAdded:Connect(function(c)
		task.wait(0.3)
		if espOn then attachESP(c) end
	end)
end
for _, p in ipairs(P:GetPlayers()) do hook(p) end
P.PlayerAdded:Connect(hook)

local function tpNearest()
	local r = root() if not r then return end
	local best, bd
	for _, p in ipairs(P:GetPlayers()) do
		if p ~= LP and p.Character then
			local t = p.Character:FindFirstChild("HumanoidRootPart")
			if t then
				local d = (t.Position - r.Position).Magnitude
				if not bd or d < bd then best, bd = t, d end
			end
		end
	end
	if best then r.CFrame = best.CFrame * CFrame.new(0, 0, 3) end
end

-- ===== CIBLAGE =====
local ray = RaycastParams.new()
ray.FilterType = Enum.RaycastFilterType.Exclude

local function findTarget()
	local cam = workspace.CurrentCamera
	if not cam then return nil end
	local center = cam.ViewportSize / 2
	local bestHead, bestDist
	ray.FilterDescendantsInstances = LP.Character and {LP.Character} or {}

	for _, p in ipairs(P:GetPlayers()) do
		if p ~= LP and p.Character then
			local head = p.Character:FindFirstChild("Head")
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if head and h and h.Health > 0 then
				local sp, onScreen = cam:WorldToViewportPoint(head.Position)
				if onScreen and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
					if d <= FOV and (not bestDist or d < bestDist) then
						if visOnly then
							local hit = workspace:Raycast(cam.CFrame.Position, head.Position - cam.CFrame.Position, ray)
							if hit and hit.Instance:IsDescendantOf(p.Character) then bestHead, bestDist = head, d end
						else
							bestHead, bestDist = head, d
						end
					end
				end
			end
		end
	end
	return bestHead
end

-- boucle unique : ciblage + viseur + snap
RS.RenderStepped:Connect(function(dt)
	if not (aimOn or showRing or showDot) then return end

	local cam = workspace.CurrentCamera
	if not cam then return end

	local hold = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	local aiming = aimOn and (aimLock or hold)
	local head = findTarget()

	-- couleur du viseur
	local col, tr
	if not aimOn then
		col, tr = Color3.fromRGB(200,200,210), 0.6
	elseif head and aiming then
		col, tr = C.lock, 0
	elseif head then
		col, tr = C.accent, 0.1
	else
		col, tr = Color3.fromRGB(200,200,210), 0.6
	end
	ringStroke.Color = col; ringStroke.Transparency = tr
	dot.BackgroundColor3 = col
	ring.Size = UDim2.fromOffset(FOV * 2, FOV * 2)
	ring.Visible = showRing
	dot.Visible = showDot

	-- snap direct sur la tête
	if aiming and head then
		local goal = CFrame.lookAt(cam.CFrame.Position, head.Position)
		if snap then
			cam.CFrame = goal
		else
			cam.CFrame = cam.CFrame:Lerp(goal, 1 - math.exp(-SMOOTH * dt))
		end
	end
end)

LP.CharacterAdded:Connect(function()
	task.wait(0.4); stats()
	if flying then startFly() end
end)

-- ===== INTERFACE =====
makeHeader("AIMBOT", 1)
local cAim = makeCheck("Activer  (clic droit)", 2, false, function(v) aimOn = v end)
makeCheck("Verrouillé (sans clic)", 3, false, function(v) aimLock = v end)
makeCheck("Snap direct tête", 4, true, function(v) snap = v end)
makeCheck("Cibles visibles seulement", 5, false, function(v) visOnly = v end)
makeNumRow("FOV", 6, 20, 400, 10, 120, function(v) FOV = v end)
makeNumRow("Lissage", 7, 1, 60, 1, 20, function(v) SMOOTH = v end)

makeHeader("VISUEL", 8)
makeCheck("Rond de visée", 9, true, function(v) showRing = v end)
makeCheck("Point central", 10, true, function(v) showDot = v end)
makeCheck("ESP joueurs", 11, false, function(v) espOn = v refreshESP() end)

makeHeader("MOUVEMENT", 12)
makeCheck("Fly", 13, false, function(v) if v then startFly() else stopFly() end end)
makeCheck("Noclip", 14, false, function(v) noclip = v if v then task.spawn(noclipLoop) end end)
makeCheck("Infinite Jump", 15, true, function(v) infJump = v end)
makeNumRow("Vitesse", 16, 8, 300, 10, 60, function(v) speed = v stats() end)
makeNumRow("Saut", 17, 20, 300, 10, 80, function(v) jumpPower = v stats() end)

makeHeader("ACTIONS", 18)
makeButton("TP joueur proche", 19, tpNearest)
makeButton("Reset personnage", 20, function() local h = hum() if h then h.Health = 0 end end)

-- touche C = on/off
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.C then
		cAim.set(not cAim.get())
	end
end)

stats()
