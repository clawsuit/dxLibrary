function dxSetTheme(back, front)
    dxLibraryThemeBackSelected = back or 1
    dxLibraryThemeFrontSelected = front or 1
end

_createElement = createElement
function createElement(type, parent, resource)

    local element = _createElement(type)
    if isElement( element ) then

        Cache[element] = {}
        Cache[element].element = element
        Cache[element].type = type
        Cache[element].isVisible = true
        Cache[element].isDisabled = false
        Cache[element].isMoved = true
        Cache[element].resource = resource
        Cache[element].postgui = true
        Cache[element].alpha = 255

        table.insert(Order, element)

        if dxElements.parentAvailable[type] then
            Cache[element].childs = {}
        end

        if isElement( parent ) then

            local parentCache = Cache[parent]
            if parentCache then

                if not (parentCache.type == 'dxTab' and type == 'dxTab') then
                    if (parentCache.type == 'dxTabPanel' and type == 'dxTab') or parentCache.type ~= 'dxTabPanel' then

                        if parentCache.childs then

                            Cache[element].parent = parent
                            Cache[element].rootParent = dxGetRootParent(parent) or parent
                            table.insert(parentCache.childs, element)

                        end
                    end
                end
            end
        end

        return Cache[element], element
    end
end

function dxIsElementParent(element)
    return Cache[element] and dxElements.parentAvailable[Cache[element].type]
end

function dxDelete(element, check)
    local self = Cache[element]
    if self then

        if onBox == element or onBoxBackup == element then
            onBox = nil
            onBoxBackup = nil
            guiSetInputEnabled(false)
        end

        if self.type == 'dxMemo' then
            memoCreated[tostring(element)] = nil
        end

        table.removeValue(Order, element)
        self.isVisible = nil

        if self.childs then
            for i, child in pairs(self.childs) do
                dxDelete(child, true)
            end
            self.childs = {}
        end

        if isElement(self.parent) and not check then

            local selfParent = Cache[self.parent]
            if selfParent then

                for i, child in pairs(selfParent.childs) do
                    if child == element then
                        table.remove(selfParent.childs, i)
                        break
                    end
                end
            end

            self.parent = nil
        end

        for _, k in pairs({'svg', 'svg2', 'rendertarget', 'rendertarget2', 'texture', 'shader', 'textureMask'}) do
            if isElement(self[k]) then
                self[k]:destroy()
            end
        end

        if isElement(self.scrollV) then
            dxDelete(self.scrollV)
        end

        if isElement(self.scrollH) then
            dxDelete(self.scrollH)
        end

        Cache[element] = nil
        if isElement( element ) then
            element:destroy()
        end

    end
end

function dxSetPostGui(element, bool)
    local self = Cache[element]
    if self then
        self.postgui = bool
    end
end

function dxSetToFront(element)
	local self = Cache[ element ]
	if self then
		table.removeValue(Order, element)
        table.insert(Order, element)
        --
        if self.childs then
            for i, child in pairs(self.childs) do
                table.removeValue(Order, child)
                table.insert(Order, child)
            end
        end
	end
end

function dxSetProperty(element, key, value)
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
        elseif key:find('color') or key == 'border' then

            if elementType == 'dxMemo' then

                if key == 'colorbackground' then
                    cefSetStyleProperty(element, 'background', 'rgba('..table.concat({colorToRgba(value)}, ', ')..')')
                elseif key == 'colortext' then
                    cefSetStyleProperty(element, 'color', 'rgba('..table.concat({colorToRgba(value)}, ', ')..')')
                end

            else
                self[key] = value
                dxCreateRoundedSVG(element)
            end

        elseif elementType == 'dxMemo' and key == 'title' then

            cefSetProperty(element, 'placeholder', value)
            self[key] = value

        else
            self[key] = value
        end

        if key == 'parent' then
            if isElement(self.parent) then
                self.offsetX = self.x - Cache[self.parent].x
                self.offsetY = self.y - Cache[self.parent].y
            else
                self.offsetX = nil
                self.offsetY = nil
            end
        end

        self.update = true
        return true
    end
