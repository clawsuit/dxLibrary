function Render.dxButton(element, parent)
	
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

		self.r = self.r or 0
		local color = self.colorbackground

		if getKeyState('mouse1') then
			if isCursorOver(x2, y2, self.w, self.h) then

			 	if getKeyState( 'mouse1' ) and not self.click then
			 		self.r = 1
			 		triggerEvent('onClick', element)
			 	end

		 		color = self.colorselected
			end
		else
			if self.r == 1 then
			 	self.r = 0
			end
		end

		if self.update then

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(self.w, self.h, true)
			end

			self.rendertarget:setAsTarget(true)
			dxSetBlendMode( 'modulate_add' )
				if self.svg then
					dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, -1, false)
				else
					dxDrawRectangle(0, 0, self.w, self.h, -1, false)
				end

			if self.rootParent then
				dxSetRenderTarget(Cache[self.rootParent].rendertarget)
			else
				dxSetRenderTarget()
			end

			self.update = nil
		end

		if isElement(self.rendertarget) then
			dxDrawImage(x+self.r, y+self.r, self.w-self.r*2, self.h-self.r*2, self.rendertarget, 0, 0, 0, color, false)
		end
		dxDrawText(self.text, x, y, self.w+x, self.h+y, self.colortext, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false)

		self.click = getKeyState( 'mouse1' )
	end

end
