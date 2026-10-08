

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

LocalPlayer:WaitForChild("ActiveQuests", 10)
LocalPlayer:WaitForChild("leaderstats", 10)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TheScriptCore_TaxiBoss"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LOGO_ID = "rbxassetid://91349847555817"

local DEFAULT_THEME = {
	BG      = Color3.fromRGB(13, 10, 25),
	SIDEBAR = Color3.fromRGB(18, 14, 35),
	ACCENT  = Color3.fromRGB(224, 63, 224),
	BUTTON  = Color3.fromRGB(35, 25, 55),
	CARD    = Color3.fromRGB(20, 16, 30),
	LogoId  = "rbxassetid://91349847555817",
	BgImageId = "",
	BgImageTransparency = 0.65,
}

local Theme = {
	BG = DEFAULT_THEME.BG,
	SIDEBAR = DEFAULT_THEME.SIDEBAR,
	ACCENT = DEFAULT_THEME.ACCENT,
	BUTTON = DEFAULT_THEME.BUTTON,
	CARD = DEFAULT_THEME.CARD,
	LogoId = DEFAULT_THEME.LogoId,
	BgImageId = DEFAULT_THEME.BgImageId,
	BgImageTransparency = DEFAULT_THEME.BgImageTransparency,
}

pcall(function()
	local saved = (getgenv and getgenv().ScriptCoreHubTheme) or nil
	if type(saved) == "table" then
		for k, v in pairs(saved) do
			if typeof(v) == "Color3" and Theme[k] ~= nil then Theme[k] = v
			elseif (type(v) == "string" or type(v) == "number") and Theme[k] ~= nil then Theme[k] = v end
		end
	end
end)

local COLOR_BG = Theme.BG
local COLOR_SIDEBAR = Theme.SIDEBAR
local COLOR_ACCENT = Theme.ACCENT
local COLOR_BUTTON = Theme.BUTTON
local COLOR_CARD = Theme.CARD

local mainFrameStroke
local ThemeRefs = {}

local function saveTheme()
	pcall(function()
		if getgenv then
			getgenv().ScriptCoreHubTheme = {
				BG = Theme.BG, SIDEBAR = Theme.SIDEBAR, ACCENT = Theme.ACCENT,
				BUTTON = Theme.BUTTON, CARD = Theme.CARD, LogoId = Theme.LogoId,
				BgImageId = Theme.BgImageId, BgImageTransparency = Theme.BgImageTransparency
			}
		end
	end)
end

local function applyTheme()
	COLOR_BG = Theme.BG
	COLOR_SIDEBAR = Theme.SIDEBAR
	COLOR_ACCENT = Theme.ACCENT
	COLOR_BUTTON = Theme.BUTTON
	COLOR_CARD = Theme.CARD

	local mf = ThemeRefs.mainFrame
	local sb = ThemeRefs.sideBar
	if mf then mf.BackgroundColor3 = Theme.BG end
	if sb then sb.BackgroundColor3 = Theme.SIDEBAR end
	if ThemeRefs.mainFrameStroke then ThemeRefs.mainFrameStroke.Color = Theme.ACCENT end
	if ThemeRefs.profileFrame then
		ThemeRefs.profileFrame.BackgroundColor3 = Color3.fromRGB(
			math.clamp(math.floor(Theme.SIDEBAR.R * 255) + 7, 0, 255),
			math.clamp(math.floor(Theme.SIDEBAR.G * 255) + 6, 0, 255),
			math.clamp(math.floor(Theme.SIDEBAR.B * 255) + 5, 0, 255)
		)
	end
	if ThemeRefs.settingsBtn then ThemeRefs.settingsBtn.ImageColor3 = Theme.ACCENT end

	for _, lineName in ipairs({"mainLine", "playerLine", "combatLine", "trollLine"}) do
		local ln = ThemeRefs[lineName]
		if ln then ln.BackgroundColor3 = Theme.ACCENT end
	end

	if ThemeRefs.title then
		local a = Theme.ACCENT
		local r, g, b = math.floor(a.R * 255), math.floor(a.G * 255), math.floor(a.B * 255)
		ThemeRefs.title.Text = string.format(
			"The Script Core Hub - <font color='rgb(%d,%d,%d)'> 🍀 Murder Mystery 2</font>",
			r, g, b
		)
	end

	if ThemeRefs.keybindsScroll then ThemeRefs.keybindsScroll.ScrollBarImageColor3 = Theme.ACCENT end
	if ThemeRefs.backStroke then ThemeRefs.backStroke.Color = Theme.ACCENT end

	if mf then
		for _, d in ipairs(mf:GetDescendants()) do
			if d:IsA("UIStroke") then
				d.Color = Theme.ACCENT
			elseif d:IsA("TextButton") or d:IsA("Frame") then
				local role = d:GetAttribute("ThemeRole")
				if role == "Card" or role == "KeyRow" then
					d.BackgroundColor3 = Theme.CARD
				elseif role == "Button" then
					d.BackgroundColor3 = Theme.BUTTON
				elseif role == "KeyBtn" then
					d.BackgroundColor3 = Color3.fromRGB(
						math.clamp(math.floor(Theme.BUTTON.R * 255) + 5, 0, 255),
						math.clamp(math.floor(Theme.BUTTON.G * 255) + 5, 0, 255),
						math.clamp(math.floor(Theme.BUTTON.B * 255) + 5, 0, 255)
					)
				end
			end
		end
	end

	if ThemeRefs.logoBtn then
		local id = tostring(Theme.LogoId or "")
		if id ~= "" and not id:find("rbxassetid://") and tonumber(id) then id = "rbxassetid://" .. id end
		if id ~= "" then ThemeRefs.logoBtn.Image = id end
	end

	if ThemeRefs.bgImage then
		local id = tostring(Theme.BgImageId or "")
		if id ~= "" and not id:find("rbxassetid://") and tonumber(id) then id = "rbxassetid://" .. id end
		if id == "" then
			ThemeRefs.bgImage.Image = ""
			ThemeRefs.bgImage.Visible = false
		else
			ThemeRefs.bgImage.Image = id
			ThemeRefs.bgImage.ImageTransparency = tonumber(Theme.BgImageTransparency) or 0.65
			ThemeRefs.bgImage.Visible = true
		end
	end

	saveTheme()
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 520)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -240)
mainFrame.BackgroundColor3 = COLOR_BG
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)
mainFrameStroke = Instance.new("UIStroke", mainFrame)
mainFrameStroke.Color = COLOR_ACCENT
ThemeRefs.mainFrame = mainFrame
ThemeRefs.mainFrameStroke = mainFrameStroke

local bgImage = Instance.new("ImageLabel")
bgImage.Name = "CustomBackground"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = ""
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = Theme.BgImageTransparency or 0.65
bgImage.Visible = false
bgImage.ZIndex = 0
bgImage.Parent = mainFrame
ThemeRefs.bgImage = bgImage

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 60, 1, 0)
sideBar.BackgroundColor3 = COLOR_SIDEBAR
sideBar.Parent = mainFrame
Instance.new("UICorner", sideBar)
ThemeRefs.sideBar = sideBar

local logoBtn = Instance.new("ImageButton")
logoBtn.Size = UDim2.new(0, 45, 0, 45)
logoBtn.Position = UDim2.new(0, 7, 0, 10)
logoBtn.BackgroundTransparency = 1
logoBtn.Image = LOGO_ID
logoBtn.Parent = sideBar
ThemeRefs.logoBtn = logoBtn
if Theme.LogoId and Theme.LogoId ~= "" then logoBtn.Image = Theme.LogoId end

local mainTabBtn = Instance.new("TextButton")
mainTabBtn.Size = UDim2.new(0, 125, 0, 45)
mainTabBtn.Position = UDim2.new(0, 8, 0, 80)
mainTabBtn.BackgroundColor3 = COLOR_BUTTON
mainTabBtn.Text = "        MAIN"
mainTabBtn.TextColor3 = Color3.new(1, 1, 1)
mainTabBtn.Font = Enum.Font.GothamBold
mainTabBtn.TextSize = 13
mainTabBtn.TextXAlignment = Enum.TextXAlignment.Left
mainTabBtn.BackgroundTransparency = 1
mainTabBtn.TextTransparency = 1
mainTabBtn.Visible = false
mainTabBtn.Parent = sideBar
Instance.new("UICorner", mainTabBtn)

local mainLine = Instance.new("Frame")
mainLine.Size = UDim2.new(0, 4, 0.6, 0)
mainLine.Position = UDim2.new(0, 4, 0.2, 0)
mainLine.BackgroundColor3 = COLOR_ACCENT
mainLine.BackgroundTransparency = 1
mainLine.Parent = mainTabBtn
ThemeRefs.mainLine = mainLine

local playerTabBtn = Instance.new("TextButton")
playerTabBtn.Size = UDim2.new(0, 125, 0, 45)
playerTabBtn.Position = UDim2.new(0, 8, 0, 135)
playerTabBtn.BackgroundColor3 = COLOR_BUTTON
playerTabBtn.Text = "        PLAYER"
playerTabBtn.TextColor3 = Color3.new(1, 1, 1)
playerTabBtn.Font = Enum.Font.GothamBold
playerTabBtn.TextSize = 13
playerTabBtn.TextXAlignment = Enum.TextXAlignment.Left
playerTabBtn.BackgroundTransparency = 1
playerTabBtn.TextTransparency = 1
playerTabBtn.Visible = false
playerTabBtn.Parent = sideBar
Instance.new("UICorner", playerTabBtn)

local playerLine = Instance.new("Frame")
playerLine.Size = UDim2.new(0, 4, 0.6, 0)
playerLine.Position = UDim2.new(0, 4, 0.2, 0)
playerLine.BackgroundColor3 = COLOR_ACCENT
playerLine.BackgroundTransparency = 1
playerLine.Parent = playerTabBtn
ThemeRefs.playerLine = playerLine

local combatTabBtn = Instance.new("TextButton")
combatTabBtn.Size = UDim2.new(0, 125, 0, 45)
combatTabBtn.Position = UDim2.new(0, 8, 0, 190)
combatTabBtn.BackgroundColor3 = COLOR_BUTTON
combatTabBtn.Text = "        COMBAT"
combatTabBtn.TextColor3 = Color3.new(1, 1, 1)
combatTabBtn.Font = Enum.Font.GothamBold
combatTabBtn.TextSize = 13
combatTabBtn.TextXAlignment = Enum.TextXAlignment.Left
combatTabBtn.BackgroundTransparency = 1
combatTabBtn.TextTransparency = 1
combatTabBtn.Visible = false
combatTabBtn.Parent = sideBar
Instance.new("UICorner", combatTabBtn)

local combatLine = Instance.new("Frame")
combatLine.Size = UDim2.new(0, 4, 0.6, 0)
combatLine.Position = UDim2.new(0, 4, 0.2, 0)
combatLine.BackgroundColor3 = COLOR_ACCENT
combatLine.BackgroundTransparency = 1
combatLine.Parent = combatTabBtn
ThemeRefs.combatLine = combatLine

local trollTabBtn = Instance.new("TextButton")
trollTabBtn.Size = UDim2.new(0, 125, 0, 45)
trollTabBtn.Position = UDim2.new(0, 8, 0, 245)
trollTabBtn.BackgroundColor3 = COLOR_BUTTON
trollTabBtn.Text = "        TROLL"
trollTabBtn.TextColor3 = Color3.new(1, 1, 1)
trollTabBtn.Font = Enum.Font.GothamBold
trollTabBtn.TextSize = 13
trollTabBtn.TextXAlignment = Enum.TextXAlignment.Left
trollTabBtn.BackgroundTransparency = 1
trollTabBtn.TextTransparency = 1
trollTabBtn.Visible = false
trollTabBtn.Parent = sideBar
Instance.new("UICorner", trollTabBtn)

local trollLine = Instance.new("Frame")
trollLine.Size = UDim2.new(0, 4, 0.6, 0)
trollLine.Position = UDim2.new(0, 4, 0.2, 0)
trollLine.BackgroundColor3 = COLOR_ACCENT
trollLine.BackgroundTransparency = 1
trollLine.Parent = trollTabBtn
ThemeRefs.trollLine = trollLine

local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0, 45, 0, 45)
profileFrame.Position = UDim2.new(0, 7.5, 1, -55)
profileFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
profileFrame.BorderSizePixel = 0
profileFrame.ZIndex = 10
profileFrame.Parent = sideBar
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 10)

local profileAvatar = Instance.new("ImageLabel")
profileAvatar.Size = UDim2.new(0, 34, 0, 34)
profileAvatar.Position = UDim2.new(0, 5.5, 0.5, -17)
profileAvatar.BackgroundColor3 = COLOR_SIDEBAR
profileAvatar.BorderSizePixel = 0
profileAvatar.ZIndex = 11
profileAvatar.Parent = profileFrame
Instance.new("UICorner", profileAvatar).CornerRadius = UDim.new(1, 0)

local profileDisplayName = Instance.new("TextLabel")
profileDisplayName.Size = UDim2.new(1, -70, 0, 18)
profileDisplayName.Position = UDim2.new(0, 46, 0, 6)
profileDisplayName.BackgroundTransparency = 1
profileDisplayName.Text = LocalPlayer.DisplayName
profileDisplayName.TextColor3 = Color3.new(1, 1, 1)
profileDisplayName.Font = Enum.Font.GothamBold
profileDisplayName.TextSize = 12
profileDisplayName.TextXAlignment = Enum.TextXAlignment.Left
profileDisplayName.TextTruncate = Enum.TextTruncate.AtEnd
profileDisplayName.Visible = false
profileDisplayName.ZIndex = 11
profileDisplayName.Parent = profileFrame

local profileUserName = Instance.new("TextLabel")
profileUserName.Size = UDim2.new(1, -70, 0, 16)
profileUserName.Position = UDim2.new(0, 46, 0, 24)
profileUserName.BackgroundTransparency = 1
profileUserName.Text = "@" .. LocalPlayer.Name
profileUserName.TextColor3 = Color3.fromRGB(160, 160, 160)
profileUserName.Font = Enum.Font.Gotham
profileUserName.TextSize = 11
profileUserName.TextXAlignment = Enum.TextXAlignment.Left
profileUserName.TextTruncate = Enum.TextTruncate.AtEnd
profileUserName.Visible = false
profileUserName.ZIndex = 11
profileUserName.Parent = profileFrame

local settingsBtn = Instance.new("ImageButton")
settingsBtn.Size = UDim2.new(0, 20, 0, 20)
settingsBtn.Position = UDim2.new(1, -26, 0.5, -10)
settingsBtn.BackgroundTransparency = 1
settingsBtn.Image = "rbxassetid://6031280882"
settingsBtn.ImageColor3 = COLOR_ACCENT
settingsBtn.Visible = false
settingsBtn.ZIndex = 12
settingsBtn.Parent = profileFrame
ThemeRefs.profileFrame = profileFrame
ThemeRefs.settingsBtn = settingsBtn

