function Render.dxCheckBox( element, parent )
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		local x, y, x2, y2 = self.x, self.y, self.x, self.y
		
		if isElement(parent) then
		
			x, y = self.offsetX, self.offsetY
			x2, y2 = Cache[parent].x + x, Cache[parent].y + y
		
		end

		if getKeyState( 'mouse1' ) and not self.click and not self.isDisabled then
		
			if isCursorOver(x2, y2, self.w, self.h) then

				self.state = not self.state
				self.text = self.state and checkBoxTypes[self.style] or ''
			 	triggerEvent('onClick', element)
				self.update = true
				
			end

		end

		if self.update or CLIENT_RESTORE then

			if not isElement( self.rendertarget ) then
				self.rendertarget = DxRenderTarget( self.w, self.h, true )
			end

			self.rendertarget:setAsTarget(true)
			dxSetBlendMode( 'modulate_add' )
			
				if not self.svg then
					DxDrawBorderedRectangle( 0, 0, self.w - 1, self.h - 1, self.colorbackground, self.colorborder, 1, false )
				else
					dxDrawImage(0, 0, self.w, self.h, self.svg)
				end
				dxDrawText( self.text, 0, 0, self.w, self.h, tocolor(120, 95, 205, 255), 1, self.font, 'center', 'center', true, true, false, false)


			if self.rootParent then
				dxSetRenderTarget(Cache[self.rootParent].rendertarget)
			else
				dxSetRenderTarget()
			end
			self.update = nil
		end

		if isElement( self.rendertarget ) then
			dxDrawImage(x, y, self.w, self.h, self.rendertarget, 0, 0, 0, tocolor( 255, 255, 255, 255 ), false)
		end
		
		--dxDrawText( self.text, x, y, self.w+x, self.h+y, tocolor(120, 95, 205, 255), 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false)
		self.click = getKeyState( 'mouse1' )

	end

end

