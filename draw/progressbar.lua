function Render.dxProgressBar(element, parent)
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		local x, y, x2, y2 = self.x, self.y, self.x, self.y
		if parent then
			x, y = self.offsetX, self.offsetY
			x2, y2 = Cache[parent].x + x, Cache[parent].y + y
		end

		self.tick = self.tick or getTickCount(  )
		self.progress = interpolateBetween( self.from, 0, 0, self.to, 0, 0, (getTickCount()-self.tick)/((2000)), "InQuad" )

		local fx, fy = 4*sw, 4*sh

		if self.svg then
			dxDrawImage(x, y, self.w, self.h, self.svg, 0, 0, 0, self.colorbackground, false)

			if self.progress > 0 then
				dxDrawImage(x+fx, y+fy, (self.w-fx*2)*(self.progress/100), self.h-fy*2, self.svg, 0, 0, 0, self.colorprogress, false)
			end

		else
			dxDrawRectangle(x, y, self.w, self.h, self.colorbackground, false)

			if self.progress > 0 then
				dxDrawRectangle(x+fx, y+fy, (self.w-fx*2)*(self.progress/100), self.h-fy*2, self.colorprogress, false)
			end

		end

		dxDrawText(math.floor(self.progress)..'%', x, y, self.w+x, self.h+y, self.colortitle, 1, self.font, 'center', 'center', true, true, false, false)

	end

end
