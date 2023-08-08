function Render.dxImage(element, parent, offX, offY)
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
		
		if isElement( self.texture ) then
			dxSetBlendMode("add")
				dxDrawImage(x, y, self.w, self.h, (self.shader or self.texture), 0, 0, 0, self.colorbackground, false)
			dxSetBlendMode("blend")
		end

		if isCursorOver(x2, y2, self.w, self.h) and getKeyState( 'mouse1' ) and not self.click then
			if not self.isDisabled then
				triggerEvent('onClick', element)
			end
		end
	end
end
