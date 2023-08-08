function Render.dxLabel(element, parent, offX, offY)
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

	 	if isCursorOver(x2, y2, self.w, self.h) and getKeyState( 'mouse1' ) and not self.click then
	 		if not self.isDisabled then
	 			triggerEvent('onClick', element)
	 		end
	 	end

		if self.update then

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(self.w-self.realX, self.h-self.realY, true)
			end

			self.rendertarget:setAsTarget(true)
			dxSetBlendMode( 'modulate_add' )
				if self.border then
					dxDrawBorderedText (self.border, self.text, 0, 0, self.w-self.realX, self.h-self.realY, self.colortext, (self.colorborder or self.colortext), 1, self.font, self.alignX, self.alignY, false, false, false, true, false)
				else
					dxDrawText(self.text, 0, 0, self.w-self.realX, self.h-self.realY, self.colortext, 1, self.font, self.alignX, self.alignY, false, false, false, true, false)
				end
			dxSetBlendMode("blend")
			if isElement(parent) then
				dxSetRenderTarget(Cache[parent].rendertarget)
			else
				dxSetRenderTarget()
			end

			self.update = nil
		end

		if isElement(self.rendertarget) then
			dxSetBlendMode("add")
				dxDrawImage(x, y, self.w-self.realX, self.h-self.realY, self.rendertarget, 0, 0, 0, -1, false)
			dxSetBlendMode("blend")
		end

		self.click = getKeyState( 'mouse1' )
	end
end


