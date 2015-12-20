local oldWorldView = WorldView 
WorldView = Class(oldWorldView, Control) {

    isZoom = true,

    HandleEvent = function(self, event)
        if (not self.isZoom) and (event.Type == 'WheelRotation') then
            return true
        end
        if self.EventRedirect then
            return self.EventRedirect(self,event)
        end
        if event.Type == 'MouseEnter' or event.Type == 'MouseMotion' then
            self.bMouseIn = true
            if self.Cursor then
                if (self.LastCursor == nil) or (self.Cursor[1] != self.LastCursor[1]) then
                    self.LastCursor = self.Cursor
                    GetCursor():SetTexture(unpack(self.Cursor))
                end
            else
                GetCursor():Reset()
            end
        elseif event.Type == 'MouseExit' then
            self.bMouseIn = false
            GetCursor():Reset()
            self.LastCursor = nil
            if self.TargetDecal then
                self.TargetDecal:Destroy()
                self.TargetDecal = false
                self.DecalTexture = false
                self.DecalScale = false
            end
        end
        return false
    end,

    SetAllowZoom = function(self, bool)
        self.isZoom = bool
    end,
}
