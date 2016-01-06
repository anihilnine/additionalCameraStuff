local acs_modpath = "/mods/additionalCameraStuff/"
local prefs = import(acs_modpath..'modules/ACSprefs.lua')
local CM = import('/lua/ui/game/commandmode.lua')
local Decal = import('/lua/user/userdecal.lua').UserDecal

local ACSdata = {
    displayedRing = nil,
}
function isAcceptablePreviewMode(mode)
    if (not mode[2]) then
        return true
    end
    if (mode[1] == "order") then
        for _, s in {"RULEUCC_Move"} do
            if (mode[2].name == s) then
                return true
            end
        end
    end
    return false
end

function updatePreview(unit, cursor, worldview)
    if (not cursor) then
        return
    end
    if (not unit:IsInCategory("ENGINEER")) then
        return
    end
    local bp = unit:GetBlueprint()
    ACSdata.displayedRing = Decal(GetFrame(0))
    ACSdata.displayedRing:SetTexture(acs_modpath..'textures/range_ring.dds')
    if bp.Economy.MaxBuildDistance then
        ACSdata.displayedRing:SetScale({math.floor(2.03*(bp.Economy.MaxBuildDistance+2))+2, 0, math.floor(2.03*(bp.Economy.MaxBuildDistance+2))+2})
    else
        ACSdata.displayedRing:SetScale({22, 0, 22})
    end
    ACSdata.displayedRing:SetPosition(GetMouseWorldPos())
end

function removePreview()
    if ACSdata.displayedRing then
        ACSdata.displayedRing:Destroy()
        ACSdata.displayedRing = nil
    end
end

local oldWorldView = WorldView 
WorldView = Class(oldWorldView, Control) {

    isZoom = true,
    isPreviewBuildrange = false,

    HandleEvent = function(self, event)
        if (not self.isZoom) and (event.Type == 'WheelRotation') then
            return true
        end
        return oldWorldView.HandleEvent(self, event)
    end,

    OnUpdateCursor = function(self)
        if self.isPreviewBuildrange then
            removePreview()
            if IsKeyDown("Shift") then
                local selectedUnits = GetSelectedUnits() or {}
                if (table.getn(selectedUnits) == 1) then
                    if (isAcceptablePreviewMode(CM.GetCommandMode())) then
                        updatePreview(selectedUnits[1], GetCursor(), self)
                    end
                end
            end
        end
        return oldWorldView.OnUpdateCursor(self)
    end,

    SetAllowZoom = function(self, bool)
        self.isZoom = bool
    end,

    SetPreviewBuildrange = function(self, bool)
        removePreview()
        self.isPreviewBuildrange = bool
    end,
}
