function Render.dxLabel(element, parent)
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

		if self.update then

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(self.w-self.x, self.h-self.y, true)
			end

			self.rendertarget:setAsTarget(true)
			dxSetBlendMode( 'modulate_add' )
				if self.border then
					dxDrawBorderedText (self.border, self.text, 0, 0, self.w-self.x, self.h-self.y, self.colortext, (self.colorborder or self.colortext), 1, self.font, self.alignX, self.alignY, false, false, false, true, false)
				else
					dxDrawText(self.text, 0, 0, self.w-self.x, self.h-self.y, self.colortext, 1, self.font, self.alignX, self.alignY, false, false, false, true, false)
				end

			if self.rootParent then
				dxSetRenderTarget(Cache[self.rootParent].rendertarget)
			else
				dxSetRenderTarget()
			end

			self.update = nil
		end

		if isElement(self.rendertarget) then
			dxDrawImage(x, y, self.w-self.x, self.h-self.y, self.rendertarget, 0, 0, 0, -1, false)
		end

	end
end