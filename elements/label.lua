function dxLabel( x, y, w, h, text, parent, alignX, alignY, border)
	
	local self, element = createElement( 'dxLabel', parent, sourceResource )
	if self then
		
		self.x = x 
		self.y = y
		self.w = w
		self.h = h
		self.text = text
		self.parent = parent

		self.colortext = tocolor(255, 255, 255, 255)
		self.colorborder = self.colortext
		--
		self.alignX = alignX or 'left'
        self.alignY = alignY or 'top'
        self.border = tonumber(border) or nil
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.update = true
        return element
	
	end
end

