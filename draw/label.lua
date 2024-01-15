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

	 	-- if isCursorOver(x2, y2, self.w, self.h) and getKeyState( 'mouse1' ) and not self.click then
	 	-- 	if not self.isDisabled then
	 	-- 		triggerEvent('onClick', element)
	 	-- 	end
	 	-- end

	 	local postgui
		if self.postgui then
			if not isElement(self.parent) then
				postgui = true
			end
		end

		if self.w >= 1 and self.h >= 1 then
			if self.update then

				if isElement(self.rendertarget) then
					self.rendertarget:destroy()
				end

				if not isElement(self.rendertarget) then
					self.rendertarget = DxRenderTarget(math.round(self.w), math.round(self.h), true)
				end

				self.rendertarget:setAsTarget(false)
				dxSetBlendMode( 'modulate_add' )
					local width, height = dxGetMaterialSize( self.rendertarget )
					if self.border then
						dxDrawBorderedText (self.border, self.text, 0, 0, width, height, self.colortext, (self.colorborder or self.colortext), 1, self.font, self.alignX, self.alignY, true, true, false, false, false)
					else
						dxDrawText(self.text, 0, 0, width, height, self.colortext, 1, self.font, self.alignX, self.alignY, true, true, false, false, false)
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
					dxDrawImage(x, y, self.w, self.h, self.rendertarget, 0, 0, 0, tocolor(255,255,255,self.alpha), postgui)
				dxSetBlendMode("blend")
			end

		else
			if isElement(self.rendertarget) then
				self.rendertarget:destroy()
			end
			--
			dxSetBlendMode( 'modulate_add' )
				local R,G,B,A = colorToRgba(self.colortext)
        		A = A * (self.alpha/255)

				if self.border then
					dxDrawBorderedText (self.border, self.text, x, y, self.w+x, self.h+y, tocolor(R,G,B,A), (self.colorborder or tocolor(R,G,B,A)), 1, self.font, self.alignX, self.alignY, true, true, false, false, false)
				else
					dxDrawText2(self.text, x, y, self.w, self.realY, tocolor(R,G,B,A), 1, self.font, self.alignX, self.alignY, true, true, false, false, false)
				end
			dxSetBlendMode("blend")
		end

		self.click = getKeyState( 'mouse1' )
	end
end


