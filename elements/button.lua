function dxButton(x, y, w, h, text, parent, rounded)

	local self, element = createElement('dxButton', parent, sourceResource)
	if self then

		self.x = x
		self.y = y
		self.w = w
		self.h = h
		self.text = text
		self.rounded = rounded and 6 or false

		self.colorbackground = tocolor(120, 95, 205, 255)
		self.colortext = tocolor(255, 255, 255, 255)
		self.colorselected = tocolor(65, 40, 145, 255)
		
		if self.parent then
 
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y

        end

        if tonumber(self.rounded) then
        	self.svg = svgCreateRoundedRectangle(self.w, self.h, self.rounded, tocolor(255,255,255))
        	setTimer(function() self.update = true end, 100, 1)
        else
        	self.update = true
        end
  	
        return element

	end

end