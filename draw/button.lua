function Render.dxButton(element, parent, offX, offY)
	
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

		self.r = self.r or 0
		local color = self.colorbackground

		if not self.isDisabled then
			if getKeyState('mouse1') then
				if isCursorOver(x2, y2, self.w, self.h) then

				 	if getKeyState( 'mouse1' ) and not self.click then
				 		self.r = 1
				 	end

			 		color = self.colorselected
			 		--self.update = true
				end
			else
				if self.r == 1 then
				 	self.r = 0
				end
			end
		else
			color = self.colorselected
			--self.update = true
		end
 
		if self.update then

			if isElement(self.rendertarget) then
				self.rendertarget:destroy()
			end

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(math.round(self.w), math.round(self.h), true)
			end

			self.rendertarget:setAsTarget()
			dxSetBlendMode( 'modulate_add' )

				if isElement(self.svg) then
					dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, -1, false)
				else
					dxDrawRectangle(0, 0, self.w, self.h, -1, false)
				end
				--dxDrawText2('hola boton', 0, 0, self.w, self.h, self.colortext, 1, self.font, 'center', 'center', false, false, false, false)

			dxSetBlendMode("blend")
			if isElement(parent) then
				dxSetRenderTarget(Cache[parent].rendertarget)
			else
				dxSetRenderTarget()
			end

			if color == self.colorbackground or self.isDisabled then
				self.update = nil
			end
		end

		local postgui
		if self.postgui then
			if not isElement(self.parent) then
				postgui = true
			end
		end

		if isElement(self.rendertarget) then
			dxSetBlendMode("add")
				dxDrawImage(x+self.r, y+self.r, self.w-self.r*2, self.h-self.r*2, self.rendertarget, 0, 0, 0, color, postgui)
			dxSetBlendMode("blend")
		end

		dxSetBlendMode( 'modulate_add' )
			dxDrawText(self.text, x, y, self.w+x, self.h+y, self.colortext, 1, self.font, 'center', 'center', true, true, postgui, false)
		dxSetBlendMode("blend")

		self.click = getKeyState( 'mouse1' )
	end

end
