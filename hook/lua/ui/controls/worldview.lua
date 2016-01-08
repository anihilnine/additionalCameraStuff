local acs_modpath = "/mods/additionalCameraStuff/"
local CM = import('/lua/ui/game/commandmode.lua')
local Decal = import('/lua/user/userdecal.lua').UserDecal

local ACSdata = {
    isPreviewAlive = false,
    rings = {
        buildrange = {},
    },
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

function createPreview(units)
    -- buildrange
    for _, u in EntityCategoryFilterDown(categories.ENGINEER, units or {}) do
        local bp = u:GetBlueprint()
        if bp.Economy.MaxBuildDistance then
            if (not ACSdata.rings.buildrange[bp.Economy.MaxBuildDistance]) then
                ACSdata.rings.buildrange[bp.Economy.MaxBuildDistance] = Decal(GetFrame(0))
                ACSdata.rings.buildrange[bp.Economy.MaxBuildDistance]:SetTexture(acs_modpath..'textures/range_ring.dds')
                ACSdata.rings.buildrange[bp.Economy.MaxBuildDistance]:SetScale({math.floor(2.03*(bp.Economy.MaxBuildDistance+2))+2, 0, math.floor(2.03*(bp.Economy.MaxBuildDistance+2))+2})
                ACSdata.rings.buildrange[bp.Economy.MaxBuildDistance]:SetPosition(GetMouseWorldPos())
            end
        end
    end
    ACSdata.isPreviewAlive = true
end

function createPreviewOfCurrentSelection()
    createPreview(GetSelectedUnits() or {})
end

function updatePreview()
    if (not ACSdata.isPreviewAlive) then
        createPreviewOfCurrentSelection()
    end
    for _, group in ACSdata.rings do
        for __, ring in group do
            ring:SetPosition(GetMouseWorldPos())
        end
    end
end

function removePreview()
    if (not ACSdata.isPreviewAlive) then
        return
    end
    for n, group in ACSdata.rings do
        for n2, ring in group do
            ring:Destroy()
            ACSdata.rings[n][n2] = nil
        end
    end
    ACSdata.isPreviewAlive = false
end


local oldWorldView = WorldView 
WorldView = Class(oldWorldView, Control) {

    isZoom = true,
    isPreviewBuildrange = false,
    previewKey = "SHIFT",

    HandleEvent = function(self, event)
        if (not self.isZoom) and (event.Type == 'WheelRotation') then
            return true
        end
        return oldWorldView.HandleEvent(self, event)
    end,

    OnUpdateCursor = function(self)
        if self.isPreviewBuildrange then
            if IsKeyDown(self.previewKey) and (isAcceptablePreviewMode(CM.GetCommandMode())) then
                updatePreview()
            else
                removePreview()
            end
        end
        return oldWorldView.OnUpdateCursor(self)
    end,

    SetAllowZoom = function(self, bool)
        self.isZoom = bool
    end,

    SetPreviewBuildrange = function(self, bool)
        if (not bool) then
            removePreview()
        end
        self.isPreviewBuildrange = bool
    end,

    SetPreviewKey = function(self, newKey)
        self.previewKey = newKey
    end,
}