task.spawn(function()
	local success, content = pcall(function()
		return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if success and content then profileAvatar.Image = content end
end)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -60, 1, 0)
contentFrame.Position = UDim2.new(0, 60, 0, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "The Script Core Hub - <font color='rgb(224,63,224)'> 🍀 Murder Mystery 2</font>"
title.RichText = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = contentFrame
ThemeRefs.title = title

local mainPage = Instance.new("Frame")
mainPage.Name = "MainPage"
mainPage.Size = UDim2.new(1, 0, 1, -50)
mainPage.Position = UDim2.new(0, 0, 0, 50)
mainPage.BackgroundTransparency = 1
mainPage.Visible = true
mainPage.Parent = contentFrame

local playerPage = Instance.new("Frame")
playerPage.Name = "PlayerPage"
playerPage.Size = UDim2.new(1, 0, 1, -50)
playerPage.Position = UDim2.new(0, 0, 0, 50)
playerPage.BackgroundTransparency = 1
playerPage.Visible = false
playerPage.Parent = contentFrame

local combatPage = Instance.new("Frame")
combatPage.Name = "CombatPage"
combatPage.Size = UDim2.new(1, 0, 1, -50)
combatPage.Position = UDim2.new(0, 0, 0, 50)
combatPage.BackgroundTransparency = 1
combatPage.Visible = false
combatPage.Parent = contentFrame

local trollPage = Instance.new("Frame")
trollPage.Name = "TrollPage"
trollPage.Size = UDim2.new(1, 0, 1, -50)
trollPage.Position = UDim2.new(0, 0, 0, 50)
trollPage.BackgroundTransparency = 1
trollPage.Visible = false
trollPage.Parent = contentFrame

local keybindsPage = Instance.new("Frame")
keybindsPage.Name = "KeybindsPage"
keybindsPage.Size = UDim2.new(1, 0, 1, -50)
keybindsPage.Position = UDim2.new(0, 0, 0, 50)
keybindsPage.BackgroundTransparency = 1
keybindsPage.Visible = false
keybindsPage.Parent = contentFrame

local keybindsTitle = Instance.new("TextLabel")
keybindsTitle.Size = UDim2.new(1, -20, 0, 30)
keybindsTitle.Position = UDim2.new(0, 15, 0, 5)
keybindsTitle.BackgroundTransparency = 1
keybindsTitle.Text = "Keybinds  ·  click to change"
keybindsTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
keybindsTitle.Font = Enum.Font.Gotham
keybindsTitle.TextSize = 14
keybindsTitle.TextXAlignment = Enum.TextXAlignment.Left
keybindsTitle.Parent = keybindsPage

local backBtn = Instance.new("TextButton")
backBtn.Size = UDim2.new(0, 70, 0, 28)
backBtn.Position = UDim2.new(0, 15, 0, 40)
backBtn.BackgroundColor3 = COLOR_CARD
backBtn.Text = "← Back"
backBtn.TextColor3 = Color3.new(1, 1, 1)
backBtn.Font = Enum.Font.GothamBold
backBtn.TextSize = 13
backBtn.Parent = keybindsPage
Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0, 6)
local backStroke = Instance.new("UIStroke", backBtn)
backStroke.Color = COLOR_ACCENT
backStroke.Transparency = 0.5
ThemeRefs.backStroke = backStroke

local keybindsScroll = Instance.new("ScrollingFrame")
keybindsScroll.Size = UDim2.new(1, -20, 1, -85)
keybindsScroll.Position = UDim2.new(0, 10, 0, 80)
keybindsScroll.BackgroundTransparency = 1
keybindsScroll.BorderSizePixel = 0
keybindsScroll.ScrollBarThickness = 4
keybindsScroll.ScrollBarImageColor3 = COLOR_ACCENT
keybindsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
keybindsScroll.Parent = keybindsPage
ThemeRefs.keybindsScroll = keybindsScroll

local keybindsLayout = Instance.new("UIListLayout")
keybindsLayout.SortOrder = Enum.SortOrder.LayoutOrder
keybindsLayout.Padding = UDim.new(0, 8)
keybindsLayout.Parent = keybindsScroll

local keybinds = {
	ToggleMenu = Enum.KeyCode.RightControl, Fly = Enum.KeyCode.F, Speed = Enum.KeyCode.V,
	Noclip = Enum.KeyCode.N, AntiFling = Enum.KeyCode.X, InfiniteJump = Enum.KeyCode.J,
	NameESP = Enum.KeyCode.E, TouchFling = Enum.KeyCode.T, LoopFling = Enum.KeyCode.L,
	GunAimbot = Enum.KeyCode.G
}

local keybindLabels = {
	ToggleMenu = "Toggle Menu", Fly = "Fly", Speed = "Speed", Noclip = "Noclip",
	AntiFling = "Anti Fling", InfiniteJump = "Infinite Jump", NameESP = "Name ESP",
	TouchFling = "Touch Fling", LoopFling = "Loop Fling", GunAimbot = "Gun Aimbot"
}

local keybindOrder = {
	"ToggleMenu", "Fly", "Speed", "Noclip", "AntiFling", "InfiniteJump", "NameESP",
	"TouchFling", "LoopFling", "GunAimbot"
}

local waitingForKey = nil
local keybindButtons = {}

function getKeyName(keyCode)
	if not keyCode then return "None" end
	local name = tostring(keyCode):gsub("Enum.KeyCode.", "")
	if name == "RightControl" then return "RCtrl" end
	if name == "LeftControl" then return "LCtrl" end
	if name == "RightShift" then return "RShift" end
	if name == "LeftShift" then return "LShift" end
	return name
end

function createKeybindRow(name)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -10, 0, 36)
	row.BackgroundColor3 = Theme.CARD
	row.BorderSizePixel = 0
	row.Parent = keybindsScroll
	row:SetAttribute("ThemeRole", "KeyRow")
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -90, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = keybindLabels[name]
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local keyBtn = Instance.new("TextButton")
	keyBtn.Size = UDim2.new(0, 70, 0, 26)
	keyBtn.Position = UDim2.new(1, -80, 0.5, -13)
	keyBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
	keyBtn.Text = getKeyName(keybinds[name])
	keyBtn.TextColor3 = Color3.new(1, 1, 1)
	keyBtn.Font = Enum.Font.GothamBold
	keyBtn.TextSize = 13
	keyBtn.Parent = row
	keyBtn:SetAttribute("ThemeRole", "KeyBtn")
	Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

	keybindButtons[name] = keyBtn

	keyBtn.MouseButton1Click:Connect(function()
		if waitingForKey then return end
		waitingForKey = name
		keyBtn.Text = "..."
		keyBtn.TextColor3 = COLOR_ACCENT
	end)
end

local appearanceHeader = Instance.new("TextLabel")
appearanceHeader.Size = UDim2.new(1, -10, 0, 22)
appearanceHeader.BackgroundTransparency = 1
appearanceHeader.Text = "Appearance"
appearanceHeader.TextColor3 = Color3.fromRGB(180, 180, 180)
appearanceHeader.Font = Enum.Font.GothamBold
appearanceHeader.TextSize = 13
appearanceHeader.TextXAlignment = Enum.TextXAlignment.Left
appearanceHeader.Parent = keybindsScroll

local presetRow = Instance.new("Frame")
presetRow.Size = UDim2.new(1, -10, 0, 70)
presetRow.BackgroundColor3 = Theme.CARD
presetRow.BorderSizePixel = 0
presetRow.Parent = keybindsScroll
presetRow:SetAttribute("ThemeRole", "KeyRow")
Instance.new("UICorner", presetRow).CornerRadius = UDim.new(0, 8)

local presetLabel = Instance.new("TextLabel")
presetLabel.Size = UDim2.new(1, -12, 0, 20)
presetLabel.Position = UDim2.new(0, 10, 0, 4)
presetLabel.BackgroundTransparency = 1
presetLabel.Text = "Accent color"
presetLabel.TextColor3 = Color3.new(1, 1, 1)
presetLabel.Font = Enum.Font.GothamMedium
presetLabel.TextSize = 12
presetLabel.TextXAlignment = Enum.TextXAlignment.Left
presetLabel.Parent = presetRow

local ACCENT_PRESETS = {
	{ name = "Purple",  color = Color3.fromRGB(224, 63, 224) },
	{ name = "Pink",    color = Color3.fromRGB(255, 105, 180) },
	{ name = "Blue",    color = Color3.fromRGB(64, 156, 255) },
	{ name = "Cyan",    color = Color3.fromRGB(0, 220, 220) },
	{ name = "Green",   color = Color3.fromRGB(80, 220, 120) },
	{ name = "Orange",  color = Color3.fromRGB(255, 140, 50) },
	{ name = "Red",     color = Color3.fromRGB(240, 70, 70) },
	{ name = "Yellow",  color = Color3.fromRGB(240, 200, 50) },
	{ name = "White",   color = Color3.fromRGB(230, 230, 235) },
}

local function makeAccentFrom(accent)
	local function mix(c, t, amt)
		return Color3.new(c.R + (t.R - c.R)*amt, c.G + (t.G - c.G)*amt, c.B + (t.B - c.B)*amt)
	end
	local dark = Color3.fromRGB(10, 8, 18)
	Theme.ACCENT = accent
	Theme.BG = mix(dark, accent, 0.06)
	Theme.SIDEBAR = mix(dark, accent, 0.10)
	Theme.BUTTON = mix(Color3.fromRGB(28, 22, 40), accent, 0.18)
	Theme.CARD = mix(Color3.fromRGB(18, 14, 28), accent, 0.12)
	applyTheme()
end

for i, preset in ipairs(ACCENT_PRESETS) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 28, 0, 28)
	b.Position = UDim2.new(0, 10 + (i-1)*34, 0, 30)
	b.BackgroundColor3 = preset.color
	b.Text = ""
	b.BorderSizePixel = 0
	b.Parent = presetRow
	Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
	local st = Instance.new("UIStroke", b)
	st.Color = Color3.new(1, 1, 1)
	st.Transparency = 0.7
	st.Thickness = 1
	b.MouseButton1Click:Connect(function() makeAccentFrom(preset.color) end)
end

local resetThemeBtn = Instance.new("TextButton")
resetThemeBtn.Size = UDim2.new(1, -10, 0, 34)
resetThemeBtn.BackgroundColor3 = Theme.CARD
resetThemeBtn.Text = "Reset to Default (Purple)"
resetThemeBtn.TextColor3 = Color3.new(1, 1, 1)
resetThemeBtn.Font = Enum.Font.GothamBold
resetThemeBtn.TextSize = 12
resetThemeBtn.Parent = keybindsScroll
resetThemeBtn:SetAttribute("ThemeRole", "Card")
Instance.new("UICorner", resetThemeBtn).CornerRadius = UDim.new(0, 8)
local rst = Instance.new("UIStroke", resetThemeBtn)
rst.Color = Theme.ACCENT
rst.Transparency = 0.5
resetThemeBtn.MouseButton1Click:Connect(function()
	Theme.BG = DEFAULT_THEME.BG
	Theme.SIDEBAR = DEFAULT_THEME.SIDEBAR
	Theme.ACCENT = DEFAULT_THEME.ACCENT
	Theme.BUTTON = DEFAULT_THEME.BUTTON
	Theme.CARD = DEFAULT_THEME.CARD
	Theme.LogoId = DEFAULT_THEME.LogoId
	Theme.BgImageId = DEFAULT_THEME.BgImageId
	Theme.BgImageTransparency = DEFAULT_THEME.BgImageTransparency
	applyTheme()
end)

local function normalizeAssetId(text)
	text = tostring(text or ""):gsub("%s+", "")
	if text == "" then return "" end
	if text:find("rbxassetid://") then return text end
	if text:find("http") then return text end
	if tonumber(text) then return "rbxassetid://" .. text end
	return text
end

local imagesHeader = Instance.new("TextLabel")
imagesHeader.Size = UDim2.new(1, -10, 0, 22)
imagesHeader.BackgroundTransparency = 1
imagesHeader.Text = "Custom Images"
imagesHeader.TextColor3 = Color3.fromRGB(180, 180, 180)
imagesHeader.Font = Enum.Font.GothamBold
imagesHeader.TextSize = 13
imagesHeader.TextXAlignment = Enum.TextXAlignment.Left
imagesHeader.Parent = keybindsScroll

local function makeImageRow(titleText, placeholder, getValue, onApply, onClear)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -10, 0, 72)
	row.BackgroundColor3 = Theme.CARD
	row.BorderSizePixel = 0
	row.Parent = keybindsScroll
	row:SetAttribute("ThemeRole", "KeyRow")
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local lab = Instance.new("TextLabel")
	lab.Size = UDim2.new(1, -12, 0, 18)
	lab.Position = UDim2.new(0, 10, 0, 4)
	lab.BackgroundTransparency = 1
	lab.Text = titleText
	lab.TextColor3 = Color3.new(1, 1, 1)
	lab.Font = Enum.Font.GothamMedium
	lab.TextSize = 12
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.Parent = row

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -100, 0, 28)
	box.Position = UDim2.new(0, 10, 0, 28)
	box.BackgroundColor3 = Color3.fromRGB(30, 24, 45)
	box.Text = getValue() or ""
	box.PlaceholderText = placeholder
	box.TextColor3 = Color3.new(1, 1, 1)
	box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
	box.Font = Enum.Font.Gotham
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Parent = row
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	local pad = Instance.new("UIPadding", box)
	pad.PaddingLeft = UDim.new(0, 8)

	local applyBtn = Instance.new("TextButton")
	applyBtn.Size = UDim2.new(0, 40, 0, 28)
	applyBtn.Position = UDim2.new(1, -86, 0, 28)
	applyBtn.BackgroundColor3 = Theme.ACCENT
	applyBtn.Text = "Set"
	applyBtn.TextColor3 = Color3.new(1, 1, 1)
	applyBtn.Font = Enum.Font.GothamBold
	applyBtn.TextSize = 12
	applyBtn.Parent = row
	Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)
	applyBtn:SetAttribute("ThemeRole", "Card")

	local clearBtn = Instance.new("TextButton")
	clearBtn.Size = UDim2.new(0, 36, 0, 28)
	clearBtn.Position = UDim2.new(1, -42, 0, 28)
	clearBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 40)
	clearBtn.Text = "X"
	clearBtn.TextColor3 = Color3.new(1, 1, 1)
	clearBtn.Font = Enum.Font.GothamBold
	clearBtn.TextSize = 12
	clearBtn.Parent = row
	Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

	applyBtn.MouseButton1Click:Connect(function()
		onApply(normalizeAssetId(box.Text))
		box.Text = getValue() or ""
	end)
	clearBtn.MouseButton1Click:Connect(function()
		onClear()
		box.Text = ""
	end)
	return row
end

makeImageRow("Logo (Asset ID)", "ej: 91349847555817",
	function() local id = tostring(Theme.LogoId or "") return id:gsub("rbxassetid://","") end,
	function(id)
		if id == "" then id = DEFAULT_THEME.LogoId end
		Theme.LogoId = id
		applyTheme()
		print("[Theme] Logo →", id)
	end,
	function()
		Theme.LogoId = DEFAULT_THEME.LogoId
		applyTheme()
		print("[Theme] Logo reset")
	end)

makeImageRow("Background image (Asset ID)", "ej: 123456789  (vacío = off)",
	function() local id = tostring(Theme.BgImageId or "") return id:gsub("rbxassetid://","") end,
	function(id)
		Theme.BgImageId = id
		applyTheme()
		print("[Theme] Background →", id ~= "" and id or "OFF")
	end,
	function()
		Theme.BgImageId = ""
		applyTheme()
		print("[Theme] Background off")
	end)

local bgTRow = Instance.new("Frame")
bgTRow.Size = UDim2.new(1, -10, 0, 50)
bgTRow.BackgroundColor3 = Theme.CARD
bgTRow.BorderSizePixel = 0
bgTRow.Parent = keybindsScroll
bgTRow:SetAttribute("ThemeRole", "KeyRow")
Instance.new("UICorner", bgTRow).CornerRadius = UDim.new(0, 8)

