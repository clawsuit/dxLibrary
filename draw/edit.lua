function Render.dxEdit(element, parent, offX, offY)
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
			if onBox == element or onBoxBackup == element then
	 			onBox = nil
				onBoxBackup = nil
	 			guiSetInputEnabled(false)
	 		end
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
		
		local color = self.colorborder
		local postgui
		if self.postgui then
			if not isElement(self.parent) then
				postgui = true
			end
		end

		if onBox == element then
			if self.currentColor ~= self.colorselected then
				self.currentColor = self.colorselected
				self.update = true
			end
		else
			if self.currentColor ~= self.colorborder then
				self.currentColor = self.colorborder
				self.update = true
			end
		end

		local color = self.currentColor
		if self.update or CLIENT_RESTORE then

			if isElement(self.rendertarget) then
				self.rendertarget:destroy()
			end

			if not isElement(self.rendertarget) then
				self.rendertarget = DxRenderTarget(math.round(self.w), math.round(self.h), true)
			end

			self.rendertarget:setAsTarget(false)
			dxSetBlendMode( 'modulate_add' )
				if self.svg then

					local alpha = bitExtract(self.colorbackground,24,8)
					if self.currentColor ~= self.colorselected then
						if isElement(self.svg) then			
							dxDrawImage(1, 1, self.w-2, self.h-2, self.svg, 0, 0, 0, tocolor(255,255,255,alpha), false)
						end
					else
						if isElement(self.svg2) then
							dxDrawImage(1, 1, self.w-2, self.h-2, self.svg2, 0, 0, 0, tocolor(255,255,255,alpha), false)
						end
					end

				else

					dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false) -- up

					dxDrawRectangle(0, 0, self.w, 1.5, color, false) -- up
					dxDrawRectangle(0, (-.75)+self.h, self.w, 1.5/2, color, false) -- down
					--
					dxDrawRectangle(0, 0, 1.5, self.h, color, false) -- left
					dxDrawRectangle((-.75)+self.w, 0, 1.5/2, self.h, color, false) -- left

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

		
		if self.text:len() == 0 then
			local R,G,B,A = colorToRgba(self.colortitle)
       		A = A * (self.alpha/255)
			--
			dxDrawText(self.title, x, y, self.w+x, self.h+y, tocolor(R,G,B,A), 1, self.font, 'center', 'center', true, true, postgui, false)
		else

			local text = self.text:sub(self.caretA, self.caretB)
			if self.masked then
				text = text:gsub('.', '●')
			end

			local R,G,B,A = colorToRgba(self.colortext or tocolor(0,0,0,255))
       		A = A * (self.alpha/255)

			dxDrawText(text, x+5, y, self.w+x+5, self.h+y, tocolor(R,G,B,A), 1, self.font, 'left', 'center', false, false, postgui, false)
		end


		-- if getKeyState( 'mouse1' ) and not self.click and not self.isDisabled then
		-- 	if isCursorOver(x2, y2, self.w, self.h) then
		-- 		onBox = element
		-- 		guiSetInputEnabled(true)
		-- 	else
		-- 		if onBox == element then
		-- 			onBox = nil
		-- 			guiSetInputEnabled(false)
		-- 		end
		-- 	end
		-- end

		if onBox == element then

			self.tick = self.tick or getTickCount(  )
			local a = ((getTickCount(  ) - self.tick)/500)%1

			local m = #self.text == 0 and 0 or dxGetTextWidth(self.text:sub(self.caretA, math.min(self.caretB, self.caretC)), 1, self.font )

			dxDrawRectangle(x+m+5, y+5, 1, self.h-10, tocolor(90,90,90,(255*a) * (self.alpha/255)), postgui)

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


function dxActiveInput(element)
	if isElement(element) then
		if element.type == 'dxEdit' then
			onBox = element
			guiSetInputEnabled(true)
		end
	else
		onBox = nil
		guiSetInputEnabled(false)
	end
end


function writeInBox(element, c, bool)
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		if self.maxCharacters and #self.text >= self.maxCharacters then
			return
		end
		
		
		-- local parent = self.parent
		-- local x, y, x2, y2 = self.x, self.y, self.x, self.y
		-- if isElement(parent) then
		-- 	x, y = self.offsetX, self.offsetY
		-- 	x2, y2 = Cache[parent].x + x, Cache[parent].y + y
		-- end
		local newText = self.text:sub(1, math.max(1, self.caretC)) .. c .. self.text:sub(self.caretC+1)
		local text = self.text:sub(self.caretA, self.caretB)

		local lw = dxGetTextWidth(c, 1, self.font )
		local tw = dxGetTextWidth(text, 1, self.font )+lw

		triggerEvent('onEditChange', element, newText, c)
		if wasEventCancelled(  ) then return end
		
		if self.caretC == 0 then
			self.caretA = math.max(1, self.caretA - 1)
		end
		
		self.text = newText
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
					if timerDelete and timerDelete:isValid() then
						timerDelete:destroy()
						return
					end
				end

				if self.caretC > 0 then

					local letra = self.text:sub(self.caretC, self.caretC)
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

					triggerEvent('onEditChange', element, self.text)

					local tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
					while tw >= (self.w-10) and self.caretB > 0 do
						self.caretB = self.caretB - 1
						tw = dxGetTextWidth(self.text:sub(self.caretA, self.caretB ), 1, self.font )
					end

					if self.text:len() == 0 then
						if timerDelete and timerDelete:isValid() then
							timerDelete:destroy()
						end
					end

				else
					if timerDelete and timerDelete:isValid() then
						timerDelete:destroy()
					end
				end
			end,
		55, 0)
		
	end
end



addEventHandler("onClientPaste", root, function(text)
    if isElement(onBox) then
    	local self = Cache[onBox]
		if self then
			if self.isVisible then
    			for i = 1, #text do
                    writeInBox(onBox, text:sub(i,i))
                end
            end
        end
    end
end)