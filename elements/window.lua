function dxWindow(x, y, w, h, title, closebutton, rounded, border)

	local self, element = createElement('dxWindow', false, sourceResource)
	if self then

		self.x = x
		self.y = y
		self.w = w
		self.h = h
		self.title = title
		self.closebutton = (closebutton == nil and true) or (closebutton == false and false) or (closebutton == true and true)
		self.rounded = rounded and 10 or false

		self.colorbackground = tocolor(14, 14, 23, 255)
		self.colortitle = tocolor(255, 255, 255, 255)
		self.colorborder = tocolor(14, 14, 23, 255)
		
		self.rendertarget = DxRenderTarget(self.w, self.h, true)

		if self.parent then
 
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y

        end

        if tonumber(self.rounded) then
        	self.svg = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground, border,  border and self.colorborder or false)
        	setTimer(function() self.update = true end, 100, 1)
        else
        	self.update = true
        end

       	
        return element

	end

end


bindKey('m', 'down', function() showCursor(not isCursorShowing()) end)