local bgTLab = Instance.new("TextLabel")
bgTLab.Size = UDim2.new(1, -12, 0, 18)
bgTLab.Position = UDim2.new(0, 10, 0, 4)
bgTLab.BackgroundTransparency = 1
bgTLab.Text = "Background transparency (0 = visible, 1 = invisible)"
bgTLab.TextColor3 = Color3.new(1, 1, 1)
bgTLab.Font = Enum.Font.GothamMedium
bgTLab.TextSize = 11
bgTLab.TextXAlignment = Enum.TextXAlignment.Left
bgTLab.Parent = bgTRow

local bgTBox = Instance.new("TextBox")
bgTBox.Size = UDim2.new(0, 70, 0, 24)
bgTBox.Position = UDim2.new(0, 10, 0, 22)
bgTBox.BackgroundColor3 = Color3.fromRGB(30, 24, 45)
bgTBox.Text = tostring(Theme.BgImageTransparency or 0.65)
bgTBox.TextColor3 = Color3.new(1, 1, 1)
bgTBox.Font = Enum.Font.GothamBold
bgTBox.TextSize = 12
bgTBox.Parent = bgTRow
Instance.new("UICorner", bgTBox).CornerRadius = UDim.new(0, 6)

local bgTApply = Instance.new("TextButton")
bgTApply.Size = UDim2.new(0, 50, 0, 24)
bgTApply.Position = UDim2.new(0, 88, 0, 22)
bgTApply.BackgroundColor3 = Theme.ACCENT
bgTApply.Text = "Set"
bgTApply.TextColor3 = Color3.new(1, 1, 1)
bgTApply.Font = Enum.Font.GothamBold
bgTApply.TextSize = 12
bgTApply.Parent = bgTRow
Instance.new("UICorner", bgTApply).CornerRadius = UDim.new(0, 6)
bgTApply.MouseButton1Click:Connect(function()
	local n = tonumber(bgTBox.Text)
	if n then
		Theme.BgImageTransparency = math.clamp(n, 0, 1)
		bgTBox.Text = tostring(Theme.BgImageTransparency)
		applyTheme()
	end
end)

local keybindsHeader = Instance.new("TextLabel")
keybindsHeader.Size = UDim2.new(1, -10, 0, 22)
keybindsHeader.BackgroundTransparency = 1
keybindsHeader.Text = "Keybinds"
keybindsHeader.TextColor3 = Color3.fromRGB(180, 180, 180)
keybindsHeader.Font = Enum.Font.GothamBold
keybindsHeader.TextSize = 13
keybindsHeader.TextXAlignment = Enum.TextXAlignment.Left
keybindsHeader.Parent = keybindsScroll

for _, name in ipairs(keybindOrder) do
	createKeybindRow(name)
end

keybindsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	keybindsScroll.CanvasSize = UDim2.new(0, 0, 0, keybindsLayout.AbsoluteContentSize.Y + 10)
end)
keybindsScroll.CanvasSize = UDim2.new(0, 0, 0, keybindsLayout.AbsoluteContentSize.Y + 10)

local isSidebarOpen = false
local currentPage = "MAIN"
local previousPage = "MAIN"

function selectPage(page)
	currentPage = page
	mainPage.Visible = (page == "MAIN")
	playerPage.Visible = (page == "PLAYER")
	combatPage.Visible = (page == "COMBAT")
	trollPage.Visible = (page == "TROLL")
	keybindsPage.Visible = (page == "KEYBINDS")

	if isSidebarOpen then
		mainLine.BackgroundTransparency = (page == "MAIN") and 0 or 1
		playerLine.BackgroundTransparency = (page == "PLAYER") and 0 or 1
		combatLine.BackgroundTransparency = (page == "COMBAT") and 0 or 1
		trollLine.BackgroundTransparency = (page == "TROLL") and 0 or 1
	end
end

function toggleSidebar()
	isSidebarOpen = not isSidebarOpen
	local targetSize = isSidebarOpen and 140 or 60
	local transparency = isSidebarOpen and 0 or 1
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	if isSidebarOpen then
		mainTabBtn.Visible = true
		playerTabBtn.Visible = true
		combatTabBtn.Visible = true
		trollTabBtn.Visible = true
	end

	TweenService:Create(sideBar, tweenInfo, {Size = UDim2.new(0, targetSize, 1, 0)}):Play()
	TweenService:Create(contentFrame, tweenInfo, {
		Position = UDim2.new(0, targetSize, 0, 0),
		Size = UDim2.new(1, -targetSize, 1, 0)
	}):Play()

	TweenService:Create(mainTabBtn, tweenInfo, {BackgroundTransparency = transparency, TextTransparency = transparency}):Play()
	TweenService:Create(playerTabBtn, tweenInfo, {BackgroundTransparency = transparency, TextTransparency = transparency}):Play()
	TweenService:Create(combatTabBtn, tweenInfo, {BackgroundTransparency = transparency, TextTransparency = transparency}):Play()
	TweenService:Create(trollTabBtn, tweenInfo, {BackgroundTransparency = transparency, TextTransparency = transparency}):Play()

	TweenService:Create(mainLine, tweenInfo, {BackgroundTransparency = (currentPage == "MAIN" and transparency or 1)}):Play()
	TweenService:Create(playerLine, tweenInfo, {BackgroundTransparency = (currentPage == "PLAYER" and transparency or 1)}):Play()
	TweenService:Create(combatLine, tweenInfo, {BackgroundTransparency = (currentPage == "COMBAT" and transparency or 1)}):Play()
	TweenService:Create(trollLine, tweenInfo, {BackgroundTransparency = (currentPage == "TROLL" and transparency or 1)}):Play()

	if isSidebarOpen then
		profileFrame.Size = UDim2.new(0, 124, 0, 48)
		profileDisplayName.Visible = true
		profileUserName.Visible = true
		settingsBtn.Visible = true
	else
		profileFrame.Size = UDim2.new(0, 45, 0, 45)
		profileDisplayName.Visible = false
		profileUserName.Visible = false
		settingsBtn.Visible = false
	end

	if not isSidebarOpen then
		task.delay(0.4, function()
			if not isSidebarOpen then
				mainTabBtn.Visible = false
				playerTabBtn.Visible = false
				combatTabBtn.Visible = false
				trollTabBtn.Visible = false
			end
		end)
	end
end

logoBtn.MouseButton1Click:Connect(toggleSidebar)
mainTabBtn.MouseButton1Click:Connect(function() selectPage("MAIN") end)
playerTabBtn.MouseButton1Click:Connect(function() selectPage("PLAYER") end)
combatTabBtn.MouseButton1Click:Connect(function() selectPage("COMBAT") end)
trollTabBtn.MouseButton1Click:Connect(function() selectPage("TROLL") end)

settingsBtn.MouseButton1Click:Connect(function()
	previousPage = currentPage
	selectPage("KEYBINDS")
end)

backBtn.MouseButton1Click:Connect(function()
	selectPage(previousPage or "MAIN")
end)

