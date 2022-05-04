function dxScroll(x, y, wh, vertical, parent, rounded)

	local self, element = createElement('dxScroll', parent, sourceResource)
	if self then

		self.x = x
		self.y = y

		if vertical then
			self.pos = y + dxGetFontHeight( 1, Files['font']['Basic-Regular.ttf'][10] )
			self.w = 17*sw
			self.h = wh
		else
			self.pos = x + dxGetTextWidth( "▲", 1, Files['font']['Basic-Regular.ttf'][10] )*2
			self.w = wh
			self.h = 17*sh
		end

		self.vertical = vertical
		self.rounded = rounded and 4 or false
		--
		self.colorbackground = tocolor(25, 25, 35, 255)
		self.colorboton = tocolor(120, 95, 205, 255)
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
        	self.svg = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground, border,  border and self.colorbackground or false)
        	setTimer(function() self.update = true end, 100, 1)
        else
        	self.update = true
        end
  	
        return element

	end

end

