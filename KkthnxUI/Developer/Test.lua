-- So I can test stuff.

-- Use this file for testing stuff that I do not want in the UI or I am unsure about.
-- This is a good file to mess around with code in for anyone else as well.

-- CodeName : Code Gone Wild D

local K, C, L = unpack(select(2, ...))
-- if not K.IsDeveloper() and not K.IsDeveloperRealm() then return end

-- Always debug our temp code.
--if LibDebug then LibDebug() end

-- Lua API

-- Wow API

-- Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS:

local K, C, L = unpack(select(2, ...))

-- Lua API
local _G = _G
local bit_band = bit.band
local select = select

-- Wow API
local UnitGUID = _G.UnitGUID
local GetPlayerInfoByGUID = _G.GetPlayerInfoByGUID
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local ACTION_PARTY_KILL = _G.ACTION_PARTY_KILL

-- Global variables that we don't cache, list them here for mikk"s FindGlobals script
-- GLOBALS: COMBATLOG_OBJECT_CONTROL_PLAYER

local playerid = UnitGUID("player")

-- Setup message frame
local KillingBlowMsg = CreateFrame("ScrollingMessageFrame", "KillingBlowMsgFrame", UIParent)
KillingBlowMsg:SetPoint("CENTER", 0, 205)
KillingBlowMsg:SetWidth(256)
KillingBlowMsg:SetHeight(112)
KillingBlowMsg:SetSpacing(1)
KillingBlowMsg:SetClampedToScreen(true)
KillingBlowMsg:SetInsertMode("TOP")
KillingBlowMsg:SetTimeVisible(3)
KillingBlowMsg:SetFadeDuration(1.5)
KillingBlowMsg:SetFont(C.Media.Font, 18, "OUTLINE")
KillingBlowMsg:SetClampRectInsets(0, 0, 18, 0)

local PVPKillingBlow = CreateFrame("Frame")
PVPKillingBlow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
PVPKillingBlow:SetScript("OnEvent", function(self, event, ...)
	if C.Misc.PvPEmote ~= true then return end
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags = ...
	if (event == "PARTY_KILL") and (sourceGUID == playerid) and (bit_band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0) then
		local destGUID, tname = select(8, ...)
		local classIndex = select(2, GetPlayerInfoByGUID(destGUID))
		local color = classIndex and RAID_CLASS_COLORS[classIndex] or {r = 0.2, g = 1, b = 0.2}
		KillingBlowMsg:AddMessage("|cff33FF33"..ACTION_PARTY_KILL..": |r"..tname, color.r, color.g, color.b)
	end
end)