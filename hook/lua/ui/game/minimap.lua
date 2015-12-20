local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local Tooltip = import('/lua/ui/game/tooltip.lua')
local Prefs = import('/lua/user/prefs.lua')

local oldCreateMinimap = CreateMinimap
function CreateMinimap(parent)
    local isMinimapZoom = false

    oldCreateMinimap(parent)
    controls.miniMap:SetAllowZoom(isMinimapZoom)


    controls.displayGroup.lockZoomButton = Button(controls.displayGroup.TitleGroup,
        UIUtil.SkinnableFile('/game/menu-btns/default_btn_up.dds'),
        UIUtil.SkinnableFile('/game/menu-btns/default_btn_down.dds'),
        UIUtil.SkinnableFile('/game/menu-btns/default_btn_over.dds'),
        UIUtil.SkinnableFile('/game/menu-btns/default_btn_dis.dds'))
    LayoutHelpers.LeftOf(controls.displayGroup.lockZoomButton, controls.displayGroup.resetBtn)
    controls.displayGroup.lockZoomButton.OnClick = function(modifiers)
        isMinimapZoom = (not isMinimapZoom)
        controls.miniMap:SetAllowZoom(isMinimapZoom)
    end
    Tooltip.AddButtonTooltip(controls.displayGroup.lockZoomButton, {
        text = "Minimap Zoom",
        body = "Enables/Disables zooming on the minimap",
    })
end