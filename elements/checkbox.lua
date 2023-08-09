function dxCheckBox( x, y, text, parent, rounded)
	
	local self, element = createElement( 'dxCheckBox', parent, sourceResource )
	if self then
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(16*sw)
		self.h = math.round(16*sw)
		self.text = text or ''
		self.parent = parent

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = back.checkBoxbackground
		self.colorborder = front.checkBoxborder
		self.colorchecker = front.checkBoxchecker
		self.colortext = back.checkBoxtext
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.font = Files['font']['Basic-Regular'][10]
        self.fontH = dxGetFontHeight( 1, self.font )
        --
        self.style = 2
        self.state = false

        if rounded then
  			local rawSvgData = ([[
            <svg width="%dpx" height="%dpx">
              <circle cx="%d" cy="%d" r="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px"/>
            </svg>]]):format(self.w+2, self.h+2, (self.w/2)+1, (self.w/2)+1, self.w/2)

            self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
  		else

  			local rawSvgData = ([[
            <svg width="%d" height="%d">
			  	<rect x='0.5' y='0.5' width="%d" height="%d" fill="]]..colorToHex(self.colorbackground)..[[" stroke="]]..colorToHex(self.colorborder)..[[" stroke-width="2px" /> 
				<text x="0" y="2" fill="red">I love SVG!</text>
			</svg>
            ]]):format(self.w, self.h, self.w-1, self.h-1)

            self.svg = svgCreate(self.w+2, self.h+2, rawSvgData, function() self.update = true end)
  			--self.update = true
  		end

        return element
	
	end

end

function dxCheckBoxSetState(element, bool)
	local self = Cache[element]
	if self then	
		self.state = bool
		self.update = true
		return true
	end
	return false
end

function dxCheckBoxGetState(element, bool)
	local self = Cache[element]
	if self then	
		return self.state
	end
	return false
end
