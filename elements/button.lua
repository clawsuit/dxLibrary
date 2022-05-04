function dxButton(x, y, w, h, title, parent, rounded, border)

	local self, element = createElement('dxButton', parent, sourceResource)
	if self then

		self.x = x
		self.y = y
		self.w = w
		self.h = h
		self.title = title
		self.rounded = rounded and 6 or false

		self.colorbackground = tocolor(120, 95, 205, 255)
		self.colortitle = tocolor(255, 255, 255, 255)
		self.colorselected = tocolor(65, 40, 145, 255)
		
		if self.parent then
 
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y

        end

        if tonumber(self.rounded) then
        	self.svg = svgCreateRoundedRectangle(self.w, self.h, self.rounded, tocolor(255,255,255), border,  border and tocolor(255,255,255) or false)
        	setTimer(function() self.update = true end, 100, 1)
        else
        	self.update = true
        end
  	
        return element

	end

end