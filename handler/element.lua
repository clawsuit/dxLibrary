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
                    Cache[element].rootParent = dxGetRootParent(parent) or parent

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


function dxSetPosition(element, x, y)
    local self = Cache[element]
    if self then

        self.x = x
        self.y = y

        if self.parent then
            self.offsetX = self.x - Cache[self.parent].x
            self.offsetY = self.y - Cache[self.parent].y
        end

        return true
    end
    return false
end

function dxGetPosition(element)
    local self = Cache[element]
    if self then
        return self.x, self.y
    end
    return false
end

function dxSetSize(element, w, h)
    local self = Cache[element]
    if self then

        self.w = w
        self.h = h

        return true
    end
    return false
end

function dxGetSize(element)
    local self = Cache[element]
    if self then
        return self.w, self.h
    end
    return false
end

function dxGetRootParent(element, sub)
    local self = Cache[element]
    if self then
        if self.parent then
            if Cache[self.parent].parent then
                return dxGetRootParent(self.parent, true)
            else
                return self.parent
            end
        else
            if sub then
                return element 
            end
        end
    end
    return false
end

function dxSetColorBackground(element, r, g, b, a)
    local self = Cache[element]
    if self then
        self.colorbackground = tocolor(r, g, b, a)
        self.update = true
        return true
    end
    return false
end
 
function dxSetColorText(element, r, g, b, a)
    local self = Cache[element]
    if self then
        self.colortext = tocolor(r, g, b, a)
        self.update = true
        return true
    end
    return false
end

function dxSetColorSelected(element, r, g, b, a)
    local self = Cache[element]
    if self then
        if self.colorselected then
            self.colorselected = tocolor(r, g, b, a)
            self.update = true
            return true
        end
    end
    return false
end