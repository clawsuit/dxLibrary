function dxScroll(x, y, wh, vertical, parent, rounded)

	local self, element = createElement('dxScroll', parent, sourceResource)
	if self then

		self.x = math.round(x)
		self.y = math.round(y)

		self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )

		if vertical then
			self.pos = self.y + self.fontH
			self.w = math.round(17*sh)
			self.h = math.round(wh)
		else
			self.pos = self.x + dxGetTextWidth( "▲", 1, self.font )*2
			self.w = math.round(wh)
			self.h = math.round(17*sh)
		end

		self.vertical = vertical
		self.rounded = rounded and 4 or false
		--

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]
        
		self.colorbackground = back.scrollbackground
		self.colorboton = front.scrollboton
		--
		self.cursorY = 0
		self.cursorX = 0
		self.current = 0
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y

        	if not vertical then
        		self.posOff = self.pos - Cache[self.parent].x
        	else
        		self.posOff = self.pos - Cache[self.parent].y
        	end
        end

        if tonumber(self.rounded) then
        	local rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground)
        	self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
        else
        	self.update = true
        end
  	
        return element

	end

end

function dxScrollGetCurrentPosition(element)
	local self = Cache[element]
	if self then
		return self.current
	end
	return false
end

function dxScrollSetColorButton(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colorboton = tocolor(r, g, b, a)
		return  true
	end
	return false
end
