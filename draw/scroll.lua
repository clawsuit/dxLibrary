function Render.dxScroll(element, parent)
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		local x, y, x2, y2, pos, pos2 = self.x, self.y, self.x, self.y, self.pos, self.pos
		if parent then
			x, y = self.offsetX, self.offsetY
			x2, y2 = Cache[parent].x + x, Cache[parent].y + y
			pos = self.posOff

			if not self.vertical then
				pos2 = Cache[parent].x + pos
			else
				pos2 = Cache[parent].y + pos
			end
		end

		local xw,xh = dxGetTextWidth( "▲", 1, Files['font']['Basic-Regular.ttf'][10] ), dxGetFontHeight( 1, Files['font']['Basic-Regular.ttf'][10] )

		if self.update or CLIENT_RESTORE then

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(self.w, self.h, true)
			end

			self.rendertarget:setAsTarget(false)
			dxSetBlendMode( 'modulate_add' )

				if not self.vertical then
					if self.svg then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, -1, false)
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end

					dxDrawText('➤', 0, 0.5, xw*2, self.h+.5, -1, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false, false, 178)
					dxDrawText('➤', self.w-xw*2, 0, (xw*2)+self.w-xw*2, self.h-2.5, -1, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false)
				else
					if self.svg then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, -1, false)
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end
 					
 
					dxDrawText('➤', -1, 0, self.w-1, xh, -1, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false, false, -90)
					--dxDrawText('▲', 0, -1, self.w, xh-1, -1, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false)
					--dxDrawText('▼', 0, self.h-xh, self.w, self.h, -1, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false)
					dxDrawText('➤', 1, self.h-xh, self.w+1, self.h, -1, 1, Files['font']['Basic-Regular.ttf'][10], 'center', 'center', true, true, false, false, false, 90)
				end

			if parent then
				dxSetRenderTarget(Cache[parent].rendertarget)
			else
				dxSetRenderTarget()
			end

			self.update = nil
		end

		if isElement(self.rendertarget) then
			dxDrawImage(x, y, self.w, self.h, self.rendertarget, 0, 0, 0, -1, false)
		end

		local move = ''

		if isCursorShowing( ) then
			local cx, cy = getAbsoluteCursorPosition(  )

			if self.cursorY < cy then
				move = 'down'
			elseif self.cursorY > cy then
				move = 'up'
			elseif self.cursorX < cx then
				move = 'right'
			elseif self.cursorX > cx then
				move = 'left'
			end
			self.cursorY = cy
			self.cursorX = cx
		end


		if not self.vertical then

			local sizeW = (self.w-xw*2) < 90*sw and self.w / 3 or 40*sw
			if not self.dist then
				self.dist = getDistanceBetweenPoints2D( 0, (pos)+sizeW, 0, (x+self.w)-(xw*2))
			end

			self.bpos = self.bpos or pos
			dxDrawRectangle(self.bpos, y, sizeW, self.h, self.colorboton, false)

			local current = 1-math.min(1, getDistanceBetweenPoints2D( 0, self.bpos+sizeW, 0, (x+self.w)-(xw*2))/self.dist)

			if current ~= self.current then
				self.current = current
				triggerEvent('onScrollChange', element, current)
			end

 			if isCursorShowing( ) then

 				if getKeyState( 'mouse1' ) and not self.click then
					if not self.moved then
						if isCursorOver((parent and Cache[parent].x or 0)+self.bpos, y2, sizeW, self.h) then
							local ax = getAbsoluteCursorPosition()
							self.moved = ax - (parent and Cache[parent].x or 0)
						end
					end
				end

				if getKeyState( 'mouse1' ) then
					if self.moved then
						
						local ax = getAbsoluteCursorPosition()
						ax = ax - (parent and Cache[parent].x or 0)

						self.bpos = self.bpos + (ax - self.moved)

						if self.bpos < (x+xw*2) then
							self.bpos = (x+xw*2)
						elseif self.bpos > (x+self.w)-(sizeW+xw*2) then
							self.bpos = (x+self.w)-(sizeW+xw*2)
						end
						
						self.moved = ax

					end
				else
					self.moved = nil
				end

			end

		else

			local sizeH = self.h-xh < 90*sh and self.h / 3 or 40*sh
			if not self.dist then
				self.dist = getDistanceBetweenPoints2D( 0, (y+xh)+sizeH, 0, (y+self.h)-(xh))
			end

			self.bpos = self.bpos or (y+xh)
			dxDrawRectangle(x, self.bpos, self.w, sizeH, self.colorboton, false)

			local current = 1-math.min(1, getDistanceBetweenPoints2D( 0, self.bpos+sizeH, 0, (y+self.h)-(xh))/self.dist)
			
			if current ~= self.current then

				self.current = current
				triggerEvent('onScrollChange', element, current)
			end

			if self.tick then

				self.bpos = interpolateBetween( self.from, 0, 0, self.to, 0, 0, (getTickCount()-self.tick)/(math.abs(self.to - self.from)*6), "Linear" )

				if self.bpos == self.to then
					
					self.tick = nil
					self.bpos = self.to

					self.from = nil
					self.to = nil

					
				end
			end

			if isCursorShowing( ) then

				if (isKeyPressed('mouse_wheel_up') or isKeyPressed('mouse_wheel_down')) and (self.gridlist and mouseOnElement == self.gridlist or not mouseOnElement) then

					if parent and isCursorOver(Cache[parent].x, Cache[parent].y, Cache[parent].w, Cache[parent].h) or isCursorOver(x2, y2, self.w, self.h) then
						self.tick = self.tick or getTickCount(  )

						if isKeyPressed('mouse_wheel_up') then
							self.from = self.from or self.bpos
							if not self.to then
								self.to = math.max((y+xh), self.bpos-math.random(15,30)*sh)
							else
								self.to = math.max((y+xh), self.to-math.random(15,30)*sh)
							end

						end
						--
						if isKeyPressed('mouse_wheel_down') then
							self.from = self.from or self.bpos
							if not self.to then
								self.to = math.min((y+self.h)-(sizeH+xh), self.bpos+math.random(15,30)*sh)
							else
								self.to = math.min((y+self.h)-(sizeH+xh), self.to+math.random(15,30)*sh)
							end
						end

					end
					resetKey('mouse_wheel_up')
					resetKey('mouse_wheel_down')

				else
					if getKeyState( 'mouse1' ) and not self.click then
						if not self.moved then
							if isCursorOver(x2, (parent and Cache[parent].y or 0)+self.bpos, self.w, sizeH) then
								local _, ay = getAbsoluteCursorPosition()
								self.moved = ay - (parent and Cache[parent].y or 0)
							end
						end
					end

					if getKeyState( 'mouse1' ) then
						if self.moved then

							if self.tick then
								self.tick = nil
								self.bpos = self.to

								self.from = nil
								self.to = nil
							end

							
							local _, ay = getAbsoluteCursorPosition()
							ay = ay - (parent and Cache[parent].y or 0)

							self.bpos = self.bpos + (ay - self.moved)

							if self.bpos < (y+xh) then
								self.bpos = (y+xh)
							elseif self.bpos > (y+self.h)-(sizeH+xh) then
								self.bpos = (y+self.h)-(sizeH+xh)
							end

							self.moved = ay

						end
					else
						self.moved = nil
					end
				end

			end

		end
		
		self.click = getKeyState( 'mouse1' )
	end

end

