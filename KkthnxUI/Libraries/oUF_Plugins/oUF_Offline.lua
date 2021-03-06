local _, ns = ...
local oUF = ns.oUF or _G.oUF

local Update = function(self, event, unit)
    if unit ~= self.unit then
        return
    end

    local unit = unit or self.unit

    if UnitIsConnected(unit) then
        self.OfflineIcon:Hide()
    else
        self.OfflineIcon:Show()
    end
end

local Path = function(self, ...)
    return (self.OfflineIcon.Override or Update)(self, ...)
end

local ForceUpdate = function(element)
    return Path(element.__owner, "ForceUpdate")
end

local Enable = function(self)
    local officon = self.OfflineIcon

    if officon then
        officon.__owner = self
        officon.ForceUpdate = ForceUpdate

        self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)
        self:RegisterEvent("UNIT_CONNECTION", Path)

        if officon:IsObjectType("Texture") and not officon:GetTexture() then
            officon:SetTexture("Interface\\CharacterFrame\\Disconnect-Icon")
        end

        return true
    end
end

local Disable = function(self)
    local officon = self.OfflineIcon

    if officon then
        self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
        self:UnregisterEvent("UNIT_CONNECTION", Path)
    end
end

oUF:AddElement("OfflineIcon", Path, Enable, Disable)