end

function dxGetProperty(element, key)
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
        elseif self.type == 'dxMemo' then
           -- self.webBrowser:executeJavascript("cefSetProperty('"..toJSON({key=tostring(element), property='value', value = text}).."')")
           self.text = text

            if self.readonly then
                self.webBrowser:executeJavascript(([[
                document.getElementById('%s').readonly = "false";
                ]]):format(tostring(element)) )
            end

            self.webBrowser:executeJavascript(([[
                document.getElementById('%s').value = `%s`;
            ]]):format(tostring(element), tostring(text)))

            if self.readonly then
                self.webBrowser:executeJavascript(([[
                document.getElementById('%s').readonly = "true";
                ]]):format(tostring(element)) )
            end

            -- cefSetPropertyMulti(element, {
            --     readonly = 'false',
            --     innerHTML = tostring(text),
            --     readonly = 'true'
            -- })
 
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

function dxSetDisabled(element, bool, miliseconds)
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

function dxSetParent(element, parent)
    local self = Cache[element]
    if self then
        if isElement( parent ) then
            if dxIsElementParent(parent) then

                self.parent = parent
                self.offsetX = self.x - Cache[parent].x
                self.offsetY = self.y - Cache[parent].y
                
                if isElement( parent ) then

                    local parentCache = Cache[parent]
                    if parentCache then

                        if not (parentCache.type == 'dxTab' and type == 'dxTab') then
                            if (parentCache.type == 'dxTabPanel' and type == 'dxTab') or parentCache.type ~= 'dxTabPanel' then

                                if parentCache.childs then

                                    Cache[element].parent = parent
                                    Cache[element].rootParent = dxGetRootParent(parent) or parent

                                    table.insert(parentCache.childs, element)

                                end
                            end
                        end
                    end
                end
            end
        else
            self.parent = nil
            self.offsetX = nil
            self.offsetY = nil
        end
    end
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

        if not (self.type == 'dxCheckBox' or self.type == 'dxRadioButton') then

            if w or h then

                if w then 
                    self.w = math.round(w)
                end
                if h then
                    self.h = math.round(h)
                end

                if self.type == 'dxSwitchButton' then
                    self.w = math.min(self.w, math.round(53*sw))
                    self.h = math.min(self.h, math.round(23*sh))
                elseif self.type == 'dxMemo' and self.ready then

                    resizeBrowser(self.webBrowser, self.w, self.h )
                    cefSetStylePropertyMulti(element,{
                        width = tostring(self.w)..'px',
                        height = tostring(self.h)..'px'
                    })

                end

                if self.type ~= 'dxScrollPane' then
                    if isElement(self.renderTarget) then
                        self.rendertarget:destroy()
                    end
                    if isElement(self.renderTarget2) then
                        self.rendertarget2:destroy()
                    end
                    --self.rendertarget = DxRenderTarget(self.w, self.h, true)
                end

                if tonumber(self.rounded) then
                    dxCreateRoundedSVG(element)

                else

                    if self.type == 'dxScrollPane' then

                        local new = DxRenderTarget(self.w, self.h, true)
                        local old = self.rendertarget

                        self.rendertarget = new
                        if isElement(old) then
                            old:destroy()
                        end
                       
                    end
                end

                self.update = true
                return true

            end
        end
    end
    return false
end

