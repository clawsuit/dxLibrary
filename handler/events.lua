Events = {'onClick', 'onDoubleClick', 'onClose', 'onScrollChange', 'onSwithButtonChange', 'onEditChange'}

for _, event in ipairs(Events) do
    addEvent(event)
end

local isWindowActive


function renderizarElementos()
    if not CLIENT_INIT then
        return
    end
    --dxDrawText(inspect(Cache), 0, 0)
    for _, element in ipairs(Order) do
        if isElement( element ) then
            local v = Cache[element]
            
            if not v.parent then--or v.type == 'dxTabPanel' then
                
                Render[v.type](element)
            end
        else
            table.remove(Order, _)
        end
    end 

    if isMTAWindowActive(  ) then
        if not isWindowActive then
            isWindowActive =  true
        end
    else if isWindowActive then
            isWindowActive = false
            CLIENT_RESTORE = true
            Timer(function() CLIENT_RESTORE = nil end, 1000, 1)
        end
    end

    if getKeyState( 'backspace' ) then

        if not tickDelete or getTickCount(  ) - tickDelete >= 120 then

            local self = Cache[onBox]
            if self then

                if not self.isVisible then
                    return
                end

                if self.text:len() == 0 then
                    return
                end

                if self.caretC > 0 then

                    self.text = self.text:sub(1, self.caretC-1) .. self.text:sub(self.caretC+1)

                    if self.caretC == 1 then

                        if self.caretA > 0 then

                            if self.text:len() == 0 then
                                self.caretA = 0
                            else
                                self.caretA = math.max(0, self.caretA - 1)
                            end

                        else
                            self.caretC = self.caretC - 1
                        end

                    else
                        self.caretC = self.caretC - 1
                    end

                    triggerEvent('onEditChange', onBox, self.text)

                    local tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
                    while tw >= (self.w-10) and self.caretB > 0 do
                        self.caretB = self.caretB - 1
                        tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
                    end

                end
                
            end

            tickDelete = getTickCount(  )

        end
    else
        if tickDelete then
            tickDelete = nil
        end
    end
end
addEventHandler( "onClientRender", getRootElement(), renderizarElementos, false, 'high')



addEventHandler( "onClientCharacter", getRootElement(),
    function(c)
        --print(c, "hola")
        if isElement(onBox) then

            local self = Cache[onBox]
            if self then

                if not self.isVisible then
                    return
                end
                local c = (c == 'ñ' and 'n') or (c == 'Ñ' and "N") or c

                writeInBox(onBox, c)
            end

        end
    end
)

