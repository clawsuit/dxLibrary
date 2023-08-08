radioButtonSelected = {}

function dxRadioButton( x, y, text, parent)
	
	local self, element = createElement( 'dxRadioButton', parent, sourceResource )
	if self then
		 
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(16*sw)
		self.h = math.round(16*sw)
        self.text = text or ''
		self.parent = parent
        self.rounded = self.w/2--rounded and 10 or false

        local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

        self.colortext = back.radiotext
		self.colorbackground = back.radiobackground
        self.colorselected = front.radioselected
		self.colorborder = front.radioborder

        self.font = Files['font']['Basic-Regular'][10]
        self.fontH = dxGetFontHeight( 1, self.font )
        --

        if self.parent then
            self.offsetX = self.x - Cache[self.parent].x
            self.offsetY = self.y - Cache[self.parent].y
        end

        if isElement(self.parent) then
            if not isElement(radioButtonSelected[self.parent]) then
                radioButtonSelected[self.parent] = element
            end
        else
            if not isElement(radioButtonSelected.noParent) then
                radioButtonSelected.noParent = element
            end
        end

        if tonumber(self.rounded) then
            local rawSvgData = ([[
            <svg width="%dpx" height="%dpx">
              <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px"/>
            </svg>]]):format(self.w+2, self.h+2, self.rounded+1,self.rounded+1,self.rounded)

            self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)

            local rawSvgData = ([[
            <svg width="%dpx" height="%dpx">
              <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px"/>
              <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorselected)..[["/>
            </svg>]]):format(self.w+2, self.h+2, self.rounded+1, self.rounded+1, self.rounded, self.rounded+1, self.rounded+1, self.rounded/2)

            self.svg2 = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
        else
            self.update = true
        end
        return element
	end
end

function dxRadioButtonSetSelected(element)
    local self = Cache[element]
    if self then
        if isElement(self.parent) then
            radioButtonSelected[self.parent] = element
        else
            radioButtonSelected.noParent = element
        end
    end
end

function dxRadioButtonGetSelected(element)
    local self = Cache[element]
    if self then
        if isElement(self.parent) then
            if radioButtonSelected[self.parent] == element then
                return true
            end
        else
            if radioButtonSelected.noParent == element then
                return true
            end
        end
        return false
    end
end