function dxSetRounded(element, rounded)
    local self = Cache[element]
    if self then

        if not dxElements.defaultRounded[self.type] then return false end

        self.rounded = rounded

        if self.type == 'dxMemo' then

            local round = self.rounded or 0
            cefSetStyleProperty(element, 'border-radius', tostring(round)..'px')

            return
        end
        
        if isElement(self.svg) then
            self.svg:destroy()
            self.svg = nil
        end

        if isElement(self.svg2) then
            self.svg2:destroy()
            self.svg2 = nil
        end

        -- if isElement(self.rendertarget2) then
        --     self.rendertarget2:destroy()
        -- end

        -- if isElement(self.rendertarget) then
        --     self.rendertarget:destroy()
        -- end

        if not rounded then
            self.update = true
            return 
        end

        if rounded == true then
            self.rounded = dxElements.defaultRounded[self.type]
        elseif tonumber(rounded) then
            self.rounded = tonumber(rounded)
        end
        
        if self.rounded then
            dxCreateRoundedSVG(element)
        end
    end
end

function dxCreateRoundedSVG(element)
    local self = Cache[element]
    if self then

        if self.type == 'dxMemo' then return end;

        if self.rounded then
            local color = self.colorbackground

            if self.type == 'dxButton' or self.type == 'dxProgressBar' then
                color = -1
            end

            if isElement(self.svg) then
                self.svg:destroy()
                self.svg = nil
            end
    
            if isElement(self.svg2) then
                self.svg2:destroy()
                self.svg2 = nil
            end
    
            -- if isElement(self.rendertarget2) then
            --     self.rendertarget2:destroy()
            -- end
    
            -- if isElement(self.rendertarget) then
            --     self.rendertarget:destroy()
            -- end

            local rawSvgData

            if self.type == 'dxCheckBox' then
                rawSvgData = ([[
                <svg width="%dpx" height="%dpx">
                <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px"/>
                </svg>]]):format(self.w+2, self.h+2, (self.w/2)+1, (self.w/2)+1, self.w/2)

            elseif self.type == 'dxEdit' then

                rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground)
                --
                local rawSvgData2 = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground, 2, self.colorselected)
  			    self.svg2 = svgCreate(self.w, self.h, rawSvgData2, function() self.update = true end)

            elseif self.type == 'dxRadioButton' then

                rawSvgData = ([[
                <svg width="%dpx" height="%dpx">
                <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px"/>
                </svg>]]):format(self.w+2, self.h+2, self.rounded+1,self.rounded+1,self.rounded)

                local rawSvgData2 = ([[
                <svg width="%dpx" height="%dpx">
                <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px"/>
                <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorselected)..[["/>
                </svg>]]):format(self.w+2, self.h+2, self.rounded+1, self.rounded+1, self.rounded, self.rounded+1, self.rounded+1, self.rounded/2)

                self.svg2 = svgCreate(self.w, self.h, rawSvgData2, function() self.update = true end)

            elseif self.type == 'dxTabPanel' and (not self.columnWidth or self.columnWidth == 0) then
                rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground)

            elseif self.type == 'dxScroll' then
                rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground)

                if self.vertical then
                    local rawSvgData = svgCreateRoundedRectangle(self.w, self.h/3, self.rounded, self.colorboton)
                    self.svg2 = svgCreate(self.w, self.h/3, rawSvgData, function() self.update = true end)
                else
                    local rawSvgData = svgCreateRoundedRectangle(self.w/3, self.h, self.rounded, self.colorboton)
                    self.svg2 = svgCreate(self.w/3, self.h, rawSvgData, function() self.update = true end)
                end
            else
                rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, color, self.border,  self.border and self.colorborder or false)
            end

            if rawSvgData then
                self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
            end
        else
            if self.type == 'dxCheckBox' then
                local rawSvgData = ([[
                <svg width="%d" height="%d">
                    <rect x='0.5' y='0.5' width="%d" height="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px" /> 
                    <text x="0" y="2" fill="red">I love SVG!</text>
                </svg>
                ]]):format(self.w, self.h, self.w-1, self.h-1)

                self.svg = svgCreate(self.w+2, self.h+2, rawSvgData, function() self.update = true end)
            end

            self.update = true
        end

    end
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
            return dxGetRootParent(self.parent, true)
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

        if not self.svg then
            self.update = true
        else
            if self.type ~= 'dxButton' then

                local svgXML = svgGetDocumentXML(self.svg)
                local rect = xmlNodeGetChildren(svgXML)[1]
                xmlNodeSetAttribute(rect, "fill", ""..colorToHex(self.colorbackground))
                svgSetDocumentXML(self.svg, svgXML)


                if self.svg2 then
                    local svgXML = svgGetDocumentXML(self.svg2)
                    local rect = xmlNodeGetChildren(svgXML)[1]
                    xmlNodeSetAttribute(rect, "fill", ""..colorToHex(self.colorbackground))
                    svgSetDocumentXML(self.svg2, svgXML)
                end
                
            end
        end

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
            

            if self.svg2 then

                local svgXML = svgGetDocumentXML(self.svg2)
                local rect = xmlNodeGetChildren(svgXML)[1]
                xmlNodeSetAttribute(rect, "stroke", ""..colorToHex(self.colorselected))
                svgSetDocumentXML(self.svg2, svgXML)
                
            else
                self.update = true
            end
 
            return true
        end
    end
    return false