addEventHandler( "onClientClick", getRootElement(),
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
        if button == 'left' and state == 'up' then

            for i = #Order, 1, -1 do
                local element = Order[i]
                local self = Cache[element]
                --
                if element and self then
                    if not self.isDisabled then

                        local x, y, x2, y2 = self.x, self.y, self.x, self.y
                        if isElement(self.parent) then
                            x, y = self.offsetX, self.offsetY
                            --
                            if x2 ~= (Cache[self.parent].x + x) or y2 ~= (Cache[self.parent].y + y) then
                                x2, y2 = Cache[self.parent].x + x, Cache[self.parent].y + y
                            end
                        end

                        local x2, y2 = x2 + (self.offX or 0), y2 + (self.offY or 0)
                        

                        if self.type == 'dxGridList' then
                            
                            local scrollH_current = Cache[self.scrollH].current
		                    local scrollV_current = Cache[self.scrollV].current

                            local mw = (Cache[self.scrollV].isVisible and not Cache[self.scrollH].forcedVisibleFalse) and 17*sh or 0
                            local mh = (Cache[self.scrollH].isVisible and not Cache[self.scrollH].forcedVisibleFalse) and self.fontH*2 or self.fontH

                            if isCursorOver(x2, y2+self.fontH, self.w-mw, self.h-mh) then
                                self.selected = (self.itemOver or -1)

                                triggerEvent('onClick', element)
                                break
                            end

                        elseif self.type == 'dxWindow' then
                            
                            local xw, xh = dxGetTextWidth( "✕", 1, self.font ), self.fontH
                            if isCursorOver(self.x+self.w-xw*2, self.y, xw*2, xh) then

                                triggerEvent('onClose', element)
                                if not wasEventCancelled(  ) then
                                    self.isVisible = false
                                end
                                return 

                            end

                        elseif isCursorOver(x2, y2, self.w, self.h) then

                            if self.type == 'dxCheckBox' or self.type == 'dxSwitchButton' then

                                self.state = not self.state
                                if self.type == 'dxSwitchButton' then

                                    self.tick = getTickCount(  )
                                    self.update = true
                                    
                                end

                            elseif self.type == 'dxEdit' then
                                onBox = element
                                onBoxBackup = element
		 		                guiSetInputEnabled(true)
                            elseif self.type == 'dxRadioButton' then
                                dxRadioButtonSetSelected(element)
                            elseif self.type == 'dxWindow' then
                                dxSetToFront(element)
                            elseif self.type == 'dxMemo' and not self.readonly then
                               self.webBrowser:focus()

                                if isElement(onMemo) then
                                    Cache[onMemo].webBrowser:executeJavascript("cefSetMemoState('"..toJSON({key=tostring(onMemo), type='blur'}).."')")
                                end

                                onMemo = element
                               -- onBoxBackup = element
		 		                guiSetInputEnabled(true)
                                self.webBrowser:executeJavascript("cefSetMemoState('"..toJSON({key=tostring(element), type='focus'}).."')")
                            end

                            triggerEvent('onClick', element)

                            break
                        else
                            if self.type == 'dxEdit' then
                                if onBox == element then
                                    onBox = nil
                                    guiSetInputEnabled(false)
                                end
                            elseif self.type == 'dxMemo' then
                                if onMemo == element then
                                    onMemo = nil
                                    guiSetInputEnabled(false)
                                   self.webBrowser:executeJavascript("cefSetMemoState('"..toJSON({key=tostring(element), type='blur'}).."')")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)

function table.concat2(t)
    local o = ""
    for i, v in ipairs(t) do
        o = o.."'"..tostring(v).."', "
    end
    return o:sub(1,-3)
end


-- addEventHandler( "onClientKey", getRootElement(), ñ
--     function(key, pressed)
--         if key == 'backspace' then
--             if pressed then
--                 deleteTextInBox()
--             else
--                 if timerDelete and timerDelete:isValid() then
--                     timerDelete:destroy()
--                 end
--             end
--         end
--     end
-- , true, 'low-1000')

 
addEventHandler( "onClientRestore", getRootElement(),
    function()
        for element, v in pairs(Cache) do
            if isElement( element ) then
                v.update = true
            end
        end
    end
)

addEventHandler( "onClientResourceStart", resourceRoot,
    function()
        CLIENT_INIT = true
        -- CLIENT_RESTORE = true
        -- Timer(function() CLIENT_RESTORE = nil end, 1000, 1)
        for element, v in pairs(Cache) do
            if isElement( element ) then
                v.update = true
            end
        end
    end
, true, 'low-1000')

addEventHandler('onClientElementDestroy', resourceRoot, 
    function() 
        if Cache[source] then
            if onBox == source or onBoxBackup == source then
                onBox = nil
                guiSetInputEnabled(false)
            end
            dxDelete(source)
        end 
    end
, true, 'low-10')

addEventHandler('onClientResourceStop', root, 
    function(res)
        
        for element,v in pairs(Cache) do
            if v.resource == res then
                if onBox == element or onBoxBackup == source then
                    onBox = nil
                    guiSetInputEnabled(false)
                end
                dxDelete(element)
            end
        end
        
        if resourceFonts[res] then
            for i, font in pairs(resourceFonts[res]) do
                if isElement(font) then
                    font:destroy()
                end
            end
        end
    end
, true, 'low-10')



