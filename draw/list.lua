function Render.dxList( element, parent )
	
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

		if isCursorOver(x2, y2, self.w, self.h) then
			if getKeyState( 'mouse1' ) and not self.click then
				self.update = true
			end
			if mouseOnElement ~= element then
				mouseOnElement = element
			end
		else
			if mouseOnElement == element then
				mouseOnElement = nil
			end
		end

		dxDrawRectangle(x, y, self.w, self.h, self.colorbackground, false)

		if self.update or CLIENT_RESTORE then

			if not isElement( self.rendertarget ) then
				self.rendertarget = DxRenderTarget( self.w-(20*sw), self.h-(20*sh), true )
			end

			self.rendertarget:setAsTarget(true)
			dxSetBlendMode( 'modulate_add' )

				local Y = 0
				local restY = 0

				for i = 1, #self.items do
					
					local H = self.h/5
					if getKeyState( 'mouse1' ) and not self.click then
						if isCursorOver(x2, y2, self.w, self.h) then
							if isCursorOver(x2+(10*sw), (y2+(10*sh))+(Y-(self.mul)), (self.w-(20*sw)), H) then

								if self.selected == i then
									self.selected = -1
								else
									self.selected = i
									triggerEvent('onClick', element)
								end

							else

								if self.selected == i then
									self.selected = -1
								end

							end
						end
					end

					if self.selected == i then
						dxDrawRectangle(0, (Y-(self.mul)), (self.w-(20*sw)), H, self.colorselected, false)
					else
						if i%2 == 1 then
							dxDrawRectangle(0, (Y-(self.mul)), (self.w-(20*sw)), H, self.colorrectangle, false)
						else
							dxDrawRectangle(0, (Y-(self.mul)), (self.w-(20*sw)), H, self.colorrectangle2, false)
						end
					end

					dxDrawText( tostring(self.items[i] or ''), 0, (Y-(self.mul)), (self.w-(20*sw)), (H)+(Y-(self.mul)), self.colortext, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false)

					Y = Y + H + ( i == #self.items and 0 or (7*sh))
					if Y >= self.h-(20*sh) then
						restY = Y - (self.h-(20*sh))
					end

				end
				
				self.scroll = restY


			if self.rootParent then
				dxSetRenderTarget(Cache[self.rootParent].rendertarget)
			else
				dxSetRenderTarget()
			end

			self.update = nil
		end

		if isElement( self.rendertarget ) then
			dxDrawImage(x+(10*sw), y+(10*sh), self.w-(20*sw), self.h-(20*sh), self.rendertarget, 0, 0, 0, tocolor( 255, 255, 255, 255 ), false)
		end
		

		if isCursorShowing( ) then

			if ( (getKeyState( 'arrow_u' ) and not self.arrow_u) or (getKeyState( 'arrow_d' ) and not self.arrow_d) or isKeyPressed('mouse_wheel_up') or isKeyPressed('mouse_wheel_down')) and (mouseOnElement == element or not mouseOnElement) then

				if isCursorOver(x2, y2, self.w, self.h) then
					

					if isKeyPressed('mouse_wheel_up') or getKeyState( 'arrow_u' ) then
						self.from = self.from or self.mul
						if not self.to then
							self.to = math.max(0, self.mul-(15*sh))
						else
							self.to = math.max(0, self.to-(15*sh))
						end

					end
					--
					if isKeyPressed('mouse_wheel_down') or getKeyState( 'arrow_d' ) then
						self.from = self.from or self.mul
						if not self.to then
							self.to = math.min(self.scroll, self.mul+(15*sh))
						else
							self.to = math.min(self.scroll, self.to+(15*sh))
						end
					end

					self.tick = self.tick or getTickCount(  )
				end

				resetKey('mouse_wheel_up')
				resetKey('mouse_wheel_down')

			end
		end

		if self.tick then

			self.mul = interpolateBetween( self.from, 0, 0, self.to, 0, 0, (getTickCount()-self.tick)/(math.max(1, math.abs(self.to - self.from))*10), "Linear" )

			self.update = true
			if (getTickCount()-self.tick) >= (math.max(1, math.abs(self.to - self.from))*10) or self.mul == self.to then
				
				self.tick = nil
				self.mul = self.to

				self.from = nil
				self.to = nil
	
			end
		end

		self.click = getKeyState( 'mouse1' )
		self.arrow_u = getKeyState( 'arrow_u' )
		self.arrow_d = getKeyState( 'arrow_d' )

	end

end