end

function dxSetColorBorder(element, r, g, b, a)
    local self = Cache[element]
    if self then
        if self.colorborder then
            self.colorborder = tocolor(r, g, b, a)
            
            if not self.svg then
                self.update = true
            else
                local svgXML = svgGetDocumentXML(self.svg)
                local rect = xmlNodeGetChildren(svgXML)[1]
                xmlNodeSetAttribute(rect, "stroke", ""..colorToHex(self.colorborder))
                svgSetDocumentXML(self.svg, svgXML)
            end

            return true
        end
    end
    return false
end

function dxFont(path, size, bold)
    if fileExists( path ) then
        if tonumber(size) then

            Files['font'] = Files['font'] or {}
            resourceFonts[(sourceResource or resource)] = resourceFonts[(sourceResource or resource)] or {}
            --
            local last = getLastLetterPos(path)
            local name = path:sub(last, path:find('%.', last)-1)
            --
            Files['font'][name] = Files['font'][name] or {}
            --
            if not isElement(Files['font'][name][tonumber(size)]) then
                Files['font'][name][tonumber(size)] = DxFont(path, tonumber(size)*sw, bold )
                table.insert(resourceFonts[(sourceResource or resource)], Files['font'][name][tonumber(size)])
            end

            return true
        end
    end
    return false
end

function dxSetFont(element, name, size)
    local self = Cache[element]
    if self then
        if Files['font'][name] then
            if tonumber(size) then
                if Files['font'][name][tonumber(size)] then

                    self.font = Files['font'][name][tonumber(size)]
                    self.fontH = dxGetFontHeight( 1, self.font )

                    if self.type == 'dxEdit' then
                        if isElement( self.rendertarget ) then
                            self.rendertarget:destroy()
                        end
                        if isElement( self.rendertarget2 ) then
                            self.rendertarget2:destroy()
                        end
                    elseif self.type == 'dxScroll' then
                    end

                    self.update = true
                    return true
                end
            end
        end
    end
    return false
end

function dxGetText(element)
    local self = Cache[element]
    if self then
        return self.text
    end
    return false
end

function dxGetTitle(element)
    local self = Cache[element]
    if self then
        return self.title
    end
    return false
end

function dxSetTitle(element, title)
    local self = Cache[element]
    if self then
        if self.title then
            self.title = title
        end
    end
    return false
end

local resource = getThisResource(  )
local resourceName = resource.name
function dxGetLibrary()
    local string = [[]]
    for i, func in ipairs(getResourceExportedFunctions( resource )) do
        string = string..'\n'..func..' = function(...) return call ( getResourceFromName ( "'..resourceName..'" ), "'..func..'", ... ) end'
    end
    return string   
end 

