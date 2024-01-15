function Render.dxTabPanel(element, parent, offX, offY)

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

        if isElement(self.rendertarget) then
            local width, height = dxGetMaterialSize( self.rendertarget )
            if self.w ~= width or height ~= self.h then
                self.rendertarget:destroy()
                self.update = true
            end
        end

        if not isElement(self.rendertarget) then
            self.rendertarget = DxRenderTarget(self.w, self.h, true)
        end

        local postgui
        if self.postgui then
            if not isElement(self.parent) then
                postgui = true
            end
        end

        local click = getKeyState( 'mouse1' ) and not self._click-- and not guiGetInputEnabled(  )
        self._click = getKeyState( 'mouse1' )

        -- if click and isCursorOver(x2, y2, self.w, self.h) then
        --     triggerEvent('onClick', element)
        -- end
        
        --local offX = offX
        self.rendertarget:setAsTarget(true)
        dxSetBlendMode( 'modulate_add' )
           
            if not self.vertical then

                if isElement(self.svg) then
                    local alpha = bitExtract(self.colorbackground,24,8)
                    dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha), false)
                else
                    dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
                end

                if self.columnLineVisible then
                    dxDrawRectangle(10*sw, self.fontH*2, self.w-(10*sw), 1, tocolor(255,255,255,100), false)
                end

            else

                if self.rounded then

                    dxDrawRounded1(0, 0, self.columnWidth, self.h, 10, self.colorbackground)
                    dxDrawRounded2(self.columnWidth, 0, (self.w-self.columnWidth), self.h, 10, self.colorbackground)

                else

                    dxDrawRectangle(0, 0, self.columnWidth, self.h, self.colorbackground, false)
                    dxDrawRectangle(self.columnWidth, 0, (self.w-self.columnWidth), self.h, self.colorbackground, false)

                end

                if self.columnLineVisible then
                    dxDrawRectangle(self.columnWidth, 0, 1, self.h, tocolor(255,255,255,100), false)
                end

                --offX = self.columnWidth
            end

            local cx = 10*sw
            local cy = 10*sh
            local section;
            for i, v in ipairs(self.childs) do
                if isElement(v) then

                    local child = Cache[v]

                    if not self.selected then
                        if not child.section then
                            self.selected = v
                        end
                    end
                    if not self.vertical then

                        local w = dxGetTextWidth(child.text, 1, self.font )
                        dxDrawText2(child.text, cx, 0, w, self.fontH*2, child.color, 1, self.font, 'left', 'center', true, true, false, false)

                        if isCursorOver(x2+cx, y2, w, self.fontH*2) then
                            if click then
                                triggerEvent('onTabChange', element, v)
                                if not wasEventCancelled(  ) then
                                    self.selected = v
                                end
                            end
                        end

                        if self.selected == v then
                            dxDrawRoundedRectangle(cx, -1.2*sh, w, 4*sh, self.colorselected, 2)
                        end

                        cx = cx + w + 25*sw
                    else

                        if child.section then
                            section = child.text
                            
                            dxDrawText2(child.text, 10*sw, cy, self.columnWidth-8*sw, self.fontH * 1.8, child.color, 1, self.font2, 'left', 'center', true, true, false, false)
                        else
                           -- print(child.parentsection , section)
                            if section and child.parentsection and child.parentsection == section then
                                dxDrawText2(child.text, 20*sw, cy, self.columnWidth-8*sw, self.fontH * 1.8, child.color, 1, self.font, 'left', 'center', true, true, false, false)
                            else
                                dxDrawText2(child.text, 4*sw, cy, self.columnWidth-8*sw, self.fontH * 1.8, child.color, 1, self.font, 'center', 'center', true, true, false, false)
                            end
                        end

                        if isCursorOver(x2+4*sw, y2+cy, self.columnWidth-8*sw, self.fontH * 1.8) then
                            if click and not child.section then
                                triggerEvent('onTabChange', element, v)
                                if not wasEventCancelled(  ) then
                                    self.selected = v
                                end
                            end
                        end

                        if self.selected == v and not child.section then
                            dxDrawRoundedRectangle(-1.2*sw, cy, 4*sw, self.fontH * 1.8, self.colorselected, 2)
                        end

                        cy = cy + (self.fontH * 1.8)
                    end

                end
            end

            local v = self.selected
            if isElement(v) then
                for i, v in ipairs(Cache[v].childs) do
                    if isElement(v) then
                        Render[v.type](v, element, 0, 0)
                    end
                end
            end

        dxSetBlendMode( 'blend' )


        if isElement(parent) then
            dxSetRenderTarget(Cache[parent].rendertarget)
        else
            dxSetRenderTarget()
        end

            
        if isElement(self.rendertarget) then
            dxSetBlendMode("add")
                dxDrawImage(x, y, self.w, self.h, self.rendertarget, 0, 0, 0, tocolor(255,255,255,self.alpha), postgui)
            dxSetBlendMode("blend")
        end
    end
end

function Render.dxTab(element)

end

