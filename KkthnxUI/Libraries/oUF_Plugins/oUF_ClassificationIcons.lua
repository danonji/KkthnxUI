local _, ns = ...
local oUF = ns.oUF or oUF

local UnitClassification = UnitClassification

local function Update(self)
	local element = self.ClassificationIndicator

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	local unit = self.unit
	local classification = UnitClassification(unit)
	if classification == "elite" or classification == "worldboss" then
		element:SetTexCoord(0, 0.15, 0.25, 0.53)
		element:Show()
	elseif classification == "rareelite" or classification == "rare" then
		element:SetTexCoord(0, 0.15, 0.52, 0.84)
		element:Show()
	else
		element:Hide()
	end

	if (element.PostUpdate) then
		return element:PostUpdate(classification)
	end
end

local function Path(self, ...)
	return (self.ClassificationIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.ClassificationIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		if (element:IsObjectType("Texture") and not element:GetTexture()) then
			element:SetTexture([[Interface\TARGETINGFRAME\Nameplates]])
		end

		self:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED", Path)

		return true
	end
end

local function Disable(self)
	local element = self.ClassificationIndicator
	if (element) then
		element:Hide()
		self:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED")
	end
end

oUF:AddElement("ClassificationIndicator", Path, Enable, Disable)