function dxTabPanel( x, y, w, h, parent, rounded, vertical, width, colorback, colortext, colorselected)
	
	local self, element = createElement( 'dxTabPanel', parent, sourceResource )
	if self then
		 
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.parent = parent
        self.rounded = rounded and 10 or false

        local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorback or back.tabbackground
		self.colortext = colortext or back.tabtext
		self.colorselected = colorselected or front.tabselected

        self.font = Files['font']['Basic-Regular'][10]
        self.font2 = Files['font']['letterbold'][10]
        self.fontH = dxGetFontHeight( 1, self.font )
        --
        self.vertical = vertical
        self.columnWidth = width or 0
        self.columnLineVisible = true

        --
        self.selected = nil

        if self.parent then
            self.offsetX = self.x - Cache[self.parent].x
            self.offsetY = self.y - Cache[self.parent].y
        end

        if tonumber(self.rounded) and not width then
            local rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground, border,  border and self.colorborder or false)
            self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
        else
            self.update = true
        end
        --Timer(function() self.update = true end, 1200, 1)

        return element
	end
end



function dxAddTab(parent, name, section, color, parentsection)
    if Cache[parent].type == 'dxTabPanel' then

        local self, element = createElement( 'dxTab', parent, sourceResource )
        if self then

            self.x = Cache[parent].x
            self.y = Cache[parent].y
            self.w = Cache[parent].w
            self.h = Cache[parent].h

            self.text = name
            self.section = section
            self.color = color or -1
            self.parentsection = parentsection

            return element
        end
    end
end

function dxTabPanelSetSelected(element, tab)
    local self = Cache[element]
    if self then
        if self.type == 'dxTabPanel' then
            self.selected = tab
        end
    end
end

function dxTabPanelGetSelected(element)
    local self = Cache[element]
    if self then
        if self.type == 'dxTabPanel' then
            return self.selected
        end
    end
end
