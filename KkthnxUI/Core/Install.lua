local K, C, L = unpack(select(2, ...))

local _G = _G
local print = print

local APPLY = _G.APPLY
local CLOSE = _G.CLOSE
local COMPLETE = _G.COMPLETE
local CreateAnimationGroup = _G.CreateAnimationGroup
local CreateFrame = _G.CreateFrame
local GetRealmName = _G.GetRealmName
local NEXT = _G.NEXT
local PlaySoundFile = _G.PlaySoundFile
local PREVIOUS = _G.PREVIOUS
local ReloadUI = _G.ReloadUI
local RESET_TO_DEFAULT = _G.RESET_TO_DEFAULT
local SetActionBarToggles = _G.SetActionBarToggles
local SetCVar = _G.SetCVar
local UIParent = _G.UIParent
local UnitName = _G.UnitName

local Install = CreateFrame("Frame", "KkthnxUIInstaller", UIParent)
local InstallFont = K.GetFont(C["General"].Font)
local InstallTexture = K.GetTexture(C["General"].Texture)

Install.MaxStepNumber = 3
Install.CurrentStep = 0
Install.Width = 500
Install.Height = 200

function Install:ResetData()
	KkthnxUIData[GetRealmName()][UnitName("player")] = {}
	KkthnxUIData[GetRealmName()][UnitName("player")].AutoInvite = false
	KkthnxUIData[GetRealmName()][UnitName("player")].BarsLocked = false
	KkthnxUIData[GetRealmName()][UnitName("player")].BottomBars = C["ActionBar"].BottomBars
	KkthnxUIData[GetRealmName()][UnitName("player")].RevealWorldMap = false
	KkthnxUIData[GetRealmName()][UnitName("player")].RightBars = C["ActionBar"].RightBars
	KkthnxUIData[GetRealmName()][UnitName("player")].SplitBars = true
	KkthnxUIData[GetRealmName()][UnitName("player")].WatchedMovies = {}

	if (KkthnxUIConfigPerAccount) then
		KkthnxUIConfigShared.Account = {}
	else
		KkthnxUIConfigShared[GetRealmName()][UnitName("player")] = {}
	end

	ReloadUI()
end

