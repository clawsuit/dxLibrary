Events = {'onClick', 'onClose', 'onScrollChange', }

for _, event in ipairs(Events) do
    addEvent(event)
end

local isWindowActive

addEventHandler( "onClientRender", getRootElement(),
	function()
        if not CLIENT_INIT then
            return
        end
	    --dxDrawText(inspect(Cache), 0, 0)
		for element, v in pairs(Cache) do
			if isElement( element ) then
				if not v.parent then
					Render[v.type](element)
				end
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

                    if self.caretC >= 1 then

                        self.text = self.text:sub(1, self.caretC-1) .. self.text:sub(self.caretC+1)

                        if self.caretC == 1 then

                            if self.caretA > 0 then

                                if self.text:len() == 0 then
                                    self.caretA = 0
                                else
                                    self.caretA = math.max(0, self.caretA - 1)
                                end

                            else
                                self.caretC = math.max(0, self.caretC - 1)
                            end

                        else
                            self.caretC = math.max(0, self.caretC - 1)
                        end                      

                        local tw = 0
                        if self.masked then
                            tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ):gsub('.', '*'), 1, self.font )
                        else
                            tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
                        end

                        while not (tw >= (self.w-10)) and self.caretA > 0 do
                            self.caretA = self.caretA - 1
                            if self.masked then
                                tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ):gsub('.', '*'), 1, self.font )
                            else
                                tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
                            end
                        end

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
, false)


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

addEventHandler('onClientElementDestroy', root, 
    function() 
        if Cache[source] then
            if onBox == source then
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
                if onBox == element then
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



