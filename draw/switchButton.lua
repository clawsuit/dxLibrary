function Render.dxSwitchButton(element, parent)
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
		
		local w = (self.w < 20*sw and self.w/2.8 or 20*sw)
		if getKeyState( 'mouse1' ) and not self.click then
			if not self.isDisabled then
				if isCursorOver(x2, y2, self.w, self.h) then

				 	self.tick = getTickCount(  )
				 	self.state = not self.state
				 	triggerEvent('onClick', element)
					self.update = true
					
				end
			end
		end

		if self.tick then
			self.bx = interpolateBetween( (self.state and 0 or self.w-w), 0, 0, (not self.state and 0 or self.w-w), 0, 0, (getTickCount(  )-self.tick)/(500), "Linear" )

			if (getTickCount(  )-self.tick) >= 500 then
				self.bx = (not self.state and 0 or self.w-w)
			end
		end

		if self.update or CLIENT_RESTORE or self.tick then

			if not isElement( self.rendertarget ) then
				self.rendertarget = DxRenderTarget( self.w, self.h, true )
			end

			self.rendertarget:setAsTarget(true)
			dxSetBlendMode( 'modulate_add' )
				
				dxDrawImage(0, 0, self.w, self.h, Files['image']['switch'], 0, 0, 0, self.colorbackground)
				dxDrawImage(self.bx, 0, w, self.h, Files['image']['round'], 0, 0, 0, (self.state and self.colorOn or self.colorOff))
--self.w-w
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

		if self.tick then
			if (getTickCount(  )-self.tick) >= 500 then
				triggerEvent( 'onSwithButtonChange', element, state )
				self.tick = nil
			end
		end

		self.click = getKeyState( 'mouse1' )
	end
end