function Install:Step1()
	local ActionBars = C["ActionBar"].Enable

	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("SpamFilter", 0)
	SetCVar("UberTooltips", 1)
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("autoOpenLootHistory", 0)
	SetCVar("autoQuestProgress", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("buffDurations", 1)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("countdownForCooldowns", 0)
	SetCVar("lockActionBars", 1)
	SetCVar("lossOfControl", 1)
	SetCVar("nameplateMotion", 0)
	SetCVar("nameplateShowFriendlyNPCs", 1)
	SetCVar("nameplateShowSelf", 0)
	SetCVar("removeChatDelay", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("showArenaEnemyFrames", 0)
	SetCVar("showQuestTrackingTooltips", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showVKeyCastbar", 1)
	SetCVar("spamFilter", 0)
	SetCVar("statusTextDisplay", "BOTH")
	SetCVar("threatWarning", 3)
	SetCVar("violenceLevel", 5)

	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue("SHIFT")
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()

	if (ActionBars) then
		SetActionBarToggles(1, 1, 1, 1)
	end

	_G.RaidNotice_AddMessage(_G.RaidWarningFrame, L["Install"].CVars_Set, _G.ChatTypeInfo["RAID_WARNING"])
end

function Install:Step2()
	local Chat = K:GetModule("Chat")

	if (not Chat) then
		return
	end

	_G.RaidNotice_AddMessage(_G.RaidWarningFrame, L["Install"].Chat_Set, _G.ChatTypeInfo["RAID_WARNING"])

	Chat:Install()
	Chat:SetDefaultChatFramesPositions()
end

function Install:PrintStep(PageNum)
	self.CurrentStep = PageNum

	local ExecuteScript = self["Step" .. PageNum]
	local Text = L.Install["Step_" .. PageNum]
	local r, g, b = K.ColorGradient(PageNum / self.MaxStepNumber, 1, 0, 0, 1, 1, 0, 0, 1, 0)

	if (not Text) then
		self:Hide()
		if (PageNum > self.MaxStepNumber) then
			KkthnxUIData[GetRealmName()][UnitName("player")].InstallComplete = true
			PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_04.ogg") -- People will be like wtf?
			ReloadUI()
		end
		return
	end

	if (PageNum == 0) then
		self.LeftButton.Text:SetText(CLOSE)
		self.LeftButton:SetScript("OnClick", function() self:Hide() end)
		self.RightButton.Text:SetText(NEXT)
		self.RightButton:SetScript("OnClick", function() self.PrintStep(self, self.CurrentStep + 1) end)
		self.MiddleButton.Text:SetText("|cffFF0000"..RESET_TO_DEFAULT.."|r")
		self.MiddleButton:SetScript("OnClick", self.ResetData)
		self.CloseButton:Show()
		if (KkthnxUIData[GetRealmName()][UnitName("player")].InstallComplete) then
			self.MiddleButton:Show()
		else
			self.MiddleButton:Hide()
		end
	else
		self.LeftButton:SetScript("OnClick", function()
			self.PrintStep(self, self.CurrentStep - 1)
		end)
		self.LeftButton.Text:SetText(PREVIOUS)
		self.MiddleButton.Text:SetText(APPLY)
		self.RightButton:SetScript("OnClick", function()
			self.PrintStep(self, self.CurrentStep + 1)
		end)
		if (PageNum == Install.MaxStepNumber) then
			self.RightButton.Text:SetText(COMPLETE)
			self.CloseButton:Hide()
			self.MiddleButton:Hide()
			self.DiscordButton:Show()
		else
			self.RightButton.Text:SetText(NEXT)
			self.CloseButton:Show()
			self.MiddleButton:Show()
			self.DiscordButton:Hide()
		end
		if (ExecuteScript) then
			self.MiddleButton:SetScript("OnClick", ExecuteScript)
		end
	end

	self.Text:SetText(Text)

	self.StatusBar.Anim:SetChange(PageNum)
	self.StatusBar.Anim:Play()

	self.StatusBar.Anim2:SetChange(r, g, b)
	self.StatusBar.Anim2:Play()

	self.StatusBar.text:SetText(self.CurrentStep.." / "..self.MaxStepNumber)
end

function Install:Launch()
	if (self.Description) then
		self:Show()
		return
	end

	local r, g, b = K.ColorGradient(0, self.MaxStepNumber, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	self.Description = CreateFrame("Frame", nil, self)
	self.Description:SetSize(self.Width, self.Height)
	self.Description:SetPoint("CENTER", self, "CENTER")
	self.Description:CreateBorder()

	self.Description:SetClampedToScreen(true)
	self.Description:SetMovable(true)
	self.Description:EnableMouse(true)
	self.Description:RegisterForDrag("LeftButton")
	self.Description:SetScript("OnDragStart", self.Description.StartMoving)
	self.Description:SetScript("OnDragStop", self.Description.StopMovingOrSizing)

	self.Description:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.Description:RegisterEvent("PLAYER_REGEN_ENABLED")
	self.Description:SetScript("OnEvent", function(_, event)
		if (event == "PLAYER_REGEN_DISABLED") then
			Install:Hide()
		else
			if (not KkthnxUIData[GetRealmName()][UnitName("player")].InstallComplete) then
				Install:Show()
			end
		end
	end)

	self.StatusBar = CreateFrame("StatusBar", nil, self)
	self.StatusBar:SetStatusBarTexture(InstallTexture)
	self.StatusBar:SetPoint("BOTTOM", self.Description, "TOP", 0, 6)
	self.StatusBar:SetHeight(20)
	self.StatusBar:SetWidth(self.Description:GetWidth())
	self.StatusBar:SetStatusBarColor(r, g, b)
	self.StatusBar:SetMinMaxValues(0, self.MaxStepNumber)
	self.StatusBar:SetValue(0)
	self.StatusBar:CreateBorder()

	self.StatusBar.Anim = CreateAnimationGroup(self.StatusBar):CreateAnimation("Progress")
	self.StatusBar.Anim:SetDuration(0.3)
	self.StatusBar.Anim:SetSmoothing("InOut")

	self.StatusBar.Anim2 = CreateAnimationGroup(self.StatusBar):CreateAnimation("Color")
	self.StatusBar.Anim2:SetDuration(0.3)
	self.StatusBar.Anim2:SetSmoothing("InOut")
	self.StatusBar.Anim2:SetColorType("StatusBar")

	self.StatusBar.text = self.StatusBar:CreateFontString(nil, "OVERLAY")
	self.StatusBar.text:SetFontObject(InstallFont)
	self.StatusBar.text:SetPoint("CENTER")
	self.StatusBar.text:SetText(self.CurrentStep.." / "..self.MaxStepNumber)

	self.Logo = self.StatusBar:CreateTexture(nil, "OVERLAY")
	self.Logo:SetSize(512, 256)
	self.Logo:SetBlendMode("ADD")
	self.Logo:SetAlpha(0.10)
	self.Logo:SetTexture(C["Media"].Logo)
	self.Logo:SetPoint("CENTER", self.Description, "CENTER", 0, 0)

	self.LeftButton = CreateFrame("Button", nil, self)
	self.LeftButton:SetPoint("TOPLEFT", self.Description, "BOTTOMLEFT", 0, -6)
	self.LeftButton:SetSize(128, 25)
	self.LeftButton:SkinButton()
	self.LeftButton:FontString("Text", C["Media"].Font, 12)
	self.LeftButton.Text:SetPoint("CENTER")
	self.LeftButton.Text:SetText(CLOSE)
	self.LeftButton:SetScript("OnClick", function() self:Hide() end)

	self.RightButton = CreateFrame("Button", nil, self)
	self.RightButton:SetPoint("TOPRIGHT", self.Description, "BOTTOMRIGHT", 0, -6)
	self.RightButton:SetSize(128, 25)
	self.RightButton:SkinButton()
	self.RightButton:FontString("Text", C["Media"].Font, 12)
	self.RightButton.Text:SetPoint("CENTER")
	self.RightButton.Text:SetText(NEXT)
	self.RightButton:SetScript("OnClick", function() self.PrintStep(self, self.CurrentStep + 1) end)

	self.DiscordButton = CreateFrame("Button", nil, self)
	self.DiscordButton:SetPoint("TOPLEFT", self.LeftButton, "TOPRIGHT", 6, 0)
	self.DiscordButton:SetPoint("BOTTOMRIGHT", self.RightButton, "BOTTOMLEFT", -6, 0)
	self.DiscordButton:SkinButton()
	self.DiscordButton:FontString("Text", C["Media"].Font, 12)
	self.DiscordButton.Text:SetPoint("CENTER")
	self.DiscordButton.Text:SetText("|cff7289daDiscord|r")
	self.DiscordButton:SetScript("OnClick", function() K.StaticPopup_Show("DISCORD_EDITBOX", nil, nil, "https://discord.gg/YUmxqQm") end)
	self.DiscordButton:Hide()

	self.MiddleButton = CreateFrame("Button", nil, self)
	self.MiddleButton:SetPoint("TOPLEFT", self.LeftButton, "TOPRIGHT", 6, 0)
	self.MiddleButton:SetPoint("BOTTOMRIGHT", self.RightButton, "BOTTOMLEFT", -6, 0)
	self.MiddleButton:SkinButton()
	self.MiddleButton:FontString("Text", C["Media"].Font, 12)
	self.MiddleButton.Text:SetPoint("CENTER")
	self.MiddleButton.Text:SetText("|cffFF0000"..RESET_TO_DEFAULT.."|r")
	self.MiddleButton:SetScript("OnClick", self.ResetData)
	if (KkthnxUIData[GetRealmName()][UnitName("player")].InstallComplete) then
		self.MiddleButton:Show()
	else
		self.MiddleButton:Hide()
	end

	self.CloseButton = CreateFrame("Button", nil, self, "UIPanelCloseButton")
	self.CloseButton:SetPoint("TOPRIGHT", self.Description, "TOPRIGHT")
	self.CloseButton:SetScript("OnClick", function() self:Hide() end)
	self.CloseButton:SetFrameLevel(self:GetFrameLevel() + 2) -- Fix the close button falling behind install frame
	self.CloseButton:SkinCloseButton()

	self.Text = self.Description:CreateFontString(nil, "OVERLAY")
	self.Text:SetSize(self.Description:GetWidth() - 40, self.Description:GetHeight() - 60)
	self.Text:SetJustifyH("LEFT")
	self.Text:SetJustifyV("TOP")
	self.Text:SetFontObject(InstallFont)
	self.Text:SetPoint("TOPLEFT", 20, -40)
	self.Text:SetText(L.Install.Step_0)

	self:SetAllPoints(UIParent)
end

-- On login function
Install:RegisterEvent("ADDON_LOADED")
Install:SetScript("OnEvent", function(self)
	local playerName = UnitName("player")
	local playerRealm = GetRealmName()

	-- Define the saved variables first. This is important
	if (not KkthnxUIData) then
		KkthnxUIData = KkthnxUIData or {}
	end

	-- Create missing entries in the saved vars if they don"t exist.
	if (not KkthnxUIData[playerRealm]) then
		KkthnxUIData[playerRealm] = KkthnxUIData[playerRealm] or {}
	end

	if (not KkthnxUIData[playerRealm][playerName]) then
		KkthnxUIData[playerRealm][playerName] = KkthnxUIData[playerRealm][playerName] or {}
	end

	if (KkthnxUIDataPerChar) then
		KkthnxUIData[playerRealm][playerName] = KkthnxUIDataPerChar
		KkthnxUIDataPerChar = nil
	end

	if (not KkthnxUIData[playerRealm][playerName].BarsLocked) then
		KkthnxUIData[playerRealm][playerName].BarsLocked = false
	end

	if (not KkthnxUIData[playerRealm][playerName].BottomBars) then
		KkthnxUIData[playerRealm][playerName].BottomBars = C["ActionBar"].BottomBars
	end

	if (not KkthnxUIData[playerRealm][playerName].RightBars) then
		KkthnxUIData[playerRealm][playerName].RightBars = C["ActionBar"].RightBars
	end

	if (not KkthnxUIData[playerRealm][playerName].RevealWorldMap) then
		KkthnxUIData[playerRealm][playerName].RevealWorldMap = false
	end

	if (not KkthnxUIData[playerRealm][playerName].AutoInvite) then
		KkthnxUIData[playerRealm][playerName].AutoInvite = false
	end

	if (not KkthnxUIData[playerRealm][playerName].WatchedMovies) then
		KkthnxUIData[playerRealm][playerName].WatchedMovies = KkthnxUIData[playerRealm][playerName].WatchedMovies or {}
	end

	if (not KkthnxUIData[playerRealm][playerName].SplitBars) then
		KkthnxUIData[playerRealm][playerName].SplitBars = true
	end

	-- Install default if we never ran KkthnxUI on this character.
	local IsInstalled = KkthnxUIData[playerRealm][playerName].InstallComplete
	if (not IsInstalled) then
		self:Launch()
	end

	-- Welcome message
	if (not KkthnxUIData[playerRealm][playerName].InstallComplete) then
		print(K.Welcome)
	end

	if C["General"].Welcome then
		print(L["Install"].Welcome_1)
		print(L["Install"].Welcome_2)
		print(L["Install"].Welcome_3)
	end

	self:UnregisterEvent("ADDON_LOADED")
end)

_G.SLASH_INSTALLUI1 = "/install"
SlashCmdList["INSTALLUI"] = function()
	Install:Launch()
end

_G.SLASH_RESETUI1 = "/reset"
SlashCmdList["RESETUI"] = function()
	K.StaticPopup_Show("RESET_UI")
end

_G.SLASH_DISABLEUI1 = "/disable"
SlashCmdList["DISABLEUI"] = function()
	K.StaticPopup_Show("DISABLE_UI")
end

K["Install"] = Install