function Render.dxScroll(element, parent, offX, offY)
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end
 
		if self.forcedVisibleFalse then
			return
		end

		local x, y, x2, y2, pos, pos2 = self.x, self.y, self.x, self.y, self.pos, self.pos
		if isElement(parent) then
			x, y = self.offsetX, self.offsetY
			--
			if x2 ~= (Cache[parent].x + x) or y2 ~= (Cache[parent].y + y) then
                x2, y2 = Cache[parent].x + x, Cache[parent].y + y
                self.x, self.y = x2, y2
            end

			pos = self.posOff

			if not self.vertical then
				pos = pos + (offX or 0)
				pos2 = Cache[parent].x + pos
			else
				pos = pos + (offY or 0)
				pos2 = Cache[parent].y + pos
			end
		end

		x, y = x + (offX or 0), y + (offY or 0)
		x2, y2 = x2 + (offX or 0), y2 + (offY or 0)

		local xw,xh = 8.5*sh, 17*sh

		if isElement(self.subParent) and Cache[self.subParent].postgui and not Cache[self.subParent].isVisible then
			return
		end

		local postgui
        if self.postgui or isElement(self.subParent) and Cache[self.subParent].postgui then
            if not isElement(self.parent) then
                postgui = true
            end
        end

        if isElement(self.rendertarget) then
			local width, height = dxGetMaterialSize( self.rendertarget )
			if self.w ~= width or height ~= self.h then
				--self.rendertarget:destroy()
				self.update = true
			end
		end

		if self.update then--or CLIENT_RESTORE then

			if isElement(self.rendertarget) then
				self.rendertarget:destroy()
			end

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(math.round(self.w), math.round(self.h), true)
			end

			self.rendertarget:setAsTarget()
			dxSetBlendMode( 'modulate_add' )

				local alpha = bitExtract(self.colorbackground,24,8)
				if not self.vertical then
					if self.svg then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha))
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end

					dxDrawText('➤', 0, 0.5, xw*2, self.h+.5, self.colortext, 1, self.font, 'center', 'center', true, true, false, false, false, 178)
					dxDrawText('➤', self.w-xw*2, 0, (xw*2)+self.w-xw*2, self.h-2.5, self.colortext, 1, self.font, 'center', 'center', true, true, false, false)
				else
					if self.svg then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha))
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end
 					
 
					dxDrawText('➤', -1, 0, self.w-1, xh, self.colortext, 1, self.font, 'center', 'center', true, true, false, false, false, -90)
					--dxDrawText('▲', 0, -1, self.w, xh-1, self.colortext, 1, self.font, 'center', 'center', true, true, false, false)
					--dxDrawText('▼', 0, self.h-xh, self.w, self.h, self.colortext, 1, self.font, 'center', 'center', true, true, false, false)
					dxDrawText('➤', 1, self.h-xh, self.w+1, self.h, self.colortext, 1, self.font, 'center', 'center', true, true, false, false, false, 90)
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
				dxDrawImage(x, y, self.w, self.h, self.rendertarget, 0, 0, 0, -1, postgui)
			dxSetBlendMode("blend")
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

			local sizeW = (self.w-xw*2) < 90*sh and self.w / 3 or 40*sh
			if not self.dist then
				self.dist = getDistanceBetweenPoints2D( 0, (pos)+sizeW, 0, (x+self.w)-(xw*2))
			end

			if self.newCurrent then

				local diff = (x+self.w)-(sizeW+xw*2) - (x+xw*2)
				self.bpos = (x+xw*2) + (diff*self.newCurrent)

				self.newCurrent = nil
			end

			self.bpos = self.bpos or pos
			--print((x+xw*2), self.bpos, (x+self.w)-(sizeW+xw*2))

			dxDrawRectangle(self.bpos, y, sizeW, self.h, self.colorboton, postgui)

			local current = 1-math.min(1, getDistanceBetweenPoints2D( 0, self.bpos+sizeW, 0, (x+self.w)-(xw*2))/self.dist)

			if current ~= self.current then
				self.current = current
				triggerEvent('onScrollChange', element, current)
			end

 			if isCursorShowing( ) then

 				if getKeyState( 'mouse1' ) and not self.click then
					if not self.moved then
						if isCursorOver((isElement(parent) and Cache[parent].x or 0)+self.bpos, y2, sizeW, self.h) then
							local ax = getAbsoluteCursorPosition()
							self.moved = ax - (isElement(parent) and Cache[parent].x or 0)
						end
					end
				end

				if getKeyState( 'mouse1' ) then
					if self.moved then
						
						local ax = getAbsoluteCursorPosition()
						ax = ax - (isElement(parent) and Cache[parent].x or 0)

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

			if self.newCurrent then

				local diff = (y+self.h)-(sizeH+xh) - (y+xh)
				self.bpos = (y+xh) + (diff*self.newCurrent)

				self.newCurrent = nil
			end

			self.bpos = self.bpos or (y+xh)
			dxDrawRectangle(x, self.bpos, self.w, sizeH, self.colorboton, postgui)

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

				if (isKeyPressed('mouse_wheel_up') or isKeyPressed('mouse_wheel_down')) and (self.attached and mouseOnElement == self.attached or not mouseOnElement) then

					if isElement(parent) and isCursorOver(Cache[parent].x, Cache[parent].y, Cache[parent].w, Cache[parent].h) or isCursorOver(x2, y2, self.w, self.h) or isElement(self.subParent) and isCursorOver(Cache[self.subParent].x, Cache[self.subParent].y, Cache[self.subParent].w, Cache[self.subParent].h)then
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
							if isCursorOver(x2, (isElement(parent) and Cache[parent].y or 0)+self.bpos, self.w, sizeH) then
								local _, ay = getAbsoluteCursorPosition()
								self.moved = ay - (isElement(parent) and Cache[parent].y or 0)
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
							ay = ay - (isElement(parent) and Cache[parent].y or 0)

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

