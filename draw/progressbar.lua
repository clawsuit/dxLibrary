function Render.dxProgressBar(element, parent, offX, offY)
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		local x, y, x2, y2 = self.x, self.y, self.x, self.y
		if isElement(parent) then
			x, y = self.offsetX, self.offsetY
			--
			if x2 ~= (Cache[parent].x + x) or y2 ~= (Cache[parent].y + y) then
                x2, y2 = Cache[parent].x + x, Cache[parent].y + y
                self.x, self.y = x2, y2
            end
		end

		x, y = x + (offX or 0), y + (offY or 0)
		x2, y2 = x2 + (offX or 0), y2 + (offY or 0)

		self.tick = self.tick or getTickCount(  )
		self.progress = interpolateBetween( self.from, 0, 0, self.to, 0, 0, (getTickCount()-self.tick)/((2000)), "InQuad" )

		local postgui
		if self.postgui then
			if not isElement(self.parent) then
				postgui = true
			end
		end

		local fx, fy = 4*sw, 4*sh

		dxSetBlendMode( 'modulate_add' )
		if self.svg then
			dxDrawImage(x, y, self.w, self.h, self.svg, 0, 0, 0, self.colorbackground, postgui)

			if self.progress > 0 then
				if isElement(self.svg) then
					dxDrawImage(x+fx, y+fy, (self.w-fx*2)*(self.progress/100), self.h-fy*2, self.svg, 0, 0, 0, self.colorprogress, postgui)
				end
			end

		else
			dxDrawRectangle(x, y, self.w, self.h, self.colorbackground, postgui)

			if self.progress > 0 then
				dxDrawRectangle(x+fx, y+fy, (self.w-fx*2)*(self.progress/100), self.h-fy*2, self.colorprogress, postgui)
			end

		end

		dxDrawText(math.floor(self.progress)..'%', x, y, self.w+x, self.h+y, self.colortext, 1, self.font, 'center', 'center', true, true, postgui, false)
		dxSetBlendMode("blend")
	end

end