function makeDraggable(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end
makeDraggable(mainFrame)

local selectedPlayerName = nil
local selectedPlayerUserId = nil
local isTouchFlingActive = false
local isProtectActive = false
local isLoopGotoActive = false
local isGunAimbotActive = false
local isInfiniteJumpActive = false
local isAutoFarmCoins = false
local isSpeedActive = false
local isNameESPActive = false
local isFlyActive = false
local isLoopFlingActive = false
local isNoclipActive = false
local isAntiFlingActive = false
local isCombatAimbotActive = false
local isAutoShotActive = false
local isKillAuraActive = false
local isSelfFlinging = false
local currentSpeed = 50
local killAuraRange = 20
local flySpeed = 80

local loopGotoConnection = nil
local touchFlingConnection = nil
local aimbotConnection = nil
local infJumpConnection = nil
local speedConnection = nil
local nameESPConnection = nil
local flyConnection = nil
local flyBodyVelocity = nil
local loopFlingConnection = nil
local loopFlingBAV = nil
local noclipConnection = nil
local antiFlingConnection = nil
local protectConnection = nil
local combatAimbotConnection = nil
local autoShotConnection = nil
local killAuraConnection = nil
local protectBtn = nil

local sessionStart = tick()
local autoGrabGun = false
local isSpectating = false
local Char, Hum, Root
local loopGotoBtn
local loopFlingBtn
local spectateBtn
local startLoopGoto
local startLoopFling
local normalWalkSpeed = 16
local guiVisible = true

local speedBtn, flyBtn, noclipBtn, antiFlingBtn, infJumpBtn, nameESPBtn, touchFlingBtn, gunAimbotBtn
local combatAimbotBtn, autoShotBtn, killAuraBtn

function updateCharacter()
	Char = LocalPlayer.Character
	Hum = Char and Char:FindFirstChildWhichIsA("Humanoid")
	Root = (Hum and Hum.RootPart) or (Char and Char:FindFirstChild("HumanoidRootPart"))
end
updateCharacter()

function cleanupConnections()
	if touchFlingConnection then pcall(function() task.cancel(touchFlingConnection) end) touchFlingConnection = nil end
	if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
	if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
	if speedConnection then speedConnection:Disconnect() speedConnection = nil end
	if nameESPConnection then nameESPConnection:Disconnect() nameESPConnection = nil end
	if flyConnection then flyConnection:Disconnect() flyConnection = nil end
	if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
	if loopFlingConnection then
		pcall(function()
			if typeof(loopFlingConnection) == "RBXScriptConnection" then
				loopFlingConnection:Disconnect()
			else
				task.cancel(loopFlingConnection)
			end
		end)
		loopFlingConnection = nil
	end
	if loopFlingBAV then pcall(function() loopFlingBAV:Destroy() end) loopFlingBAV = nil end
	if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
	if antiFlingConnection then antiFlingConnection:Disconnect() antiFlingConnection = nil end
	if protectConnection then protectConnection:Disconnect() protectConnection = nil end
	if combatAimbotConnection then combatAimbotConnection:Disconnect() combatAimbotConnection = nil end
	if autoShotConnection then autoShotConnection:Disconnect() autoShotConnection = nil end
	if killAuraConnection then killAuraConnection:Disconnect() killAuraConnection = nil end
	if loopGotoConnection then loopGotoConnection:Disconnect() loopGotoConnection = nil end
end

function reapplyActiveFeatures()
	updateCharacter()
	if not (Char and Hum and Root) then return end

	if isSpeedActive then
		if speedConnection then speedConnection:Disconnect() end
		speedConnection = RunService.Heartbeat:Connect(function()
			updateCharacter()
			if Hum and Hum.Parent then Hum.WalkSpeed = currentSpeed end
		end)
	end

	if isFlyActive then
		if flyBodyVelocity then flyBodyVelocity:Destroy() end
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Name = "FlyVelocity"
		flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		flyBodyVelocity.Velocity = Vector3.zero
		flyBodyVelocity.Parent = Root
		if flyConnection then flyConnection:Disconnect() end
		flyConnection = RunService.RenderStepped:Connect(function()
			if not isFlyActive or not Root or not Root.Parent then return end
			local cam = Workspace.CurrentCamera
			local moveDir = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
			if moveDir.Magnitude > 0 then
				flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
			else
				flyBodyVelocity.Velocity = Vector3.zero
			end
		end)
	end

	if isNoclipActive then
		if noclipConnection then noclipConnection:Disconnect() end
		noclipConnection = RunService.Stepped:Connect(function()
			if not isNoclipActive then return end
			updateCharacter()
			if Char then
				for _, part in ipairs(Char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	end

	if isAntiFlingActive then toggleAntiFling(true) end
	if isInfiniteJumpActive then
		if infJumpConnection then infJumpConnection:Disconnect() end
		infJumpConnection = UserInputService.JumpRequest:Connect(function()
			if not isInfiniteJumpActive then return end
			updateCharacter()
			if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end)
	end

	if isNameESPActive then
		if nameESPConnection then nameESPConnection:Disconnect() end
		nameESPConnection = RunService.Heartbeat:Connect(function()
			pcall(updateNameESP)
		end)
	end

	if isTouchFlingActive then toggleTouchFling(true) end
	if isGunAimbotActive then toggleGunAimbot(true) end
	if isCombatAimbotActive then toggleCombatAimbot(true) end
	if isAutoShotActive then toggleAutoShot(true) end
	if isKillAuraActive then toggleKillAura(true) end

	if isLoopGotoActive and selectedPlayerName and startLoopGoto then startLoopGoto() end
	if isLoopFlingActive and selectedPlayerName and startLoopFling then startLoopFling() end
end

LocalPlayer.CharacterAdded:Connect(function()
	cleanupConnections()
	isSelfFlinging = false
	task.wait(0.5)
	updateCharacter()
	reapplyActiveFeatures()
end)

function findPlayer(key)
	if typeof(key) == "Instance" and key:IsA("Player") then return key end
	if type(key) == "number" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.UserId == key then return p end
		end
	end
	local s = tostring(key)
	local byName = Players:FindFirstChild(s)
	if byName then return byName end
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name == s or p.DisplayName == s or tostring(p.UserId) == s then return p end
	end
	return nil
end

function normalizeRole(role)
	if type(role) ~= "string" then return "" end
	return role:lower():gsub("%s+", "")
end

function isMurdererRole(role)
	local r = normalizeRole(role)
	return r == "murderer" or r == "murder" or r == "asesino" or r == "asesina" or r:find("murder", 1, true) ~= nil or r:find("asesin", 1, true) ~= nil
end

function isSheriffRole(role)
	local r = normalizeRole(role)
	return r == "sheriff" or r == "sherif" or r == "hero" or r == "heroe" or r == "héroe" or r:find("sheriff", 1, true) ~= nil or r:find("hero", 1, true) ~= nil
end

function playerIsAlive(plr)
	if not plr or not plr.Character then return false end
	local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
	return hum ~= nil and hum.Health > 0
end

function playerHasTool(plr, keywords)
	local function scan(container)
		if not container then return false end
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("Tool") then
				local n = child.Name:lower()
				for _, key in ipairs(keywords) do
					if n:find(key, 1, true) then return true end
				end
			end
		end
		return false
	end
	return scan(plr.Character) or scan(plr:FindFirstChild("Backpack"))
end

function getRoles()
	local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
	if not remote then return {} end
	local ok, data = pcall(function() return remote:InvokeServer() end)
	if not ok or type(data) ~= "table" then return {} end
	local roles = {}
	for key, plrData in pairs(data) do
		if type(plrData) == "table" and not plrData.Dead and plrData.Role then
			local plr = findPlayer(key)
			if plr then roles[plr.Name] = plrData.Role end
		end
	end
	return roles
end

function getMurdererPlayer()
	local roles = getRoles()
	for plrName, role in pairs(roles) do
		if isMurdererRole(role) then
			local plr = findPlayer(plrName)
			if plr and plr ~= LocalPlayer and playerIsAlive(plr) then return plr end
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and playerIsAlive(plr) then
			if playerHasTool(plr, {"knife", "cuchillo", "dagger", "blade", "karambit", "bayonet"}) then return plr end
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and playerIsAlive(plr) then
			local role = plr:GetAttribute("Role") or plr:GetAttribute("role")
			if role and isMurdererRole(tostring(role)) then return plr end
		end
	end
	return nil
end

function getSheriffPlayer()
	local roles = getRoles()
	for plrName, role in pairs(roles) do
		if isSheriffRole(role) then
			local plr = findPlayer(plrName)
			if plr and plr ~= LocalPlayer and playerIsAlive(plr) then return plr end
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and playerIsAlive(plr) then
			if playerHasTool(plr, {"gun", "pistol", "revolver", "sheriff", "handgun"}) then return plr end
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and playerIsAlive(plr) then
			local role = plr:GetAttribute("Role") or plr:GetAttribute("role")
			if role and isSheriffRole(tostring(role)) then return plr end
		end
	end
	return nil
end

function GrabGun()
	updateCharacter()
	if not (Char and Root) then return end
	local gun = Workspace:FindFirstChild("GunDrop", true)
	if not gun then return end
	local gunPart = gun:IsA("BasePart") and gun or gun:FindFirstChildWhichIsA("BasePart", true)
	if not gunPart then return end
	if type(firetouchinterest) == "function" then
		pcall(function()
			firetouchinterest(Root, gunPart, 0)
			task.wait(0.03)
			firetouchinterest(Root, gunPart, 1)
		end)
	else
		safeTeleport(gunPart.CFrame * CFrame.new(0, 2, 0))
	end
end

function safeTeleport(cframe)
	updateCharacter()
	if Char and Root then
		Root.AssemblyLinearVelocity = Vector3.zero
		Root.AssemblyAngularVelocity = Vector3.zero
		Char:PivotTo(cframe)
		task.defer(function()
			if Root then
				Root.AssemblyLinearVelocity = Vector3.zero
				Root.AssemblyAngularVelocity = Vector3.zero
			end
		end)
	end
end

function teleportToMap()
	updateCharacter()
	if not (Char and Root) then return end
	local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
	if coinContainer then
		local part = coinContainer:FindFirstChildWhichIsA("BasePart", true)
		if part then
			safeTeleport(part.CFrame * CFrame.new(0, 5, 0))
			return
		end
	end
	local possibleMaps = {"Map", "CurrentMap", "GameMap", "ActiveMap", "Mapa", "RoundMap"}
	for _, name in ipairs(possibleMaps) do
		local map = Workspace:FindFirstChild(name, true)
		if map then
			local spawn = map:FindFirstChild("Spawns", true) or map:FindFirstChild("Spawn", true) or map:FindFirstChildWhichIsA("SpawnLocation", true)
			if spawn then
				safeTeleport(spawn.CFrame * CFrame.new(0, 5, 0))
				return
			end
		end
	end
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Size.Magnitude > 50 and not obj:IsDescendantOf(Workspace:FindFirstChild("Lobby")) then
			safeTeleport(obj.CFrame * CFrame.new(0, 10, 0))
			return
		end
	end
end

function teleportToLobby()
	updateCharacter()
	if not (Char and Root) then return end
	local lobbyNames = {"Lobby", "lobby", "LOBBY", "WaitingRoom", "Menu", "Hub"}
	for _, name in ipairs(lobbyNames) do
		local lobby = Workspace:FindFirstChild(name, true)
		if lobby then
			local spawn = lobby:FindFirstChild("Spawn", true) or lobby:FindFirstChild("Spawns", true) or lobby:FindFirstChildWhichIsA("SpawnLocation", true)
			if spawn then
				safeTeleport(spawn.CFrame * CFrame.new(0, 5, 0))
				return
			end
		end
	end
	local spawnLocation = Workspace:FindFirstChildOfClass("SpawnLocation")
	if spawnLocation then
		safeTeleport(spawnLocation.CFrame * CFrame.new(0, 5, 0))
		return
	end
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation") then
			safeTeleport(obj.CFrame * CFrame.new(0, 5, 0))
			return
		end
	end
end

function SHubFling(TargetPlayer)
	if not TargetPlayer or TargetPlayer == LocalPlayer then return end
	updateCharacter()
	if not (Char and Hum and Root) then return end
	local TCharacter = TargetPlayer.Character
	if not TCharacter then return end
	local THum = TCharacter:FindFirstChildWhichIsA("Humanoid")
	local TRoot = TCharacter:FindFirstChild("HumanoidRootPart") or TCharacter:FindFirstChild("Head")
	if not TRoot or (THum and THum.Health <= 0) then return end

	isSelfFlinging = true

	local oldPos = Root.CFrame * CFrame.new(0, 8, 0)
	local savedParts = {}
	for _, part in ipairs(Char:GetDescendants()) do
		if part:IsA("BasePart") then
			savedParts[part] = {CanCollide = part.CanCollide, Massless = part.Massless}
		end
	end

	for _, part in ipairs(Char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Massless = true
		end
	end
	Root.CanCollide = true
	Root.Massless = false

	Hum.PlatformStand = true
	Hum.AutoRotate = false

	local bav = Instance.new("BodyAngularVelocity")
	bav.Name = "FlingVelocity"
	bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bav.P = math.huge
	bav.AngularVelocity = Vector3.new(0, 99999, 0)
	bav.Parent = Root

	local duration = 1.8
	local start = tick()
	local conn

	conn = RunService.Heartbeat:Connect(function()
		if tick() - start >= duration then return end
		updateCharacter()
		if not (Root and Root.Parent and TRoot and TRoot.Parent) then return end

		Hum.PlatformStand = true
		Hum.AutoRotate = false

		local targetVel = TRoot.AssemblyLinearVelocity
		local predicted = TRoot.Position + (targetVel * 0.07)

		Root.CFrame = CFrame.new(predicted) * CFrame.new(0, 0.1, 0)

		local vel = Root.Velocity
		Root.Velocity = vel * 1e9 + Vector3.new(0, 1e9, 0)

		Root.AssemblyLinearVelocity = Vector3.new(math.random(-60000,60000), math.random(35000,60000), math.random(-60000,60000))
		Root.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
	end)

	task.wait(duration)
	if conn then conn:Disconnect() end
	if bav and bav.Parent then pcall(function() bav:Destroy() end) end

	updateCharacter()
	for i = 1, 12 do
		if Root and Root.Parent then
			Root.AssemblyLinearVelocity = Vector3.zero
			Root.AssemblyAngularVelocity = Vector3.zero
			Root.Velocity = Vector3.zero
		end
		RunService.Heartbeat:Wait()
	end

	if Hum and Hum.Parent then
		Hum.PlatformStand = false
		Hum.AutoRotate = true
		pcall(function() Hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
	end

	for part, props in pairs(savedParts) do
		if part and part.Parent then
			part.CanCollide = props.CanCollide
			part.Massless = props.Massless
		end
	end

	if Root and Root.Parent then
		Root.AssemblyLinearVelocity = Vector3.zero
		Root.AssemblyAngularVelocity = Vector3.zero
		Root.Velocity = Vector3.zero
		safeTeleport(oldPos)
	end

	isSelfFlinging = false
end

function FlingAll()
	task.spawn(function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local hum = p.Character:FindFirstChildWhichIsA("Humanoid")
				if hum and hum.Health > 0 then
					print("[Fling All] →", p.Name)
					task.spawn(SHubFling, p)
					task.wait(0.08)
				end
			end
		end
		print("[Fling All] Terminado")
	end)
end

function toggleProtect(enable)
	isProtectActive = enable
	if protectConnection then
		protectConnection:Disconnect()
		protectConnection = nil
	end
	if not enable then return end
	if not selectedPlayerName then
		isProtectActive = false
		if protectBtn then
			protectBtn.Text = "Protect: OFF"
			protectBtn.TextColor3 = Color3.new(1, 1, 1)
		end
		print("[Protect] Selecciona un jugador en el dropdown")
		return
	end

	protectConnection = RunService.Heartbeat:Connect(function()
		if not isProtectActive or not selectedPlayerName then return end
		if isSelfFlinging then return end

		updateCharacter()
		if not (Char and Root and Hum and Hum.Health > 0) then return end

		local ally = Players:FindFirstChild(selectedPlayerName)
		if not ally then
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Name == selectedPlayerName or p.DisplayName == selectedPlayerName then
					ally = p
					break
				end
			end
		end
		if not ally or ally == LocalPlayer or not ally.Character then return end

		local aChar = ally.Character
		local aHum = aChar:FindFirstChildWhichIsA("Humanoid")
		local aRoot = aChar:FindFirstChild("HumanoidRootPart")
		if not aHum or not aRoot or aHum.Health <= 0 then return end


		for _, part in ipairs(Char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end

		local blockingShot = false


		local sheriff = getSheriffPlayer and getSheriffPlayer()
		if sheriff and sheriff.Character and sheriff ~= ally then
			local sChar = sheriff.Character
			local sRoot = sChar:FindFirstChild("HumanoidRootPart")
			local sHead = sChar:FindFirstChild("Head")
			local sHum = sChar:FindFirstChildWhichIsA("Humanoid")
			if sRoot and sHum and sHum.Health > 0 then
				local origin = (sHead and sHead.Position) or sRoot.Position
				local look = sRoot.CFrame.LookVector
				local hasGun = false
				for _, t in ipairs(sChar:GetChildren()) do
					if t:IsA("Tool") then
						local n = t.Name:lower()
						if n:find("gun") or n:find("pistol") or n:find("revolver") then
							hasGun = true
							local handle = t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart")
							if handle then
								origin = handle.Position
								look = handle.CFrame.LookVector
							end
							break
						end
					end
				end

				if hasGun then
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Exclude
					params.FilterDescendantsInstances = {sChar, Char}
					params.IgnoreWater = true
					local hit = Workspace:Raycast(origin, look * 300, params)


					local aimsAtAlly = false
					local impactPos = nil
					if hit and hit.Instance and hit.Instance:IsDescendantOf(aChar) then
						aimsAtAlly = true
						impactPos = hit.Position
					else

						local toAlly = aRoot.Position - origin
						local proj = look * math.max(0, toAlly:Dot(look))
						local closest = origin + proj
						if (closest - aRoot.Position).Magnitude <= 6 and toAlly:Dot(look) > 0 then
							aimsAtAlly = true
							impactPos = closest
						end
					end

					if aimsAtAlly and impactPos then
						blockingShot = true

						local dir = (impactPos - origin)
						local dist = dir.Magnitude
						if dist > 1 then
							dir = dir.Unit

							local blockPos = impactPos - dir * 2.2
							safeTeleport(CFrame.new(blockPos, blockPos + look))
						end
					end
				end
			end
		end


		if not blockingShot then
			local murderer = getMurdererPlayer and getMurdererPlayer()
			if murderer and murderer.Character and murderer ~= ally then
				local mChar = murderer.Character
				local mRoot = mChar:FindFirstChild("HumanoidRootPart")
				local mHum = mChar:FindFirstChildWhichIsA("Humanoid")
				if mRoot and mHum and mHum.Health > 0 then
					local hasKnife = false
					for _, t in ipairs(mChar:GetChildren()) do
						if t:IsA("Tool") then
							local n = t.Name:lower()
							if n:find("knife") or n:find("cuchillo") or n:find("dagger") or n:find("blade") then
								hasKnife = true
								break
							end
						end
					end
					local dist = (mRoot.Position - aRoot.Position).Magnitude
					if hasKnife and dist <= 12 then
						blockingShot = true

						local mid = mRoot.Position:Lerp(aRoot.Position, 0.45)
						safeTeleport(CFrame.new(mid + Vector3.new(0, 1, 0), mRoot.Position))
					end
				end
			end
		end


		if not blockingShot then
			safeTeleport(aRoot.CFrame * CFrame.new(0, 0, 2.5))
		end
	end)
end

function toggleTouchFling(enable)
	isTouchFlingActive = enable
	updateCharacter()

	if enable then
		isSelfFlinging = true

		if touchFlingConnection then
			pcall(function()
				task.cancel(touchFlingConnection)
			end)
			touchFlingConnection = nil
		end

		touchFlingConnection = task.spawn(function()
			local vel, movel = nil, 0.1

			while isTouchFlingActive do
				updateCharacter()

				if not (Char and Root and Hum and Hum.Health > 0) then
					task.wait()
				else
					for _, part in ipairs(Char:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end

					RunService.Heartbeat:Wait()

					vel = Root.Velocity
					Root.Velocity =
						vel * 9e8 + Vector3.new(0, 9e8, 0)

					RunService.RenderStepped:Wait()

					if Char and Char.Parent and Root and Root.Parent then
						Root.Velocity = vel
					end

					RunService.Stepped:Wait()

					if Char and Char.Parent and Root and Root.Parent then
						Root.Velocity =
							vel + Vector3.new(0, movel, 0)

						movel = movel * -1
					end
				end
			end
		end)

	else
		isSelfFlinging = false

		if touchFlingConnection then
			pcall(function()
				task.cancel(touchFlingConnection)
			end)
			touchFlingConnection = nil
		end

		updateCharacter()

		if Char then
			for _, part in ipairs(Char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end

		if Root then
			Root.Velocity = Vector3.zero
			Root.AssemblyLinearVelocity = Vector3.zero
			Root.AssemblyAngularVelocity = Vector3.zero
		end
	end
end

function createButton(page, text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 190, 0, 34)
	btn.Position = UDim2.new(0, 15, 0, y)
	btn.BackgroundColor3 = Theme.CARD
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Parent = page
	btn:SetAttribute("ThemeRole", "Card")
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Theme.ACCENT
	stroke.Transparency = 0.6
	return btn
end

function toggleSpeed(enable)
	isSpeedActive = enable
	updateCharacter()
	if enable then
		if speedConnection then speedConnection:Disconnect() end
		speedConnection = RunService.Heartbeat:Connect(function()
			updateCharacter()
			if Hum and Hum.Parent then Hum.WalkSpeed = currentSpeed end
		end)
	else
		if speedConnection then speedConnection:Disconnect() speedConnection = nil end
		updateCharacter()
		if Hum and Hum.Parent then Hum.WalkSpeed = normalWalkSpeed end
	end
end

function clearNameESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local head = plr.Character:FindFirstChild("Head")
			if head then
				local bill = head:FindFirstChild("NameESP")
				if bill then bill:Destroy() end
			end
		end
	end
end

function updateNameESP()
	if not isNameESPActive then return end
	local roles = getRoles()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local bill = head:FindFirstChild("NameESP")
			if not bill then
				bill = Instance.new("BillboardGui")
				bill.Name = "NameESP"
				bill.Size = UDim2.new(0, 200, 0, 40)
				bill.StudsOffset = Vector3.new(0, 2.8, 0)
				bill.AlwaysOnTop = true
				bill.MaxDistance = 300
				bill.Parent = head
				local label = Instance.new("TextLabel")
				label.Name = "TextLabel"
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = plr.DisplayName
				label.TextColor3 = Color3.new(1, 1, 1)
				label.Font = Enum.Font.GothamBold
				label.TextSize = 14
				label.TextStrokeTransparency = 0.4
				label.Parent = bill
			end
			local label = bill:FindFirstChild("TextLabel")
			if label then
				local role = roles[plr.Name]
				local color = Color3.fromRGB(220, 220, 220)
				if role and isMurdererRole(role) then color = Color3.fromRGB(255, 60, 60)
				elseif role and isSheriffRole(role) then color = Color3.fromRGB(60, 140, 255) end
				label.TextColor3 = color
				label.Text = plr.DisplayName
			end
		end
	end
end

function toggleNameESP(enable)
	isNameESPActive = enable
	if enable then
		clearNameESP()
		if nameESPConnection then nameESPConnection:Disconnect() end
		nameESPConnection = RunService.Heartbeat:Connect(function()
			pcall(updateNameESP)
		end)
	else
		if nameESPConnection then
			nameESPConnection:Disconnect()
			nameESPConnection = nil
		end
		clearNameESP()
	end
end

function toggleFly(enable)
	isFlyActive = enable
	updateCharacter()
	if enable then
		if not Root then return end
		if flyBodyVelocity then flyBodyVelocity:Destroy() end
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Name = "FlyVelocity"
		flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		flyBodyVelocity.Velocity = Vector3.zero
		flyBodyVelocity.Parent = Root
		if flyConnection then flyConnection:Disconnect() end
		flyConnection = RunService.RenderStepped:Connect(function()
			if not isFlyActive or not Root or not Root.Parent then return end
			local cam = Workspace.CurrentCamera
			local moveDir = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
			if moveDir.Magnitude > 0 then
				flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
			else
				flyBodyVelocity.Velocity = Vector3.zero
			end
		end)
	else
		if flyConnection then flyConnection:Disconnect() flyConnection = nil end
		if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
		updateCharacter()
		if Root then Root.AssemblyLinearVelocity = Vector3.zero end
	end
end

function toggleNoclip(enable)
	isNoclipActive = enable
	updateCharacter()
	if enable then
		if noclipConnection then noclipConnection:Disconnect() end
		noclipConnection = RunService.Stepped:Connect(function()
			if not isNoclipActive then return end
			updateCharacter()
			if Char then
				for _, part in ipairs(Char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end
		updateCharacter()
		if Char then
			for _, part in ipairs(Char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end
end

local SAFE_MOVER_NAMES = {
	FlyVelocity = true,
	FlingVelocity = true,
	LoopFlingBAV = true,
}

local MAX_LINEAR_SOFT = 55
local MAX_LINEAR_HARD = 90
local MAX_ANGULAR = 25

function destroyForeignMovers(part)
	if not part then return end
	for _, obj in ipairs(part:GetChildren()) do
		local classOk = obj:IsA("BodyAngularVelocity")
			or obj:IsA("BodyVelocity")
			or obj:IsA("BodyForce")
			or obj:IsA("BodyThrust")
			or obj:IsA("BodyGyro")
			or obj:IsA("BodyPosition")
			or obj:IsA("Torque")
			or obj:IsA("VectorForce")
			or obj:IsA("AngularVelocity")
			or obj:IsA("LinearVelocity")
			or obj:IsA("AlignPosition")
			or obj:IsA("AlignOrientation")
			or obj:IsA("LineForce")
			or obj:IsA("Torque")
		if classOk and not SAFE_MOVER_NAMES[obj.Name] then
			pcall(function() obj:Destroy() end)
		end
	end
end

function toggleAntiFling(enable)
	isAntiFlingActive = enable

	if antiFlingConnection then
		pcall(function()
			if typeof(antiFlingConnection) == "RBXScriptConnection" then
				antiFlingConnection:Disconnect()
			else
				task.cancel(antiFlingConnection)
			end
		end)
		antiFlingConnection = nil
	end

	if not enable then return end

	antiFlingConnection = RunService.Heartbeat:Connect(function()
		if not isAntiFlingActive then return end


		if isSelfFlinging or isLoopFlingActive or isTouchFlingActive then
			return
		end

		updateCharacter()
		if not (Char and Root and Hum and Hum.Health > 0) then return end


		for _, part in ipairs(Char:GetDescendants()) do
			if part:IsA("BasePart") then
				destroyForeignMovers(part)
			end
		end


		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and hrp:IsA("BasePart") then
					hrp.CanCollide = false
				end

				for _, n in ipairs({"Torso", "UpperTorso", "LowerTorso"}) do
					local p = plr.Character:FindFirstChild(n)
					if p and p:IsA("BasePart") then
						p.CanCollide = false
					end
				end
			end
		end


		local linear = Root.AssemblyLinearVelocity
		local angular = Root.AssemblyAngularVelocity
		local linMag = linear.Magnitude
		local angMag = angular.Magnitude

		if linMag > MAX_LINEAR_HARD or angMag > MAX_ANGULAR * 2 then
			Root.AssemblyLinearVelocity = Vector3.zero
			Root.AssemblyAngularVelocity = Vector3.zero
			pcall(function()
				Root.Velocity = Vector3.zero
				Root.RotVelocity = Vector3.zero
			end)
		elseif linMag > MAX_LINEAR_SOFT then
			Root.AssemblyLinearVelocity = linear.Unit * (MAX_LINEAR_SOFT * 0.35)
			pcall(function()
				Root.Velocity = Root.AssemblyLinearVelocity
			end)
		end

		if angMag > MAX_ANGULAR then
			Root.AssemblyAngularVelocity = Vector3.zero
			pcall(function() Root.RotVelocity = Vector3.zero end)
		end


		if Hum.PlatformStand and not isSelfFlinging and not isLoopFlingActive and not isFlyActive then
			Hum.PlatformStand = false
			Hum.AutoRotate = true
			pcall(function()
				Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end)
		end
	end)
end

function toggleCombatAimbot(enable)
	isCombatAimbotActive = enable
	if enable then
		if combatAimbotConnection then combatAimbotConnection:Disconnect() end
		combatAimbotConnection = RunService.RenderStepped:Connect(function()
			if not isCombatAimbotActive then return end
			updateCharacter()
			local tool = Char and Char:FindFirstChildOfClass("Tool")
			if not tool then return end
			local name = tool.Name:lower()
			local isGun = name:find("gun") or name:find("pistol") or name:find("revolver")
			local isKnife = name:find("knife") or name:find("cuchillo") or name:find("dagger") or name:find("blade")
			if not (isGun or isKnife) then return end
			local target = nil
			if isGun then target = getMurdererPlayer()
			elseif isKnife then
				target = getSheriffPlayer()
				if not target then
					local closest, closestDist = nil, math.huge
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer and playerIsAlive(plr) and plr.Character then
							local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
							if tRoot and Root then
								local dist = (Root.Position - tRoot.Position).Magnitude
								if dist < closestDist then
									closestDist = dist
									closest = plr
								end
							end
						end
					end
					target = closest
				end
			end
			if target and target.Character then
				local head = target.Character:FindFirstChild("Head")
				if head then
					Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, head.Position)
				end
			end
		end)
	else
		if combatAimbotConnection then
			combatAimbotConnection:Disconnect()
			combatAimbotConnection = nil
		end
	end
end

function toggleAutoShot(enable)
	isAutoShotActive = enable
	if enable then
		if autoShotConnection then autoShotConnection:Disconnect() end
		autoShotConnection = RunService.Heartbeat:Connect(function()
			if not isAutoShotActive then return end
			updateCharacter()
			local tool = Char and Char:FindFirstChildOfClass("Tool")
			if not tool then return end
			local name = tool.Name:lower()
			if not (name:find("gun") or name:find("pistol") or name:find("revolver")) then return end
			local murderer = getMurdererPlayer()
			if not murderer or not murderer.Character then return end
			local head = murderer.Character:FindFirstChild("Head")
			if not head then return end
			local cam = Workspace.CurrentCamera
			cam.CFrame = CFrame.new(cam.CFrame.Position, head.Position)
			pcall(function() tool:Activate() end)
		end)
	else
		if autoShotConnection then
			autoShotConnection:Disconnect()
			autoShotConnection = nil
		end
	end
end

function KillAllWithKnife()
	updateCharacter()
	if not (Char and Root and Hum and Hum.Health > 0) then return end

	local function isKnifeTool(t)
		if not t then return false end
		local n = t.Name:lower()
		return n:find("knife") or n:find("cuchillo") or n:find("dagger") or n:find("blade")
	end

	local knife = Char:FindFirstChildOfClass("Tool")
	if not isKnifeTool(knife) then
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		if backpack then
			for _, tool in ipairs(backpack:GetChildren()) do
				if tool:IsA("Tool") and isKnifeTool(tool) then
					knife = tool
					Hum:EquipTool(tool)
					task.wait(0.08)
					break
				end
			end
		end
	end

	if not knife then
		warn("[Kill All] No tienes cuchillo equipado ni en la mochila")
		return
	end

	for pass = 1, 2 do
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and playerIsAlive(plr) then
				local tChar = plr.Character
				local tRoot = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head"))
				local tHum = tChar and tChar:FindFirstChildWhichIsA("Humanoid")
				if tRoot and tHum and tHum.Health > 0 then
					Root.CFrame = tRoot.CFrame * CFrame.new(0, 0.3, 1.2)
					pcall(function() knife:Activate() end)
					task.wait(0.04)
					pcall(function() knife:Activate() end)
					task.wait(0.04)
					pcall(function() knife:Activate() end)
					task.wait(0.03)
				end
			end
		end
		task.wait(0.05)
	end
end

function toggleKillAura(enable)
	isKillAuraActive = enable
	if enable then
		if killAuraConnection then killAuraConnection:Disconnect() end
		killAuraConnection = RunService.Heartbeat:Connect(function()
			if not isKillAuraActive then return end
			updateCharacter()
			if not (Char and Root and Hum and Hum.Health > 0) then return end
			local knife = Char:FindFirstChildOfClass("Tool")
			local isKnife = knife and (knife.Name:lower():find("knife") or knife.Name:lower():find("cuchillo") or knife.Name:lower():find("dagger") or knife.Name:lower():find("blade"))
			if not isKnife then
				local backpack = LocalPlayer:FindFirstChild("Backpack")
				if backpack then
					for _, tool in ipairs(backpack:GetChildren()) do
						if tool:IsA("Tool") then
							local n = tool.Name:lower()
							if n:find("knife") or n:find("cuchillo") or n:find("dagger") or n:find("blade") then
								knife = tool
								pcall(function() Hum:EquipTool(tool) end)
								isKnife = true
								break
							end
						end
					end
				end
			end
			if not isKnife or not knife then return end
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and playerIsAlive(plr) then
					local tChar = plr.Character
					local tRoot = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head"))
					if tRoot and Root then
						local dist = (Root.Position - tRoot.Position).Magnitude
						if dist <= killAuraRange then
							if dist > 4 then Root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.8) end
							pcall(function() knife:Activate() end)
						end
					end
				end
			end
		end)
	else
		if killAuraConnection then
			killAuraConnection:Disconnect()
			killAuraConnection = nil
		end
	end
end

function stopLoopFling()
	isLoopFlingActive = false
	isSelfFlinging = false
	if loopFlingConnection then
		pcall(function()
			if typeof(loopFlingConnection) == "RBXScriptConnection" then
				loopFlingConnection:Disconnect()
			else
				task.cancel(loopFlingConnection)
			end
		end)
		loopFlingConnection = nil
	end
	if loopFlingBAV then
		pcall(function() loopFlingBAV:Destroy() end)
		loopFlingBAV = nil
	end
	updateCharacter()
	if Hum and Hum.Parent then
		Hum.PlatformStand = false
		Hum.AutoRotate = true
	end
	if Char then
		for _, part in ipairs(Char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
				part.Massless = false
			end
		end
	end
	if Root and Root.Parent then
		Root.AssemblyLinearVelocity = Vector3.zero
		Root.AssemblyAngularVelocity = Vector3.zero
		Root.Velocity = Vector3.zero
	end
	if loopFlingBtn then
		loopFlingBtn.Text = "Loop Fling: OFF"
		loopFlingBtn.TextColor3 = Color3.new(1, 1, 1)
	end
end

local function resolveSelectedTarget()
	if selectedPlayerUserId then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.UserId == selectedPlayerUserId then
				selectedPlayerName = p.Name
				return p
			end
		end
	end
	if selectedPlayerName then
		local p = Players:FindFirstChild(selectedPlayerName)
		if p then
			selectedPlayerUserId = p.UserId
			return p
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name == selectedPlayerName or plr.DisplayName == selectedPlayerName then
				selectedPlayerName = plr.Name
				selectedPlayerUserId = plr.UserId
				return plr
			end
		end
	end
	return nil
end

startLoopFling = function()
	local target = resolveSelectedTarget()
	if not target or target == LocalPlayer then

		isLoopFlingActive = true
		if loopFlingBtn then
			loopFlingBtn.Text = "Loop Fling: ON (waiting)"
			loopFlingBtn.TextColor3 = COLOR_ACCENT
		end
		return
	end
	selectedPlayerName = target.Name
	selectedPlayerUserId = target.UserId

	if loopFlingConnection then
		loopFlingConnection:Disconnect()
		loopFlingConnection = nil
	end
	if loopFlingBAV then
		pcall(function() loopFlingBAV:Destroy() end)
		loopFlingBAV = nil
	end

	isLoopFlingActive = true
	isSelfFlinging = true
	updateCharacter()
	if not (Char and Hum and Root) then

		if loopFlingBtn then
			loopFlingBtn.Text = "Loop Fling: ON"
			loopFlingBtn.TextColor3 = COLOR_ACCENT
		end
		return
	end

	for _, part in ipairs(Char:GetDescendants()) do
		if part:IsA("BasePart") then
			if part == Root then
				part.CanCollide = true
				part.Massless = false
			else
				part.CanCollide = false
				part.Massless = true
			end
		end
	end

	Hum.PlatformStand = true
	Hum.AutoRotate = false

	local function ensureBAV()
		if not Root or not Root.Parent then return end
		if loopFlingBAV and loopFlingBAV.Parent == Root then return end
		if loopFlingBAV then pcall(function() loopFlingBAV:Destroy() end) end

		loopFlingBAV = Instance.new("BodyAngularVelocity")
		loopFlingBAV.Name = "LoopFlingBAV"
		loopFlingBAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		loopFlingBAV.P = math.huge
		loopFlingBAV.AngularVelocity = Vector3.new(0, 99999, 0)
		loopFlingBAV.Parent = Root
	end
	ensureBAV()

	local movel = 0.1
	local FLING_TIME = 1.6
	local MAP_WAIT = 0.35


	loopFlingConnection = task.spawn(function()
		while isLoopFlingActive do

			local flingUntil = tick() + FLING_TIME
			while isLoopFlingActive and tick() < flingUntil do
				local target = resolveSelectedTarget()
				if target and target.Character then
					local tRoot = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Head")
					local tHum = target.Character:FindFirstChildWhichIsA("Humanoid")
					if tRoot and (not tHum or tHum.Health > 0) then
						updateCharacter()
						if Root and Root.Parent and Hum and Hum.Parent and Hum.Health > 0 then
							Hum.PlatformStand = true
							Hum.AutoRotate = false
							Root.CanCollide = true
							Root.Massless = false
							if Char then
								for _, part in ipairs(Char:GetDescendants()) do
									if part:IsA("BasePart") and part ~= Root then
										part.CanCollide = false
										part.Massless = true
									end
								end
							end
							ensureBAV()


							local targetVel = tRoot.AssemblyLinearVelocity
							if typeof(targetVel) ~= "Vector3" then
								targetVel = tRoot.Velocity or Vector3.zero
							end


							local speed = targetVel.Magnitude
							local predTime = 0.12
							if speed > 40 then
								predTime = 0.18
							elseif speed > 20 then
								predTime = 0.15
							end

							local yBoost = 0
							if tHum then
								local state = tHum:GetState()
								if state == Enum.HumanoidStateType.Jumping
									or state == Enum.HumanoidStateType.Freefall
									or state == Enum.HumanoidStateType.Flying then
									predTime = predTime + 0.06
									yBoost = math.clamp(targetVel.Y * 0.05, -2, 4)
								end
							end
							if targetVel.Y > 10 then
								yBoost = yBoost + 1.2
							elseif targetVel.Y < -20 then
								yBoost = yBoost - 0.8
							end

							local predictedPos = tRoot.Position + (targetVel * predTime) + Vector3.new(0, yBoost, 0)


							Root.CFrame = CFrame.new(predictedPos + Vector3.new(0, 0.2, 0))

							local vel = Root.Velocity
							Root.Velocity = vel * 1e9 + Vector3.new(0, 1e9, 0)
							Root.AssemblyLinearVelocity = Vector3.new(
								math.random(-60000, 60000),
								math.random(35000, 65000),
								math.random(-60000, 60000)
							)
							Root.AssemblyAngularVelocity = Vector3.new(
								math.random(-20000, 20000),
								99999,
								math.random(-20000, 20000)
							)
							Root.Velocity = Root.Velocity + Vector3.new(0, movel, 0)
							movel = movel * -1
						end
					end
				end
				RunService.Heartbeat:Wait()
			end

			if not isLoopFlingActive then break end


			updateCharacter()

			if loopFlingBAV then
				pcall(function() loopFlingBAV:Destroy() end)
				loopFlingBAV = nil
			end
			if Root and Root.Parent then
				Root.AssemblyLinearVelocity = Vector3.zero
				Root.AssemblyAngularVelocity = Vector3.zero
				Root.Velocity = Vector3.zero
			end
			if Hum and Hum.Parent then
				Hum.PlatformStand = false
				Hum.AutoRotate = true
			end

			pcall(teleportToMap)

			updateCharacter()
			if Root and Root.Parent then
				Root.AssemblyLinearVelocity = Vector3.zero
				Root.AssemblyAngularVelocity = Vector3.zero
				Root.Velocity = Vector3.zero
			end

			task.wait(MAP_WAIT)


			if isLoopFlingActive then
				updateCharacter()
				if Char and Hum and Root then
					Hum.PlatformStand = true
					Hum.AutoRotate = false
					ensureBAV()
				end
			end
		end
	end)

	if loopFlingBtn then
		loopFlingBtn.Text = "Loop Fling: ON"
		loopFlingBtn.TextColor3 = COLOR_ACCENT
	end
end

local grabGunBtn = createButton(mainPage, "Grab Gun", 10)
grabGunBtn.MouseButton1Click:Connect(GrabGun)

local autoGrabBtn = createButton(mainPage, "Auto Grab Gun: OFF", 50)
autoGrabBtn.MouseButton1Click:Connect(function()
	autoGrabGun = not autoGrabGun
	autoGrabBtn.Text = autoGrabGun and "Auto Grab Gun: ON" or "Auto Grab Gun: OFF"
	autoGrabBtn.TextColor3 = autoGrabGun and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

task.spawn(function()
	while screenGui.Parent do
		if autoGrabGun then pcall(GrabGun) end
		task.wait(0.15)
	end
end)

gunAimbotBtn = createButton(mainPage, "Gun Aimbot: OFF", 90)
function toggleGunAimbot(enable)
	isGunAimbotActive = enable
	gunAimbotBtn.Text = enable and "Gun Aimbot: ON" or "Gun Aimbot: OFF"
	gunAimbotBtn.TextColor3 = enable and COLOR_ACCENT or Color3.new(1, 1, 1)
	if enable then
		if aimbotConnection then aimbotConnection:Disconnect() end
		aimbotConnection = RunService.RenderStepped:Connect(function()
			if not isGunAimbotActive then return end
			updateCharacter()
			local tool = Char and Char:FindFirstChildOfClass("Tool")
			if not tool then return end
			local name = tool.Name:lower()
			local isGun = name:find("gun") or name:find("pistol") or name:find("revolver")
			local isKnife = name:find("knife") or name:find("cuchillo") or name:find("dagger") or name:find("blade")
			if not (isGun or isKnife) then return end
			local target = nil
			if isGun then
				target = getMurdererPlayer()
			elseif isKnife then
				target = getSheriffPlayer()
				if not target then
					local closest, closestDist = nil, math.huge
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer and playerIsAlive(plr) and plr.Character then
							local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
							if tRoot and Root then
								local dist = (Root.Position - tRoot.Position).Magnitude
								if dist < closestDist then
									closestDist = dist
									closest = plr
								end
							end
						end
					end
					target = closest
				end
			end
			if target and target.Character then
				local targetHead = target.Character:FindFirstChild("Head")
				if targetHead then
					Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetHead.Position)
				end
			end
		end)
	else
		if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
	end
end
gunAimbotBtn.MouseButton1Click:Connect(function() toggleGunAimbot(not isGunAimbotActive) end)

local tpMapBtn = createButton(mainPage, "Teleport to Map", 130)
tpMapBtn.MouseButton1Click:Connect(teleportToMap)

local tpLobbyBtn = createButton(mainPage, "Teleport to Lobby", 170)
tpLobbyBtn.MouseButton1Click:Connect(teleportToLobby)

local autoFarmBtn = createButton(mainPage, "Auto Farm Coins: OFF", 210)
function getAllCoins()
	local coins = {}
	local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
	if coinContainer then
		for _, v in ipairs(coinContainer:GetDescendants()) do
			if v:IsA("BasePart") and v.Transparency < 1 then table.insert(coins, v) end
		end
	end
	return coins
end
function tryCollectCoin(coin)
	updateCharacter()
	if not (Char and Root) then return end
	if firetouchinterest then
		pcall(function()
			firetouchinterest(Root, coin, 0)
			task.wait(0.03)
			firetouchinterest(Root, coin, 1)
		end)
	end
	local dist = (Root.Position - coin.Position).Magnitude
	if dist < 90 then Root.CFrame = coin.CFrame * CFrame.new(0, 2, 0) end
end
function farmCoinsOnce()
	updateCharacter()
	if not (Char and Root and Hum and Hum.Health > 0) then return end
	local coins = getAllCoins()
	for _, coin in ipairs(coins) do
		if not isAutoFarmCoins then break end
		if coin and coin.Parent then
			tryCollectCoin(coin)
			task.wait(0.12)
		end
	end
end
autoFarmBtn.MouseButton1Click:Connect(function()
	isAutoFarmCoins = not isAutoFarmCoins
	autoFarmBtn.Text = isAutoFarmCoins and "Auto Farm Coins: ON" or "Auto Farm Coins: OFF"
	autoFarmBtn.TextColor3 = isAutoFarmCoins and COLOR_ACCENT or Color3.new(1, 1, 1)
	if isAutoFarmCoins then
		task.spawn(function()
			while isAutoFarmCoins and screenGui.Parent do
				pcall(farmCoinsOnce)
				task.wait(0.4)
			end
		end)
	end
end)

local statusCard = Instance.new("Frame")
statusCard.Size = UDim2.new(0, 220, 0, 310)
statusCard.Position = UDim2.new(0, 220, 0, 10)
statusCard.BackgroundColor3 = COLOR_CARD
statusCard.BorderSizePixel = 0
statusCard.Parent = mainPage
Instance.new("UICorner", statusCard).CornerRadius = UDim.new(0, 6)
local statusStroke = Instance.new("UIStroke", statusCard)
statusStroke.Color = COLOR_ACCENT
statusStroke.Transparency = 0.6

local statusTitle = Instance.new("TextLabel")
statusTitle.Size = UDim2.new(1, -16, 0, 25)
statusTitle.Position = UDim2.new(0, 8, 0, 4)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "Status"
statusTitle.TextColor3 = COLOR_ACCENT
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 14
statusTitle.Parent = statusCard

local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(0, 42, 0, 42)
profileImage.Position = UDim2.new(0, 8, 0, 30)
profileImage.BackgroundColor3 = COLOR_SIDEBAR
profileImage.BorderSizePixel = 0
profileImage.Parent = statusCard
Instance.new("UICorner", profileImage).CornerRadius = UDim.new(0, 21)

local profileNameLabel = Instance.new("TextLabel")
profileNameLabel.Size = UDim2.new(1, -60, 0, 20)
profileNameLabel.Position = UDim2.new(0, 56, 0, 32)
profileNameLabel.BackgroundTransparency = 1
profileNameLabel.Text = LocalPlayer.DisplayName
profileNameLabel.TextColor3 = Color3.new(1, 1, 1)
profileNameLabel.Font = Enum.Font.GothamBold
profileNameLabel.TextSize = 12
profileNameLabel.TextXAlignment = Enum.TextXAlignment.Left
profileNameLabel.Parent = statusCard

local profileUserLabel = Instance.new("TextLabel")
profileUserLabel.Size = UDim2.new(1, -60, 0, 18)
profileUserLabel.Position = UDim2.new(0, 56, 0, 50)
profileUserLabel.BackgroundTransparency = 1
profileUserLabel.Text = "@" .. LocalPlayer.Name
profileUserLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
profileUserLabel.Font = Enum.Font.Gotham
profileUserLabel.TextSize = 10
profileUserLabel.TextXAlignment = Enum.TextXAlignment.Left
profileUserLabel.Parent = statusCard

function createStatusLabel(text, y)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 22)
	label.Position = UDim2.new(0, 8, 0, y)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = statusCard
	return label
end

local levelLabel    = createStatusLabel("Level: -", 80)
local murdererLabel = createStatusLabel("Murderer: -", 105)
local sheriffLabel  = createStatusLabel("Sheriff: -", 130)
local heroLabel     = createStatusLabel("Hero: -", 155)
local coinsLabel    = createStatusLabel("Coins: 0", 185)
local sessionLabel  = createStatusLabel("Session: 0s", 210)

local lastProfileUser = nil

function updateStatus()
	local roles = getRoles()
	local murdererName, sheriffName, heroName = nil, nil, nil
	for plrName, role in pairs(roles) do
		if isMurdererRole(role) then murdererName = tostring(plrName)
		elseif isSheriffRole(role) then sheriffName = tostring(plrName)
		elseif normalizeRole(role) == "hero" or normalizeRole(role) == "heroe" or normalizeRole(role) == "héroe" then
			heroName = tostring(plrName)
		end
	end
	if not murdererName then
		local m = getMurdererPlayer()
		if m then murdererName = m.Name end
	end
	if not sheriffName then
		local s = getSheriffPlayer()
		if s then sheriffName = s.Name end
	end
	murdererLabel.Text = "Murderer: " .. (murdererName or "-")
	sheriffLabel.Text  = "Sheriff:  " .. (sheriffName or "-")
	heroLabel.Text     = "Hero: "     .. (heroName or "-")

	local activePlayer = nil
	if murdererName then activePlayer = Players:FindFirstChild(murdererName) end
	if not activePlayer and selectedPlayerName then activePlayer = Players:FindFirstChild(selectedPlayerName) end
	if not activePlayer then activePlayer = LocalPlayer end

	if activePlayer then
		if lastProfileUser ~= activePlayer.UserId then
			lastProfileUser = activePlayer.UserId
			profileNameLabel.Text = activePlayer.DisplayName
			profileUserLabel.Text = "@" .. activePlayer.Name
			profileImage.Image = ""
			task.spawn(function()
				local success, content = pcall(function()
					return Players:GetUserThumbnailAsync(activePlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				end)
				if success and content and lastProfileUser == activePlayer.UserId then
					profileImage.Image = content
				end
			end)
		end
		local level = activePlayer:GetAttribute("Level")
		local prestige = activePlayer:GetAttribute("Prestige")
		if level then
			if prestige and prestige > 0 then
				levelLabel.Text = "Level: " .. tostring(level) .. " (P" .. tostring(prestige) .. ")"
			else
				levelLabel.Text = "Level: " .. tostring(level)
			end
		else
			levelLabel.Text = "Level: -"
		end
		local coins = activePlayer:GetAttribute("Coins") or activePlayer:GetAttribute("Coin")
		coinsLabel.Text = "Coins: " .. (coins and tostring(coins) or "0")
	else
		profileNameLabel.Text = "-"
		profileUserLabel.Text = ""
		profileImage.Image = ""
		levelLabel.Text = "Level: -"
		coinsLabel.Text = "Coins: 0"
	end
	sessionLabel.Text = "Session: " .. math.floor(tick() - sessionStart) .. "s"
end

task.spawn(function()
	while screenGui.Parent do
		pcall(updateStatus)
		task.wait(0.6)
	end
end)

infJumpBtn = createButton(playerPage, "Infinite Jump: OFF", 10)
local lastJump = 0
function toggleInfiniteJump(enable)
	isInfiniteJumpActive = enable
	infJumpBtn.Text = enable and "Infinite Jump: ON" or "Infinite Jump: OFF"
	infJumpBtn.TextColor3 = enable and COLOR_ACCENT or Color3.new(1, 1, 1)
	if enable then
		if infJumpConnection then infJumpConnection:Disconnect() end
		infJumpConnection = UserInputService.JumpRequest:Connect(function()
			if not isInfiniteJumpActive then return end
			if tick() - lastJump < 0.05 then return end
			lastJump = tick()
			updateCharacter()
			if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end)
	else
		if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
	end
end
infJumpBtn.MouseButton1Click:Connect(function() toggleInfiniteJump(not isInfiniteJumpActive) end)

speedBtn = createButton(playerPage, "Speed: OFF", 50)
speedBtn.MouseButton1Click:Connect(function()
	local newState = not isSpeedActive
	toggleSpeed(newState)
	speedBtn.Text = newState and "Speed: ON" or "Speed: OFF"
	speedBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 70, 0, 28)
speedBox.Position = UDim2.new(0, 215, 0, 53)
speedBox.BackgroundColor3 = COLOR_CARD
speedBox.Text = tostring(currentSpeed)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 14
speedBox.PlaceholderText = "Speed"
speedBox.Parent = playerPage
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)
local speedStroke = Instance.new("UIStroke", speedBox)
speedStroke.Color = COLOR_ACCENT
speedStroke.Transparency = 0.5

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num and num > 0 and num <= 1000 then
		currentSpeed = num
		speedBox.Text = tostring(currentSpeed)
		if isSpeedActive then
			updateCharacter()
			if Hum then Hum.WalkSpeed = currentSpeed end
		end
	else
		speedBox.Text = tostring(currentSpeed)
	end
end)

nameESPBtn = createButton(playerPage, "Name ESP: OFF", 95)
nameESPBtn.MouseButton1Click:Connect(function()
	local newState = not isNameESPActive
	toggleNameESP(newState)
	nameESPBtn.Text = newState and "Name ESP: ON" or "Name ESP: OFF"
	nameESPBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

flyBtn = createButton(playerPage, "Fly: OFF", 140)
flyBtn.MouseButton1Click:Connect(function()
	local newState = not isFlyActive
	toggleFly(newState)
	flyBtn.Text = newState and "Fly: ON" or "Fly: OFF"
	flyBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

noclipBtn = createButton(playerPage, "Noclip: OFF", 185)
noclipBtn.MouseButton1Click:Connect(function()
	local newState = not isNoclipActive
	toggleNoclip(newState)
	noclipBtn.Text = newState and "Noclip: ON" or "Noclip: OFF"
	noclipBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

antiFlingBtn = createButton(playerPage, "Anti Fling: OFF", 230)
antiFlingBtn.MouseButton1Click:Connect(function()
	local newState = not isAntiFlingActive
	toggleAntiFling(newState)
	antiFlingBtn.Text = newState and "Anti Fling: ON" or "Anti Fling: OFF"
	antiFlingBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

combatAimbotBtn = createButton(combatPage, "Aimbot: OFF", 10)
combatAimbotBtn.MouseButton1Click:Connect(function()
	local newState = not isCombatAimbotActive
	toggleCombatAimbot(newState)
	combatAimbotBtn.Text = newState and "Aimbot: ON" or "Aimbot: OFF"
	combatAimbotBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

autoShotBtn = createButton(combatPage, "Auto Shot Murderer: OFF", 50)
autoShotBtn.MouseButton1Click:Connect(function()
	local newState = not isAutoShotActive
	toggleAutoShot(newState)
	autoShotBtn.Text = newState and "Auto Shot Murderer: ON" or "Auto Shot Murderer: OFF"
	autoShotBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

local killAllBtn = createButton(combatPage, "Kill All", 90)
killAllBtn.MouseButton1Click:Connect(function()
	task.spawn(KillAllWithKnife)
end)

killAuraBtn = createButton(combatPage, "Kill Aura: OFF", 130)
killAuraBtn.MouseButton1Click:Connect(function()
	local newState = not isKillAuraActive
	toggleKillAura(newState)
	killAuraBtn.Text = newState and "Kill Aura: ON" or "Kill Aura: OFF"
	killAuraBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

local killAuraRangeBox = Instance.new("TextBox")
killAuraRangeBox.Size = UDim2.new(0, 70, 0, 28)
killAuraRangeBox.Position = UDim2.new(0, 215, 0, 133)
killAuraRangeBox.BackgroundColor3 = COLOR_CARD
killAuraRangeBox.Text = tostring(killAuraRange)
killAuraRangeBox.TextColor3 = Color3.new(1, 1, 1)
killAuraRangeBox.Font = Enum.Font.GothamBold
killAuraRangeBox.TextSize = 14
killAuraRangeBox.PlaceholderText = "Range"
killAuraRangeBox.Parent = combatPage
Instance.new("UICorner", killAuraRangeBox).CornerRadius = UDim.new(0, 6)
local killAuraRangeStroke = Instance.new("UIStroke", killAuraRangeBox)
killAuraRangeStroke.Color = COLOR_ACCENT
killAuraRangeStroke.Transparency = 0.5

local killAuraRangeLabel = Instance.new("TextLabel")
killAuraRangeLabel.Size = UDim2.new(0, 80, 0, 20)
killAuraRangeLabel.Position = UDim2.new(0, 215, 0, 115)
killAuraRangeLabel.BackgroundTransparency = 1
killAuraRangeLabel.Text = "Range:"
killAuraRangeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
killAuraRangeLabel.Font = Enum.Font.Gotham
killAuraRangeLabel.TextSize = 12
killAuraRangeLabel.TextXAlignment = Enum.TextXAlignment.Left
killAuraRangeLabel.Parent = combatPage

killAuraRangeBox.FocusLost:Connect(function()
	local num = tonumber(killAuraRangeBox.Text)
	if num and num >= 5 and num <= 100 then
		killAuraRange = num
		killAuraRangeBox.Text = tostring(killAuraRange)
	else
		killAuraRangeBox.Text = tostring(killAuraRange)
	end
end)

local combatSelectedPlayer = nil
local combatDropdownOpen = false
local combatDropdownAnimating = false

local combatTargetDropdown = Instance.new("TextButton")
combatTargetDropdown.Size = UDim2.new(0, 200, 0, 36)
combatTargetDropdown.Position = UDim2.new(0, 15, 0, 180)
combatTargetDropdown.BackgroundColor3 = COLOR_CARD
combatTargetDropdown.BorderSizePixel = 0
combatTargetDropdown.Text = ""
combatTargetDropdown.ZIndex = 20
combatTargetDropdown.Parent = combatPage
Instance.new("UICorner", combatTargetDropdown).CornerRadius = UDim.new(0, 6)

local combatSelectedAvatar = Instance.new("ImageLabel")
combatSelectedAvatar.Size = UDim2.new(0, 26, 0, 26)
combatSelectedAvatar.Position = UDim2.new(0, 5, 0.5, -13)
combatSelectedAvatar.BackgroundColor3 = COLOR_SIDEBAR
combatSelectedAvatar.BorderSizePixel = 0
combatSelectedAvatar.Visible = false
combatSelectedAvatar.ZIndex = 21
combatSelectedAvatar.Parent = combatTargetDropdown
Instance.new("UICorner", combatSelectedAvatar).CornerRadius = UDim.new(1, 0)

local combatSelectedText = Instance.new("TextLabel")
combatSelectedText.Size = UDim2.new(1, -40, 1, 0)
combatSelectedText.Position = UDim2.new(0, 36, 0, 0)
combatSelectedText.BackgroundTransparency = 1
combatSelectedText.Text = "  Target Player        ▼"
combatSelectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
combatSelectedText.Font = Enum.Font.GothamMedium
combatSelectedText.TextSize = 13
combatSelectedText.TextXAlignment = Enum.TextXAlignment.Left
combatSelectedText.ZIndex = 21
combatSelectedText.Parent = combatTargetDropdown

local combatPlayerListFrame = Instance.new("Frame")
combatPlayerListFrame.Size = UDim2.new(0, 200, 0, 0)
combatPlayerListFrame.Position = UDim2.new(0, 15, 0, 220)
combatPlayerListFrame.BackgroundColor3 = COLOR_CARD
combatPlayerListFrame.BackgroundTransparency = 1
combatPlayerListFrame.BorderSizePixel = 0
combatPlayerListFrame.Visible = false
combatPlayerListFrame.ClipsDescendants = true
combatPlayerListFrame.ZIndex = 15
combatPlayerListFrame.Parent = combatPage
Instance.new("UICorner", combatPlayerListFrame).CornerRadius = UDim.new(0, 6)

local combatScrollList = Instance.new("ScrollingFrame")
combatScrollList.Size = UDim2.new(1, -8, 1, -8)
combatScrollList.Position = UDim2.new(0, 4, 0, 4)
combatScrollList.BackgroundTransparency = 1
combatScrollList.BorderSizePixel = 0
combatScrollList.ScrollBarThickness = 4
combatScrollList.ScrollBarImageColor3 = COLOR_ACCENT
combatScrollList.ZIndex = 16
combatScrollList.Parent = combatPlayerListFrame

local combatListLayout = Instance.new("UIListLayout")
combatListLayout.SortOrder = Enum.SortOrder.LayoutOrder
combatListLayout.Padding = UDim.new(0, 2)
combatListLayout.Parent = combatScrollList

function updateCombatDropdownText()
	if combatSelectedPlayer then
		local plr = Players:FindFirstChild(combatSelectedPlayer)
		combatSelectedText.Text = "  " .. combatSelectedPlayer .. "        ▼"
		combatSelectedText.TextColor3 = COLOR_ACCENT
		combatSelectedAvatar.Visible = true
		if plr then
			task.spawn(function()
				local success, content = pcall(function()
					return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				end)
				if success and content and combatSelectedAvatar then
					combatSelectedAvatar.Image = content
				end
			end)
		end
	else
		combatSelectedText.Text = "  Target Player        ▼"
		combatSelectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
		combatSelectedAvatar.Visible = false
		combatSelectedAvatar.Image = ""
	end
end

function updateCombatPlayerList()
	for _, child in ipairs(combatScrollList:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("Frame") then
			child:Destroy()
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -4, 0, 36)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.ZIndex = 17
			btn.Parent = combatScrollList

			local avatar = Instance.new("ImageLabel")
			avatar.Size = UDim2.new(0, 28, 0, 28)
			avatar.Position = UDim2.new(0, 4, 0.5, -14)
			avatar.BackgroundColor3 = COLOR_SIDEBAR
			avatar.BorderSizePixel = 0
			avatar.ZIndex = 18
			avatar.Parent = btn
			Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

			task.spawn(function()
				local success, content = pcall(function()
					return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				end)
				if success and content and avatar and avatar.Parent then
					avatar.Image = content
				end
			end)

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, -40, 1, 0)
			nameLabel.Position = UDim2.new(0, 38, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = p.Name
			nameLabel.TextColor3 = (combatSelectedPlayer == p.Name) and COLOR_ACCENT or Color3.fromRGB(180, 180, 180)
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 13
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.ZIndex = 18
			nameLabel.Parent = btn

			btn.MouseButton1Click:Connect(function()
				combatSelectedPlayer = p.Name
				updateCombatDropdownText()
				combatDropdownOpen = false
				local closeTween = TweenService:Create(combatPlayerListFrame, TweenInfo.new(0.2), {
					Size = UDim2.new(0, 200, 0, 0),
					BackgroundTransparency = 1
				})
				closeTween:Play()
				closeTween.Completed:Connect(function()
					if not combatDropdownOpen then combatPlayerListFrame.Visible = false end
					combatDropdownAnimating = false
				end)
				updateCombatPlayerList()
			end)
		end
	end
	combatScrollList.CanvasSize = UDim2.new(0, 0, 0, combatListLayout.AbsoluteContentSize.Y + 4)
end

function toggleCombatDropdown()
	if combatDropdownAnimating then return end
	combatDropdownAnimating = true
	combatDropdownOpen = not combatDropdownOpen
	if combatDropdownOpen then
		updateCombatPlayerList()
		combatPlayerListFrame.Visible = true
		combatPlayerListFrame.Size = UDim2.new(0, 200, 0, 0)
		combatPlayerListFrame.BackgroundTransparency = 1
		local openTween = TweenService:Create(combatPlayerListFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 200, 0, 170),
			BackgroundTransparency = 0
		})
		openTween:Play()
		combatSelectedText.Text = (combatSelectedPlayer and "  " .. combatSelectedPlayer or "  Target Player") .. "        ▲"
		openTween.Completed:Connect(function() combatDropdownAnimating = false end)
	else
		combatSelectedText.Text = (combatSelectedPlayer and "  " .. combatSelectedPlayer or "  Target Player") .. "        ▼"
		local closeTween = TweenService:Create(combatPlayerListFrame, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 200, 0, 0),
			BackgroundTransparency = 1
		})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			if not combatDropdownOpen then combatPlayerListFrame.Visible = false end
			combatDropdownAnimating = false
		end)
	end
end
combatTargetDropdown.MouseButton1Click:Connect(toggleCombatDropdown)
Players.PlayerAdded:Connect(updateCombatPlayerList)
Players.PlayerRemoving:Connect(function(p)
	if combatSelectedPlayer == p.Name then
		combatSelectedPlayer = nil
		updateCombatDropdownText()
	end
	updateCombatPlayerList()
end)
updateCombatPlayerList()
updateCombatDropdownText()

function KillTargetPlayer()
	if not combatSelectedPlayer then
		print("[Kill Target] No hay jugador seleccionado")
		return
	end
	local target = Players:FindFirstChild(combatSelectedPlayer)
	if not target or not playerIsAlive(target) then
		print("[Kill Target] Jugador no encontrado o muerto")
		return
	end

	updateCharacter()
	if not (Char and Root and Hum and Hum.Health > 0) then return end

	local knife = Char:FindFirstChildOfClass("Tool")
	local isKnife = knife and (
		knife.Name:lower():find("knife") or
		knife.Name:lower():find("cuchillo") or
		knife.Name:lower():find("dagger") or
		knife.Name:lower():find("blade")
	)

	if not isKnife then
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		if backpack then
			for _, tool in ipairs(backpack:GetChildren()) do
				if tool:IsA("Tool") then
					local n = tool.Name:lower()
					if n:find("knife") or n:find("cuchillo") or n:find("dagger") or n:find("blade") then
						knife = tool
						Hum:EquipTool(tool)
						task.wait(0.2)
						break
					end
				end
			end
		end
	end

	if not knife then
		warn("[Kill Target] No tienes cuchillo")
		return
	end

	local tChar = target.Character
	local tRoot = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head"))
	if not tRoot then return end

	for i = 1, 5 do
		if not playerIsAlive(target) then break end
		safeTeleport(tRoot.CFrame * CFrame.new(0, 0.5, 1.4))
		pcall(function() knife:Activate() end)
		task.wait(0.12)
	end
end

local killTargetBtn = createButton(combatPage, "Kill Target", 225)
killTargetBtn.MouseButton1Click:Connect(function()
	task.spawn(KillTargetPlayer)
end)

local dropdownOpen = false
local dropdownAnimating = false

local targetDropdown = Instance.new("TextButton")
targetDropdown.Size = UDim2.new(0, 200, 0, 36)
targetDropdown.Position = UDim2.new(0, 220, 0, 10)
targetDropdown.BackgroundColor3 = COLOR_CARD
targetDropdown.BorderSizePixel = 0
targetDropdown.Text = ""
targetDropdown.ZIndex = 20
targetDropdown.Parent = trollPage
Instance.new("UICorner", targetDropdown).CornerRadius = UDim.new(0, 6)

local selectedAvatar = Instance.new("ImageLabel")
selectedAvatar.Name = "SelectedAvatar"
selectedAvatar.Size = UDim2.new(0, 26, 0, 26)
selectedAvatar.Position = UDim2.new(0, 5, 0.5, -13)
selectedAvatar.BackgroundColor3 = COLOR_SIDEBAR
selectedAvatar.BorderSizePixel = 0
selectedAvatar.Visible = false
selectedAvatar.ZIndex = 21
selectedAvatar.Parent = targetDropdown
Instance.new("UICorner", selectedAvatar).CornerRadius = UDim.new(1, 0)

local selectedText = Instance.new("TextLabel")
selectedText.Name = "SelectedText"
selectedText.Size = UDim2.new(1, -40, 1, 0)
selectedText.Position = UDim2.new(0, 36, 0, 0)
selectedText.BackgroundTransparency = 1
selectedText.Text = "  Target Player        ▼"
selectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
selectedText.Font = Enum.Font.GothamMedium
selectedText.TextSize = 13
selectedText.TextXAlignment = Enum.TextXAlignment.Left
selectedText.ZIndex = 21
selectedText.Parent = targetDropdown

local copyNameBtn = Instance.new("TextButton")
copyNameBtn.Size = UDim2.new(0, 200, 0, 32)
copyNameBtn.Position = UDim2.new(0, 220, 0, 52)
copyNameBtn.BackgroundColor3 = COLOR_CARD
copyNameBtn.Text = "📋 Copy Name"
copyNameBtn.TextColor3 = Color3.new(1, 1, 1)
copyNameBtn.Font = Enum.Font.GothamBold
copyNameBtn.TextSize = 12
copyNameBtn.ZIndex = 20
copyNameBtn.Parent = trollPage
Instance.new("UICorner", copyNameBtn).CornerRadius = UDim.new(0, 6)
local copyNameStroke = Instance.new("UIStroke", copyNameBtn)
copyNameStroke.Color = COLOR_ACCENT
copyNameStroke.Transparency = 0.5
copyNameBtn.MouseButton1Click:Connect(function()
	if selectedPlayerName and selectedPlayerName ~= "" then
		pcall(function()
			if setclipboard then
				setclipboard(selectedPlayerName)
			elseif toclipboard then
				toclipboard(selectedPlayerName)
			end
		end)
		copyNameBtn.Text = "✓ Copied!"
		copyNameBtn.TextColor3 = COLOR_ACCENT
		task.delay(1.2, function()
			if copyNameBtn then
				copyNameBtn.Text = "📋 Copy Name"
				copyNameBtn.TextColor3 = Color3.new(1, 1, 1)
			end
		end)
	else
		copyNameBtn.Text = "No target"
		task.delay(1, function()
			if copyNameBtn then copyNameBtn.Text = "📋 Copy Name" end
		end)
	end
end)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0, 200, 0, 0)
playerListFrame.Position = UDim2.new(0, 220, 0, 90)
playerListFrame.BackgroundColor3 = COLOR_CARD
playerListFrame.BackgroundTransparency = 1
playerListFrame.BorderSizePixel = 0
playerListFrame.Visible = false
playerListFrame.ClipsDescendants = true
playerListFrame.ZIndex = 15
playerListFrame.Parent = trollPage
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 6)

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, -8, 1, -8)
scrollList.Position = UDim2.new(0, 4, 0, 4)
scrollList.BackgroundTransparency = 1
scrollList.BorderSizePixel = 0
scrollList.ScrollBarThickness = 4
scrollList.ScrollBarImageColor3 = COLOR_ACCENT
scrollList.ZIndex = 16
scrollList.Parent = playerListFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = scrollList

function updateDropdownText()
	if selectedPlayerName then
		local plr = Players:FindFirstChild(selectedPlayerName)
		selectedText.Text = "  " .. selectedPlayerName .. "        ▼"
		selectedText.TextColor3 = COLOR_ACCENT
		selectedAvatar.Visible = true
		if plr then
			task.spawn(function()
				local success, content = pcall(function()
					return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				end)
				if success and content and selectedAvatar then
					selectedAvatar.Image = content
				end
			end)
		end
	else
		selectedText.Text = "  Target Player        ▼"
		selectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
		selectedAvatar.Visible = false
		selectedAvatar.Image = ""
	end
end

function updatePlayerList()
	for _, child in ipairs(scrollList:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("Frame") then
			child:Destroy()
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -4, 0, 36)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.ZIndex = 17
			btn.Parent = scrollList

			local avatar = Instance.new("ImageLabel")
			avatar.Size = UDim2.new(0, 28, 0, 28)
			avatar.Position = UDim2.new(0, 4, 0.5, -14)
			avatar.BackgroundColor3 = COLOR_SIDEBAR
			avatar.BorderSizePixel = 0
			avatar.ZIndex = 18
			avatar.Parent = btn
			Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

			task.spawn(function()
				local success, content = pcall(function()
					return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				end)
				if success and content and avatar and avatar.Parent then
					avatar.Image = content
				end
			end)

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, -40, 1, 0)
			nameLabel.Position = UDim2.new(0, 38, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = p.Name
			nameLabel.TextColor3 = (selectedPlayerName == p.Name) and COLOR_ACCENT or Color3.fromRGB(180, 180, 180)
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 13
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.ZIndex = 18
			nameLabel.Parent = btn

			btn.MouseButton1Click:Connect(function()
				selectedPlayerName = p.Name
				selectedPlayerUserId = p.UserId
				updateDropdownText()
				pcall(updateStatus)
				dropdownOpen = false
				local closeTween = TweenService:Create(playerListFrame, TweenInfo.new(0.2), {
					Size = UDim2.new(0, 200, 0, 0),
					BackgroundTransparency = 1
				})
				closeTween:Play()
				closeTween.Completed:Connect(function()
					if not dropdownOpen then playerListFrame.Visible = false end
					dropdownAnimating = false
				end)
				updatePlayerList()
			end)
		end
	end
	scrollList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 4)
end

function toggleDropdown()
	if dropdownAnimating then return end
	dropdownAnimating = true
	dropdownOpen = not dropdownOpen
	if dropdownOpen then
		updatePlayerList()
		playerListFrame.Visible = true
		playerListFrame.Size = UDim2.new(0, 200, 0, 0)
		playerListFrame.BackgroundTransparency = 1
		local openTween = TweenService:Create(playerListFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 200, 0, 170),
			BackgroundTransparency = 0
		})
		openTween:Play()
		selectedText.Text = (selectedPlayerName and "  " .. selectedPlayerName or "  Target Player") .. "        ▲"
		openTween.Completed:Connect(function() dropdownAnimating = false end)
	else
		selectedText.Text = (selectedPlayerName and "  " .. selectedPlayerName or "  Target Player") .. "        ▼"
		local closeTween = TweenService:Create(playerListFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 200, 0, 0), BackgroundTransparency = 1})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			if not dropdownOpen then playerListFrame.Visible = false end
			dropdownAnimating = false
		end)
	end
end
targetDropdown.MouseButton1Click:Connect(toggleDropdown)

Players.PlayerAdded:Connect(function(p)

	if isLoopFlingActive and selectedPlayerUserId and p.UserId == selectedPlayerUserId then
		selectedPlayerName = p.Name
		print("[Loop Fling] Target volvió a entrar:", p.Name)
		pcall(updateDropdownText)
		task.delay(0.8, function()
			if isLoopFlingActive and startLoopFling then
				startLoopFling()
			end
		end)
	end
	if isLoopFlingActive and selectedPlayerName and (p.Name == selectedPlayerName or p.DisplayName == selectedPlayerName) then
		selectedPlayerUserId = p.UserId
		selectedPlayerName = p.Name
		print("[Loop Fling] Target volvió (por nombre):", p.Name)
		pcall(updateDropdownText)
		task.delay(0.8, function()
			if isLoopFlingActive and startLoopFling then
				startLoopFling()
			end
		end)
	end
end)

Players.PlayerAdded:Connect(updatePlayerList)

local flingTargetBtn = createButton(trollPage, "Fling Target", 10)
flingTargetBtn.MouseButton1Click:Connect(function()
	if not selectedPlayerName then
		print("No hay jugador seleccionado")
		return
	end
	local target = Players:FindFirstChild(selectedPlayerName)
	if not target then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Name == selectedPlayerName or p.DisplayName == selectedPlayerName then
				target = p
				break
			end
		end
	end
	if target and target ~= LocalPlayer then
		print("Flingueando a:", target.Name)
		task.spawn(SHubFling, target)
	else
		print("No se encontró el jugador:", selectedPlayerName)
	end
end)

loopFlingBtn = createButton(trollPage, "Loop Fling: OFF", 50)
loopFlingBtn.MouseButton1Click:Connect(function()
	if isLoopFlingActive then
		stopLoopFling()
	else
		if not selectedPlayerName then return end
		startLoopFling()
	end
end)

local flingMurdererBtn = createButton(trollPage, "Fling Murderer", 90)
flingMurdererBtn.MouseButton1Click:Connect(function()
	local target = getMurdererPlayer()
	if target and target ~= LocalPlayer then
		print("[Fling] Murderer encontrado:", target.Name)
		task.spawn(SHubFling, target)
	else
		print("[Fling] No se encontró al Murderer")
		flingMurdererBtn.Text = "No encontrado"
		task.delay(1.2, function()
			if flingMurdererBtn then flingMurdererBtn.Text = "Fling Murderer" end
		end)
	end
end)

local flingSheriffBtn = createButton(trollPage, "Fling Sheriff / Hero", 130)
flingSheriffBtn.MouseButton1Click:Connect(function()
	local target = getSheriffPlayer()
	if target and target ~= LocalPlayer then
		print("[Fling] Sheriff encontrado:", target.Name)
		task.spawn(SHubFling, target)
	else
		print("[Fling] No se encontró al Sheriff")
		flingSheriffBtn.Text = "No encontrado"
		task.delay(1.2, function()
			if flingSheriffBtn then flingSheriffBtn.Text = "Fling Sheriff / Hero" end
		end)
	end
end)

local flingAllBtn = createButton(trollPage, "Fling All", 170)
flingAllBtn.MouseButton1Click:Connect(function()
	flingAllBtn.Text = "Flinging..."
	flingAllBtn.TextColor3 = COLOR_ACCENT
	FlingAll()
	task.delay(2, function()
		if flingAllBtn then
			flingAllBtn.Text = "Fling All"
			flingAllBtn.TextColor3 = Color3.new(1, 1, 1)
		end
	end)
end)

protectBtn = createButton(trollPage, "Protect: OFF", 210)
protectBtn.MouseButton1Click:Connect(function()
	if not selectedPlayerName and not isProtectActive then
		protectBtn.Text = "Select player!"
		task.delay(1.2, function()
			if protectBtn and not isProtectActive then protectBtn.Text = "Protect: OFF" end
		end)
		return
	end
	local newState = not isProtectActive
	toggleProtect(newState)
	protectBtn.Text = newState and ("Protect: ON → " .. (selectedPlayerName or "?")) or "Protect: OFF"
	protectBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

touchFlingBtn = createButton(trollPage, "Touch Fling: OFF", 250)
touchFlingBtn.MouseButton1Click:Connect(function()
	local newState = not isTouchFlingActive
	toggleTouchFling(newState)
	touchFlingBtn.Text = newState and "Touch Fling: ON" or "Touch Fling: OFF"
	touchFlingBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
end)

local spectateConnection = nil

function stopSpectate()
	isSpectating = false
	if spectateConnection then
		spectateConnection:Disconnect()
		spectateConnection = nil
	end
	local cam = Workspace.CurrentCamera
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then cam.CameraSubject = hum end
	if spectateBtn then
		spectateBtn.Text = "Spectate Selected"
		spectateBtn.TextColor3 = Color3.new(1, 1, 1)
	end
end

function startSpectate()
	if not selectedPlayerName then return end
	local target = Players:FindFirstChild(selectedPlayerName)
	if not target then return end
	stopSpectate()
	isSpectating = true
	if spectateBtn then
		spectateBtn.Text = "Stop Spectate"
		spectateBtn.TextColor3 = COLOR_ACCENT
	end
	spectateConnection = RunService.RenderStepped:Connect(function()
		if not isSpectating then return end
		if not selectedPlayerName then stopSpectate() return end
		local target = Players:FindFirstChild(selectedPlayerName)
		if not target then stopSpectate() return end
		local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.Parent then
			Workspace.CurrentCamera.CameraSubject = hum
		end
	end)
end

spectateBtn = createButton(trollPage, "Spectate Selected", 290)
spectateBtn.MouseButton1Click:Connect(function()
	if isSpectating then
		stopSpectate()
	else
		if not selectedPlayerName then return end
		startSpectate()
	end
end)

local teleportBtn = createButton(trollPage, "Teleport Selected", 330)
teleportBtn.MouseButton1Click:Connect(function()
	if not selectedPlayerName then return end
	local target = Players:FindFirstChild(selectedPlayerName)
	if not target then return end
	local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if tRoot then safeTeleport(tRoot.CFrame * CFrame.new(0, 3, 0)) end
end)

loopGotoBtn = createButton(trollPage, "Loop Goto: OFF", 370)
function stopLoopGoto()
	isLoopGotoActive = false
	if loopGotoConnection then loopGotoConnection:Disconnect() loopGotoConnection = nil end
	if loopGotoBtn then
		loopGotoBtn.Text = "Loop Goto: OFF"
		loopGotoBtn.TextColor3 = Color3.new(1, 1, 1)
	end
end

startLoopGoto = function()
	if not selectedPlayerName then return end
	if loopGotoConnection then loopGotoConnection:Disconnect() loopGotoConnection = nil end
	isLoopGotoActive = true
	if loopGotoBtn then
		loopGotoBtn.Text = "Loop Goto: ON"
		loopGotoBtn.TextColor3 = COLOR_ACCENT
	end
	loopGotoConnection = RunService.Heartbeat:Connect(function()
		if not isLoopGotoActive or not selectedPlayerName then return end
		local target = Players:FindFirstChild(selectedPlayerName)
		if not target or not target.Character then return end
		local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
		local tHum = target.Character:FindFirstChildWhichIsA("Humanoid")
		updateCharacter()
		if not (tRoot and Root and Hum and Char and Hum.Health > 0) then return end
		if tHum and tHum.Health <= 0 then return end
		for _, part in ipairs(Char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
		safeTeleport(tRoot.CFrame * CFrame.new(0, 0, 2))
	end)
end

loopGotoBtn.MouseButton1Click:Connect(function()
	if isLoopGotoActive then
		stopLoopGoto()
	else
		if not selectedPlayerName then return end
		startLoopGoto()
	end
end)

Players.PlayerRemoving:Connect(function(p)
	local wasTarget = (selectedPlayerName == p.Name) or (selectedPlayerUserId and p.UserId == selectedPlayerUserId)
	if wasTarget then
		if isSpectating then stopSpectate() end
		stopLoopGoto()

		if isLoopFlingActive then
			selectedPlayerUserId = p.UserId
			selectedPlayerName = p.Name
			if loopFlingBtn then
				loopFlingBtn.Text = "Loop Fling: ON (waiting)"
				loopFlingBtn.TextColor3 = COLOR_ACCENT
			end
			print("[Loop Fling] Target salió, esperando rejoin:", p.Name, p.UserId)
		else
			selectedPlayerName = nil
			selectedPlayerUserId = nil
			updateDropdownText()
		end
		pcall(updateStatus)
	end
	updatePlayerList()
end)

updatePlayerList()
updateDropdownText()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if waitingForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local newKey = input.KeyCode
			for k, v in pairs(keybinds) do
				if v == newKey and k ~= waitingForKey then
					keybinds[k] = nil
					if keybindButtons[k] then
						keybindButtons[k].Text = "None"
						keybindButtons[k].TextColor3 = Color3.new(1, 1, 1)
					end
				end
			end
			keybinds[waitingForKey] = newKey
			if keybindButtons[waitingForKey] then
				keybindButtons[waitingForKey].Text = getKeyName(newKey)
				keybindButtons[waitingForKey].TextColor3 = Color3.new(1, 1, 1)
			end
			waitingForKey = nil
		end
		return
	end

	local key = input.KeyCode

	if key == keybinds.ToggleMenu then
		guiVisible = not guiVisible
		mainFrame.Visible = guiVisible
		return
	end

	if key == keybinds.Fly then
		local newState = not isFlyActive
		toggleFly(newState)
		if flyBtn then
			flyBtn.Text = newState and "Fly: ON" or "Fly: OFF"
			flyBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
		end
		return
	end

	if key == keybinds.Speed then
		local newState = not isSpeedActive
		toggleSpeed(newState)
		if speedBtn then
			speedBtn.Text = newState and "Speed: ON" or "Speed: OFF"
			speedBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
		end
		return
	end

	if key == keybinds.Noclip then
		local newState = not isNoclipActive
		toggleNoclip(newState)
		if noclipBtn then
			noclipBtn.Text = newState and "Noclip: ON" or "Noclip: OFF"
			noclipBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
		end
		return
	end

	if key == keybinds.AntiFling then
		local newState = not isAntiFlingActive
		toggleAntiFling(newState)
		if antiFlingBtn then
			antiFlingBtn.Text = newState and "Anti Fling: ON" or "Anti Fling: OFF"
			antiFlingBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
		end
		return
	end

	if key == keybinds.InfiniteJump then
		toggleInfiniteJump(not isInfiniteJumpActive)
		return
	end

	if key == keybinds.NameESP then
		local newState = not isNameESPActive
		toggleNameESP(newState)
		if nameESPBtn then
			nameESPBtn.Text = newState and "Name ESP: ON" or "Name ESP: OFF"
			nameESPBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
		end
		return
	end

	if key == keybinds.TouchFling then
		local newState = not isTouchFlingActive
		toggleTouchFling(newState)
		if touchFlingBtn then
			touchFlingBtn.Text = newState and "Touch Fling: ON" or "Touch Fling: OFF"
			touchFlingBtn.TextColor3 = newState and COLOR_ACCENT or Color3.new(1, 1, 1)
		end
		return
	end

	if key == keybinds.LoopFling then
		if isLoopFlingActive then
			stopLoopFling()
		else
			if selectedPlayerName then
				startLoopFling()
			end
		end
		return
	end

	if key == keybinds.GunAimbot then
		toggleGunAimbot(not isGunAimbotActive)
		return
	end
end)

selectPage("MAIN")
updateStatus()
pcall(applyTheme)
print("[The Script Core Hub] Loaded ✓")
