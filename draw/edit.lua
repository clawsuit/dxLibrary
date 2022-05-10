function Render.dxEdit(element, parent)
	
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
		local color = self.colorborder

		if onBox == element then
			color = self.colorselected
		end

		if self.update or CLIENT_RESTORE then

			if not self.rendertarget then
				self.rendertarget = DxRenderTarget(self.w, self.h, true)
			end

			self.rendertarget:setAsTarget(false)
			dxSetBlendMode( 'modulate_add' )
				if self.svg then
					dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, -1, false)
				else

					dxDrawRectangle(0, 0, self.w, 1.5, -1, false) -- up
					dxDrawRectangle(0, (-.75)+self.h, self.w, 1.5/2, -1, false) -- down
					--
					dxDrawRectangle(0, 0, 1.5, self.h, -1, false) -- left
					dxDrawRectangle((-.75)+self.w, 0, 1.5/2, self.h, -1, false) -- left
				end
			if self.rootParent then
				dxSetRenderTarget(Cache[self.rootParent].rendertarget)
			else
				dxSetRenderTarget()
			end

			self.update = nil
		end

		dxDrawRectangle(x, y, self.w, self.h, self.colorbackground, false) -- up

		if isElement(self.rendertarget) then
			dxDrawImage(x, y, self.w, self.h, self.rendertarget, 0, 0, 0, color, false)
		end

		

		if self.text:len() == 0 then
			dxDrawText(self.title, x, y, self.w+x, self.h+y, self.colortitle, 1, self.font, 'center', 'center', true, true, false, false)
		else

			local text = self.text:sub(self.caretA, self.caretB)
			if self.masked then
				text = text:gsub('.', '●')
			end

			dxDrawText(text, x+5, y, self.w+x+5, self.h+y, self.colortitle, 1, self.font, 'left', 'center', false, false, false, false)
		end

		if getKeyState( 'mouse1' ) and not self.click then
			if isCursorOver(x2, y2, self.w, self.h) then
				onBox = element
				guiSetInputEnabled(true)
			else
				if onBox == element then
					onBox = nil
					guiSetInputEnabled(false)
				end
			end
		end

		if onBox == element then

			self.tick = self.tick or getTickCount(  )
			local a = ((getTickCount(  ) - self.tick)/500)%1

			local m = #self.text == 0 and 0 or dxGetTextWidth(self.text:sub(self.caretA, math.min(self.caretB, self.caretC)), 1, self.font )

			dxDrawRectangle(x+m+5, y+5, 1, self.h-10, tocolor(255,255,255,255*a), false)

			if getKeyState( 'arrow_l' ) and not self.arrow_l then

				if self.text:sub(self.caretA, math.max(0, self.caretC-1) ):len() > 0 or self.caretA == 0 and self.caretC == 1 then
					--local t = self.text:sub(self.caretA, math.min(self.caretB, self.caretC))
					self.caretC = math.max(0, self.caretC - 1)
					
				else
					if self.caretA > 0 and self.caretC > 0 then
						self.caretA = math.max(1, self.caretA - 1)
						self.caretC = self.caretC - 1
						

						local tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
						while tw >= (self.w-10) and self.caretB > 0 do
							self.caretB = self.caretB - 1
							tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
						end

					end
				end

				---print('caretB: '..self.caretC..' | Text: '..t..' | '..(#t))
			elseif getKeyState( 'arrow_r' ) and not self.arrow_r then

				if self.caretC < #self.text then

					self.caretC = self.caretC + 1

					local tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretC ), 1, self.font )
					
					--if self.caretA < self.caretA1 then
						while tw >= (self.w-10) do

							self.caretA = self.caretA + 1
							self.caretB = self.caretB + 1
							self.caretC = self.caretC - 1

							tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretC ), 1, self.font )
							
							
						end
					--end

				end

			end

		end

		self.click = getKeyState( 'mouse1' )
		self.arrow_l = getKeyState( 'arrow_l' )
		self.arrow_r = getKeyState( 'arrow_r' )

	end

end

guiSetInputEnabled(false)



function writeInBox(element, c)
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		if self.maxCharacters and self.maxCharacters >= #self.text then
			return
		end

		local parent = self.parent
		local x, y, x2, y2 = self.x, self.y, self.x, self.y
		if parent then
			x, y = self.offsetX, self.offsetY
			x2, y2 = Cache[parent].x + x, Cache[parent].y + y
		end

		local text = self.text:sub(self.caretA, self.caretB)
		local lw = dxGetTextWidth(c, 1, self.font )
		local tw = dxGetTextWidth(text, 1, self.font )+lw
		
		if self.caretC == 0 then
			self.caretA = math.max(1, self.caretA - 1)
		end
		--if self.
		self.text = self.text:sub(1, math.max(1, self.caretC)) .. c .. self.text:sub(self.caretC+1)
		self.caretB = self.caretB + 1
		self.caretC = self.caretC + 1

		
		--print(tw+lw, (self.w-5))
		while tw >= (self.w-10) do

			if self.caretC == 0 then
				self.caretB = math.max(0, self.caretB - 1)
			else
				self.caretA = self.caretA + 1
			--	self.caretA1 = self.caretA1 + 1
			end

			tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB), 1, self.font )

		end

		
	end
end


function deleteTextInBox(element)
	local self = Cache[element or onBox]
	if self then

		if not self.isVisible then
			return
		end

		timerDelete = Timer(
			function()

				if self.text:len() == 0 then
					timerDelete:destroy()
				end

				if self.caretC > 0 then

					self.text = self.text:sub(1, self.caretC-1) .. self.text:sub(self.caretC+1)

					if self.caretC == 1 then

						if self.caretA > 0 then

							if self.text:len() == 0 then
								self.caretA = 0
							else
								self.caretA = math.max(0, self.caretA - 1)
							end

						else
							self.caretC = self.caretC - 1
						end

					else
						self.caretC = self.caretC - 1
					end

					

					local tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
					while tw >= (self.w-10) and self.caretB > 0 do
						self.caretB = self.caretB - 1
						tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
					end

					if self.text:len() == 0 then
						timerDelete:destroy()
					end

				else
					timerDelete:destroy()
				end
			end,
		55, 0)
		
	end
end


