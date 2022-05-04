_createElement = createElement
function createElement(type, parent, resource)

    local element = _createElement(type)
    if isElement( element ) then

        Cache[element] = {}
        Cache[element].type = type
        Cache[element].isVisible = true
        Cache[element].isDisabled = false
        Cache[element].isMoved = true

        if ElementTypeChildrenAvailable[type] then
            Cache[element].childs = {}
        end

        if isElement( parent ) then

            local parentCache = Cache[parent]
            if parentCache then

                if parentCache.childs then

                    Cache[element].parent = parent
                    table.insert(parentCache.childs, element)

                end

            end

        end

        addEventHandler('onClientElementDestroy', element, function() if Cache[source] then destroyElement(source, true) end end)
        return Cache[element], element
    end
end

_destroyElement = destroyElement
function destroyElement(element, bool)
    local array = Cache[element]
    if array then

        if array.childs then

            for i, element in pairs(array.childs) do

                if Cache[element] then
                    Cache[element] = nil
                end

                table.remove(array.childs, i)
                --if bool then
                    _destroyElement(element)
                --end

            end

        end

        Cache[element] = nil
        if not bool then
            _destroyElement(element)
        end

    end
end


function dxSet(element, key, value)
    local self = Cache[element]
    if self then

        local elementType = element.type
        local warn

        if elementType == 'dxCheckBox' then

            if key == 'model' then

                dxCheckBoxSetStyle(element, value)
                
            else
                self[key] = value
            end

        elseif elementType == 'dxEdit' then

            if key == 'text' then

                dxSetText(element, value)

            else
                self[key] = value
            end

        else
        
            self[key] = value
        
        end

        return true
    end
end

function dxGet(element, key)
    return Cache[element] and Cache[element][key]
end

function dxSetText(element, text)
    local self = Cache[element]
    if self then
        
        local text = tostring(text)
        self.text = ''

        if self.type == 'dxEdit' then
            self.caretA = 0
            self.caretB = 0
            self.caretC = 0

            if #text > 0 then
                for i = 1, #text do
                    writeInBox(element, text:sub(i,i))
                end
            end
        else
            self.text = text
        end

        self.update = true
        return true
    end
    return false
end

function dxSetTitle(element, title)
    local self = Cache[element]
    if self then
        if self.title then  
            self.title = tostirng(title)
        end
        return true
    end
    return false
end

function dxSetVisible(element, bool)
    local self = Cache[element]
    if self then    
        self.isVisible = bool
        return true
    end
    return false
end

function dxSetEnabled(element, bool, miliseconds)
    local self = Cache[element]
    if self then    
        self.isDisabled = bool

        if tonumber(miliseconds) then
            Timer(function() self.isDisabled = not self.isDisabled end, miliseconds, 1)
        end

        return true
    end
    return false
end
