local oldWorldView = WorldView 
WorldView = Class(oldWorldView, Control) {

    isZoom = true,

    HandleEvent = function(self, event)
        if (not self.isZoom) and (event.Type == 'WheelRotation') then
            return true
        end
        return oldWorldView.HandleEvent(self, event)
    end,

    SetAllowZoom = function(self, bool)
        self.isZoom = bool
    end,
}
