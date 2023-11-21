function Render.dxRadioButton(element, parent, offX, offY)

    local self = Cache[element]
    if self and isElement(element) then

        if not self.isVisible then
            return
        end

        local x, y, x2, y2 = self.x, self.y, self.x, self.y
        if isElement(parent) then
            x, y = self.offsetX, self.offsetY
            --
            if x2 ~= (Cache[parent].x + x) or y2 ~= (Cache[parent].y + y) then
                x2, y2 = Cache[parent].x + x, Cache[parent].y + y
                self.x, self.y = x2, y2
            end
        end

        x, y = x + (offX or 0), y + (offY or 0)
        x2, y2 = x2 + (offX or 0), y2 + (offY or 0)

        local click = getKeyState( 'mouse1' ) and not self._click and not guiGetInputEnabled(  )
        self._click = getKeyState( 'mouse1' )

        -- if click then
        --     if isCursorOver(x2, y2, self.w, self.h) then

        --         dxRadioButtonSetSelected(element)
        --         triggerEvent('onClick', element)
                
        --     end
        -- end

        local postgui
        if self.postgui then
            if not isElement(self.parent) then
                postgui = true
            end
        end
        
        dxSetBlendMode("add")
            local alpha = bitExtract(self.colorbackground,24,8)
            if (isElement(self.parent) and radioButtonSelected[self.parent] == element) or (not isElement(self.parent) and radioButtonSelected.noParent and radioButtonSelected.noParent == element) then 
                if isElement(self.svg2) then
                    dxDrawImage(x, y, self.w, self.h, self.svg2, 0, 0, 0, tocolor(255,255,255,alpha), postgui)
                end
            else
                if isElement(self.svg) then
                    dxDrawImage(x, y, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha), postgui)
                end
            end
        dxSetBlendMode("blend")

        dxSetBlendMode( 'modulate_add' )
            dxDrawText2( self.text, x+self.w+5, y, self.w, self.h, self.colortext, 1, self.font, 'left', 'center', false, false, postgui, false)
        dxSetBlendMode("blend")

    end
end