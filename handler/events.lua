Events = {'onClick', 'onClose', 'onScrollChange'}

for _, event in ipairs(Events) do
    addEvent(event)
end

addEventHandler( "onClientRender", getRootElement(),
	function()
        if not CLIENT_INIT then
            return
        end
		-- dxDrawText(inspect(Cache), 0, 0)
		for element, v in pairs(Cache) do
			if isElement( element ) then
				if not v.parent then
					Render[v.type](element)
				end
			end
		end
	end
, false, 'low-999')


addEventHandler( "onClientCharacter", getRootElement(),
    function(c)
        if isElement(onBox) then

            local self = Cache[onBox]
            if self then

                if not self.isVisible then
                    return
                end

                writeInBox(onBox, c)
            end

        end
    end,
true)

addEventHandler( "onClientKey", getRootElement(),
    function(key, pressed)
        if key == 'backspace' then
            if pressed then
                deleteTextInBox()
            else
                if timerDelete and timerDelete:isValid() then
                    timerDelete:destroy()
                end
            end
        end
    end
, true, 'low-1000')


addEventHandler( "onClientRestore", getRootElement(),
    function()
        CLIENT_RESTORE = true
        Timer(function() CLIENT_RESTORE = nil end, 100, 1)
    end
)

addEventHandler( "onClientResourceStart", resourceRoot,
    function()
        CLIENT_INIT = true
        CLIENT_RESTORE = true
        Timer(function() CLIENT_RESTORE = nil end, 1000, 1)
    end
, true, 'low-1000')

addEventHandler('onClientElementDestroy', root, 
    function() 
        if Cache[source] then 
            dxDelete(source)
        end 
    end
, true, 'low')

addEventHandler('onClientResourceStop', root, 
    function(res)
        local element = table.find(Cache, 'resource', res)
        if isElement(element) then 
            dxDelete(element)
        end 
    end
, true, 'normal')



