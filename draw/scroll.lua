function Render.dxScroll(element, parent, offX, offY)
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end
 
		if self.forcedVisibleFalse then
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


		if isElement(self.attached) and not Cache[self.attached].isVisible then
			return
		end

		local postgui
        if self.postgui or isElement(self.attached) and Cache[self.attached].postgui then
            if not isElement(self.parent) then
                postgui = true
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
					if isElement(self.svg) then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha))
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end
				else
					if isElement(self.svg) then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha))
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end
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

		local R,G,B,A = colorToRgba(self.colorboton)
 
		if self.vertical then
			
			local sizeH = math.max(self.h / 3, 0)
			if not self.maxScroll or self.maxScroll ~= (self.h - sizeH) then
				self.maxScroll = self.h - sizeH
			end
			
			local posY = y + self.maxScroll * (self.scrollPosition / self.maxScroll)

			if isElement(self.svg2) then 
				dxDrawImage(x, posY, self.w, sizeH, self.svg2, 0, 0, 0, tocolor(255,255,255, A*(self.alpha/255)), postgui)
			else
				dxDrawRectangle(x, posY, self.w, sizeH, tocolor(R,G,B, A*(self.alpha/255)), postgui)
			end

			if self.tick then
				local ap = math.min(1, (getTickCount()-self.tick)/200)
				local pos = interpolateBetween( self.from, 0, 0, self.to, 0, 0, ap, "Linear" )

				self.scrollPosition = pos

				if ap >= 1 then
					self.from = nil
					self.to = nil
					self.tick = nil
				end
			end

			if isCursorShowing( ) then
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

						self.scrollPosition = math.min(math.max(self.scrollPosition + (ay - self.moved), 0), self.maxScroll)
						self.moved = ay

					end
				else
					self.moved = nil
				end
			end

		else

			local sizeW = math.max(self.w / 3, 0)
			if not self.maxScroll or self.maxScroll ~= (self.w - sizeW) then
				self.maxScroll = self.w - sizeW
			end

			local posX = x + self.maxScroll * (self.scrollPosition / self.maxScroll)

			if isElement(self.svg2) then 
				dxDrawImage(posX, y, sizeW, self.h, self.svg2, 0, 0, 0, tocolor(255,255,255, A*(self.alpha/255)), postgui)
			else
				dxDrawRectangle(posX, y, sizeW, self.h, self.colorboton, postgui)
			end

 			if isCursorShowing( ) then
				if getKeyState( 'mouse1' ) then
					if self.moved then
						
						local ax = getAbsoluteCursorPosition()
						ax = ax - (isElement(parent) and Cache[parent].x or 0)

						self.scrollPosition = math.min(math.max(self.scrollPosition + (ax - self.moved), 0), self.maxScroll)
						self.moved = ax

					end
				else
					self.moved = nil
				end
			end
		end

		if (self.scrollPosition / self.maxScroll) ~= self.current then
			self.current = self.scrollPosition / self.maxScroll
			triggerEvent('onScrollChange', element, self.current)
		end

		self.click = getKeyState( 'mouse1' )
	end
end

function dxElements.click.dxScroll(element, ax, ay)
	local self = Cache[element]
	if self then

		if isCursorShowing() then
			local x2, y2 = self.x + (self.offX or 0), self.y + (self.offY or 0)

			if self.vertical then
				if not self.moved then

					local sizeH = math.max(self.h / 3, 0)
					local posY = y2 + self.maxScroll * (self.scrollPosition / self.maxScroll)

					if isCursorOver(x2, posY, self.w, sizeH) then
						self.moved = ay - (isElement(self.parent) and Cache[self.parent].y or 0)
					end
				end
			else
				if not self.moved then

					local sizeW = math.max(self.w / 3, 0)
					local posX = x2 + self.maxScroll * (self.scrollPosition / self.maxScroll)

					if isCursorOver(posX, y2, sizeW, self.h) then
						self.moved = ax - (isElement(self.parent) and Cache[self.parent].x or 0)
					end
				end
			end
		end
	end
end


--[[
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
			local R,G,B = colorToRgba(self.colorboton)
			dxDrawRectangle(self.bpos, y, sizeW, self.h, tocolor(R,G,B, self.alpha), postgui)

			local current = 1-math.min(1, getDistanceBetweenPoints2D( 0, self.bpos+sizeW, 0, (x+self.w)-(xw*2))/self.dist)

			if current ~= self.current then
				self.current = current
				triggerEvent('onScrollChange', element, current)
			end

 			if isCursorShowing( ) then

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
				--print(self.dist)
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

				if ((isKeyPressed('mouse_wheel_up') or isKeyPressed('mouse_wheel_down')) and (isElement(self.attached) and isElement(mouseOnElement) and mouseOnElement == self.attached or not isElement(mouseOnElement))) then
				--if (isKeyPressed('mouse_wheel_up') or isKeyPressed('mouse_wheel_down')) and (self.attached and mouseOnElement == self.attached or not mouseOnElement) then

					if isElement(self.attached) and isCursorOver(Cache[self.attached].x, Cache[self.attached].y, Cache[self.attached].w, Cache[self.attached].h) or (not isElement(self.attached) and isElement(parent) and isCursorOver(Cache[parent].x, Cache[parent].y, Cache[parent].w, Cache[parent].h)) or isCursorOver(x2, y2, self.w, self.h) then
					--if isElement(parent) and isCursorOver(Cache[parent].x, Cache[parent].y, Cache[parent].w, Cache[parent].h) or isCursorOver(x2, y2, self.w, self.h) or isElement(self.attached) and isCursorOver(Cache[self.attached].x, Cache[self.attached].y, Cache[self.attached].w, Cache[self.attached].h)then
						self.tick = self.tick or getTickCount(  )

						local value = self.dist/30
						if isElement(self.attached) then

							if self.attached:getType() == 'dxGridList' then

								value = self.dist/#Cache[self.attached].items
								
							elseif self.attached:getType() == 'dxScrollPane' then

								value = self.dist/Cache[self.attached].self.scrollY

							end
						end

						if isKeyPressed('mouse_wheel_up') then
							self.from = self.from or self.bpos
							if not self.to then
								self.to = math.max((y+xh), self.bpos-value)
							else
								self.to = math.max((y+xh), self.to-value)
							end

						end
						--
						if isKeyPressed('mouse_wheel_down') then
							self.from = self.from or self.bpos
							if not self.to then
								self.to = math.min((y+self.h)-(sizeH+xh), self.bpos+value)
							else
								self.to = math.min((y+self.h)-(sizeH+xh), self.to+value)
							end
						end

					end
					resetKey('mouse_wheel_up')
					resetKey('mouse_wheel_down')

				else

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

]]


