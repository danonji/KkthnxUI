local K, C, L = unpack(select(2, ...))

local _G = _G
local print = print

local ReloadUI = _G.ReloadUI

-- GLOBALS: InstallStepComplete

local function SetupAddons()
	-- DBM
	if K.CheckAddOnState("DBM-Core") and K.CheckAddOnState("DBM-StatusBarTimers") then
		K.LoadDBMProfile()
	end

	-- !BugGrabber
	if K.CheckAddOnState("!BugGrabber") then
		K.LoadBugGrabberProfile()
	end

	-- BugSack
	if K.CheckAddOnState("BugSack") then
		K.LoadBugSackProfile()
	end

	-- Details
	if K.CheckAddOnState("Details") then
		K.LoadDetailsProfile()
	end

	-- MikScrollingBattleText
	if K.CheckAddOnState("MikScrollingBattleText") then
		K.LoadMSBTProfile()
	end

	-- Pawn
	if K.CheckAddOnState("Pawn") then
		K.LoadPawnProfile()
	end

	-- Recount
	if K.CheckAddOnState("Recount") then
		K.LoadRecountProfile()
	end

	-- Skada
	if K.CheckAddOnState("Skada") then
		K.LoadSkadaProfile()
	end

	-- BigWigs
	if K.CheckAddOnState("BigWigs") then
		K.LoadBigWigsProfile()
	end
end

function K.AddOnSettings(msg)
	if msg == "skada" then
		if K.CheckAddOnState("Skada") then
			K.LoadSkadaProfile(true)
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].SkadaText)
		else
			print(L["AddOnData"].SkadaNotText)
		end
	elseif msg == "dbm" then
		if K.CheckAddOnState("DBM-Core") then
			K.LoadDBMProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].DBMText)
		else
			print(L["AddOnData"].DBMNotText)
		end
	elseif msg == "bigwigs" then
		if K.CheckAddOnState("BigWigs") then
			K.LoadBigWigsProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].BigWigsText)
		else
			print(L["AddOnData"].BigWigsNotText)
		end
	elseif msg == "pawn" then
		if K.CheckAddOnState("Pawn") then
			K.LoadPawnProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].PawnText)
		else
			print(L["AddOnData"].PawnNotText)
		end
	elseif msg == "msbt" then
		if K.CheckAddOnState("MikScrollingBattleText") then
			K.LoadMSBTProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].MSBTText)
		else
			print(L["AddOnData"].MSBTNotText)
		end
	elseif msg == "bugsack" then
		if K.CheckAddOnState("BugSack") then
			K.LoadBugSackProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].BugSackText)
		else
			print(L["AddOnData"].BugSackNotText)
		end
	elseif msg == "buggrabber" then
		if K.CheckAddOnState("!BugGrabber") then
			K.LoadBugGrabberProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].BugGrabberText)
		else
			print(L["AddOnData"].BugGrabberNotText)
		end
	elseif msg == "bt4" or msg == "bartender" then
		if K.CheckAddOnState("Bartender4") then
			K.LoadBartenderProfile()
			K.StaticPopup_Show("CHANGES_RL")
			print(L["AddOnData"].BartenderText)
		else
			print(L["AddOnData"].BartenderNotText)
		end
	elseif msg == "all" or msg == "addons" then
		SetupAddons()
		K.StaticPopup_Show("CHANGES_RL")
		K.Print(L["AddOnData"].AllAddOnsText)
	else
		print(L["AddOnData"].InfoText)
	end
end

K:RegisterChatCommand("settings", K.AddOnSettings)