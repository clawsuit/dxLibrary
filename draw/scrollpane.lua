function Render.dxScrollPane(element, parent, offX, offY)

    local self = Cache[element]
    if self and isElement(element) then

        if not self.isVisible then
            return
        end

        local offX, offY = (offX or 0), (offY or 0)
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

        local click = getKeyState( 'mouse1' ) and not self._click and not guiGetInputEnabled(  )
        self._click = getKeyState( 'mouse1' )

        -- if click and isCursorOver(x2, y2, self.w, self.h) then
        --     triggerEvent('onClick', element)
        -- end

        local restX, restY = 0, 0
        for i, v in ipairs(self.childs) do
            if isElement(v) then
                
                local child = Cache[v]
                if child then

                    local x_w = child.x + child.w 
                    local px_pw = x2 + self.w

                    if x_w > px_pw then
                        if x_w-px_pw > restX then
                            restX = x_w-px_pw
                        end
                    end

                    local y_h = child.y + child.h 
                    local py_ph = y2 + self.h

                    if y_h > py_ph then
                        if y_h-py_ph > restY then
                            restY = y_h-py_ph
                        end
                    end

                end
            end
        end

        self.scrollX = restX
        self.scrollY = restY

        if restX > 0 then

            if not Cache[self.scrollH].isVisible then
                Cache[self.scrollH].isVisible = true
            end

            offX = offX - ((self.scrollX+math.round(17*sh))*Cache[self.scrollH].current)

        else
            if Cache[self.scrollH].isVisible then
                Cache[self.scrollH].isVisible = false
            end
        end
        
        if restY > 0 then

            if not Cache[self.scrollV].isVisible then
                Cache[self.scrollV].isVisible = true
            end

            offY = offY - ((self.scrollY+math.round(17*sh))*Cache[self.scrollV].current)

        else
            if Cache[self.scrollV].isVisible then
                Cache[self.scrollV].isVisible = false
            end
        end
            

        self.rendertarget:setAsTarget(true)
        dxSetBlendMode( 'modulate_add' )

            dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground)


            for i, v in ipairs(self.childs) do
                if isElement(v) then

                    Cache[v].offX = offX
                    Cache[v].offY = offY
                    Render[v.type](v, element, offX, offY)
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