function dxDuplicateElement(element, includeChilds, parent)
    local self = Cache[element]
    if self then
        
        local new = _createElement(self.type)
        Cache[new] = table.deepcopy(self)
        
        if isElement(parent) then
            Cache[new].parent = parent
            Cache[new].offsetX = Cache[new].x - Cache[parent].x
            Cache[new].offsetY = Cache[new].y - Cache[parent].y
        end

        if isElement(Cache[new].parent) then
            table.insert(Cache[ Cache[new].parent ].childs, new)
        end

        if self.type == 'dxMemo' then
            memoCreated[tostring(new)] = new
        end

        for _, k in ipairs({'svg', 'svg2', 'rendertarget', 'rendertarget2', 'texture', 'shader', 'textureMask'}) do
            --if isElement(Cache[new][k]) then
                Cache[new][k] = nil
            --end
        end 

        if self.type == 'dxImage' then
            self.texture = isElement(self.path) and self.path or DxTexture(self.path, self.colorformat, self.mipmaps, self.textureType )
        end

        if tonumber(Cache[new].rounded) then
            dxCreateRoundedSVG(new)
        end

        if includeChilds then
            if self.childs then

                Cache[new].childs = {}
                for i, v in ipairs(self.childs) do
                    table.insert(Cache[new].childs, dxDuplicateElement(v, includeChilds), new)
                end

            end
        else
            if self.childs then
                Cache[new].childs = {}
            else
                Cache[new].childs = nil
            end
        end
        
        table.insert(Order, new)
        setTimer(
            function(new)
                Cache[new].update = true
            end,
        500, 1, new) 
        return new
    end
end


function cefSetProperty(element, property, value)
    local self = Cache[element]
    if self then
        self.webBrowser:executeJavascript(([[
            document.getElementById('%s')['%s'] = `%s`;
        ]]):format(tostring(element), tostring(property), tostring(value)))
    end
end

function cefSetPropertyMulti(element, propertys)
    local self = Cache[element]
    if self then

        local element = tostring(element)
        local code = ''
        for property, value in pairs(propertys) do
            if code:len() == 0 then
                code = ('document.getElementById("%s")["%s"] = `%s`;'):format(element, tostring(property), tostring(value))
            else
                code = code..'\n'..('document.getElementById("%s")["%s"] = `%s`;'):format(element, tostring(property), tostring(value))
            end
        end

        self.webBrowser:executeJavascript(code)
    end
end

function cefSetStyleProperty(element, property, value)
    local self = Cache[element]
    if self then
        self.webBrowser:executeJavascript(([[
            document.getElementById('%s').style['%s'] = `%s`;
        ]]):format(tostring(element), tostring(property), tostring(value)))
    end
end

function cefSetStylePropertyMulti(element, propertys)
    local self = Cache[element]
    if self then

        local element = tostring(element)
        local code = ''
        for property, value in pairs(propertys) do
            if code:len() == 0 then
                code = ('document.getElementById("%s").style["%s"] = `%s`;'):format(element, tostring(property), tostring(value))
            else
                code = code..'\n'..('document.getElementById("%s").style["%s"] = `%s`;'):format(element, tostring(property), tostring(value))
            end
        end

        self.webBrowser:executeJavascript(code)
    end
end

local preDefined = [[
	local element, progress = ...
	local self = Cache[element]
]]

--[[
	extras = {
		cancelCloseButton = true,
		postFun = function,

		args...
	}
]]

function dxAddAnimation(element, easing, time, string, reverse, extras)
	local self = Cache[element]
	if self then

		local fn, err = loadstring(preDefined..string)
		if not fn then return print(err) end;

		local anim = {
			fun = fn,
			easing = easing or 'Linear',
			time = tonumber(time),
			tick = getTickCount(),
			reverse = reverse,
			postFun = postFun,
			
		}

		if type(extras) == 'table' then
			for k, v in pairs(extras) do
				anim[k] = v
				if k == 'cancelCloseButton' then
					if v then
						anim.tick = nil
					end
				end
			end
		end

		setTimer(
			function()
				self.anim = anim
			end,
		50,1)
	end
end