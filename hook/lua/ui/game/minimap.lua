local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local Tooltip = import('/lua/ui/game/tooltip.lua')
local Prefs = import('/lua/user/prefs.lua')

local acs_modpath = "/mods/additionalCameraStuff/"
local prefs = import(acs_modpath..'modules/ACSprefs.lua')

local isMinimapZoom = false

local oldCreateMinimap = CreateMinimap
function CreateMinimap(parent)
    oldCreateMinimap(parent)
    controls.miniMap:SetAllowZoom(isMinimapZoom)

    controls.displayGroup.lockZoomButton = Button(controls.displayGroup.TitleGroup,
        UIUtil.SkinnableFile('/game/menu-btns/config_btn_up.dds'),
        UIUtil.SkinnableFile('/game/menu-btns/config_btn_down.dds'),
        UIUtil.SkinnableFile('/game/menu-btns/config_btn_over.dds'),
        UIUtil.SkinnableFile('/game/menu-btns/config_btn_dis.dds'))
    LayoutHelpers.LeftOf(controls.displayGroup.lockZoomButton, controls.displayGroup.resetBtn)

    controls.displayGroup.lockZoomButton.OnClick = function(self)
        local savedPrefs = prefs.getPreferences()
        savedPrefs.Minimap.isZoomEnabled = not savedPrefs.Minimap.isZoomEnabled
        prefs.saveModifiedPrefs(savedPrefs)
    end

    Tooltip.AddButtonTooltip(controls.displayGroup.lockZoomButton, {
        text = "Minimap Zoom",
        body = "Enables/Disables zooming for the minimap",
    })

    prefs.addPreferenceChangeListener(function()
        local savedPrefs = prefs.getPreferences()
        isMinimapZoom = savedPrefs.Minimap.isZoomEnabled
        controls.miniMap:SetAllowZoom(isMinimapZoom)
    end)
end