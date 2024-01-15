Events = {'onClick', 'onDoubleClick', 'onClose', 'onScrollChange', 'onSwithButtonChange', 'onEditChange', 'onTabChange'}

for _, event in ipairs(Events) do
    addEvent(event)
end

local isWindowActive


function renderizarElementos()
    if not CLIENT_INIT then
        return
    end

    --print(onMemo)
    if isElement(onMemo) then
        local ele = Cache[onMemo]
        if ele then
            if (not ele.isDisabled) and ele.isVisible and (not isElement(ele.parent) or isParentAllVisible(onMemo) ) and (not isElement(ele.rootParent) or Cache[ele.rootParent].isVisible) and (not isElement(ele.attached) or Cache[ele.attached].isVisible) then
            else
                guiSetInputEnabled(false)
                ele.webBrowser:executeJavascript("cefSetMemoState('"..toJSON({key=tostring(onMemo), type='blur'}).."')")
                onMemo = nil
            end
        end
    end

    if isElement(onBox) then
        local ele = Cache[onBox]
        if ele then
            if (not ele.isDisabled) and ele.isVisible and (not isElement(ele.parent) or isParentAllVisible(onBox)) and (not isElement(ele.rootParent) or Cache[ele.rootParent].isVisible) and (not isElement(ele.attached) or Cache[ele.attached].isVisible) then
            else
                guiSetInputEnabled(false)
                onBox = nil
            end
        end
    end

    --dxDrawText(inspect(Cache), 0, 0)
    for _, element in ipairs(Order) do
        if isElement( element ) then
            local self = Cache[element]

            if self.anim then
                if self.anim.tick then

                    local time = math.min(1,(getTickCount()-self.anim.tick)/self.anim.time)--getEasingValue((getTickCount()-self.anim.tick)/self.anim.time, self.anim.easing)
                    local progress = interpolateBetween(0,0,0,1,0,0, time, self.anim.easing)

                    if self.anim.reverse then progress = 1-progress end
        
                    self.anim.fun(element, progress)
        
                    if progress >= 1 then
                        if self.anim.postFun then
                            self.anim.postFun(element, unpack(self.anim))
                        end

                        if self.type == 'dxWindow' then
                            if self.anim.cancelCloseButton and not self.isVisible then
                                triggerEvent('onClose', element)
                            end 
                        end
        
                        self.anim = nil;
                    end
                end
            end
            
            if not self.parent then--or v.type == 'dxTabPanel' then
                Render[self.type](element)
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

function isParentAllVisible(element)
	local self = Cache[element]
    if self and self.isVisible then

    	if isElement(self.parent) then

    		local parent = Cache[self.parent]
    		if parent then

    			if self.type == 'dxTab' then
    				if parent.type == 'dxTabPanel' and parent.selected == element then

    					return isParentAllVisible(self.parent)

    				end
    			else 
    				return isParentAllVisible(self.parent)
    			end
    		end
    	else

    		return true

    	end

    end
    return false
end

addEventHandler( "onClientClick", getRootElement(),
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
        if button == 'left' then

            for i = #Order, 1, -1 do

                local element = Order[i]
                if isElement(element) then

                    local self = Cache[element]
                    if self then

                    	local tabCheck = isParentAllVisible(element)--isElement(self.parent) and Cache[self.parent].isVisible and (Cache[self.parent].type ~= 'dxTab' or Cache[ Cache[self.parent].parent ].selected == self.parent)

                        if not self.isDisabled and self.isVisible and (not isElement(self.parent) or (Cache[self.parent].isVisible and (tabCheck) )) and (not isElement(self.rootParent) or Cache[self.rootParent].isVisible) and (not isElement(self.attached) or Cache[self.attached].isVisible) then


                            local x, y, x2, y2 = self.x, self.y, self.x, self.y
                            if isElement(self.parent) and self.type ~= 'dxTab' then
                                x, y = self.offsetX, self.offsetY
                                --
                                if x2 ~= (Cache[self.parent].x + x) or y2 ~= (Cache[self.parent].y + y) then
                                    x2, y2 = Cache[self.parent].x + x, Cache[self.parent].y + y
                                end
                            end

                            local x2, y2 = x2 + (self.offX or 0), y2 + (self.offY or 0)
                            
                            if state == 'up' then
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

                                        if not self.anim or not self.anim.cancelCloseButton then
                                        	if self.closebutton then

	                                            triggerEvent('onClose', element)
	                                            if not wasEventCancelled(  ) then
	                                                self.isVisible = false
	                                            end
	                                         
	                                        end
                                        elseif self.anim and not self.tick and self.anim.cancelCloseButton then
                                            self.anim.tick = getTickCount()
                                        end

                                        break
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

                                    elseif self.type == 'dxMemo' then
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
                            else

                                if self.type == 'dxScroll' then
                                    dxElements.click[self.type](element, absoluteX, absoluteY)
                                end
                                
                            end
                        end
                    end
                end
            end
        end
    end
)

addEventHandler( "onClientKey", getRootElement(),
    function(key, press)
        if press and (key == 'mouse_wheel_up' or key == 'mouse_wheel_down') then
            for i = #Order, 1, -1 do

                local element = Order[i]
                if isElement(element) then

                    local self = Cache[element]
                    if self then

                    	local tabCheck = isParentAllVisible(element)
                        if not self.isDisabled and self.isVisible and (not isElement(self.parent) or tabCheck) and (not isElement(self.rootParent) or Cache[self.rootParent].isVisible) and (not isElement(self.attached) or Cache[self.attached].isVisible) then
                            if self.type == 'dxScroll' then

                                local x2, y2 = self.x + (self.offX or 0), self.y + (self.offY or 0)

                                if (isElement(self.attached) and isElement(mouseOnElement) and mouseOnElement == self.attached or not isElement(mouseOnElement)) then
                                    if isElement(self.attached) and isCursorOver(Cache[self.attached].x, Cache[self.attached].y, Cache[self.attached].w, Cache[self.attached].h) or (not isElement(self.attached) and isElement(parent) and isCursorOver(Cache[parent].x, Cache[parent].y, Cache[parent].w, Cache[parent].h)) or isCursorOver(x2, y2, self.w, self.h) then

                                        self.tick = self.tick or getTickCount(  )

                                        local value = self.maxScroll/10
                                        if isElement(self.attached) then
                                            if self.attached:getType() == 'dxGridList' then

                                                value = self.maxScroll/#Cache[self.attached].items

                                            elseif self.attached:getType() == 'dxScrollPane' then

                                                value = self.maxScroll/Cache[self.attached].self.scrollY
                                            end
                                        end

                                        if key == 'mouse_wheel_up' then
                                            self.from = self.from or self.scrollPosition
                                            self.to = self.to or self.scrollPosition
                                            
                                            self.to = math.max(self.to - value, 0)
                                        end
                                        --
                                        if key == 'mouse_wheel_down' then
                                            self.from = self.from or self.scrollPosition
                                            self.to = self.to or self.scrollPosition
                                            
                                            self.to = math.min(self.to + value, self.maxScroll)
                                        end

                                    end
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



