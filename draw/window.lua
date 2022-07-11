function Render.dxWindow(element)
	
	local self = Cache[element]
	if self and isElement(element) then

		if not self.isVisible then
			return
		end

		local xw, xh = dxGetTextWidth( "✕", 1, self.font ), self.fontH
		self.rendertarget:setAsTarget(true)
		dxSetBlendMode( 'modulate_add' )

			if self.update or CLIENT_RESTORE then

				if not isElement(self.rendertarget2) then
					self.rendertarget2 = DxRenderTarget(self.w, self.h, true)
				end

				self.rendertarget2:setAsTarget(true)
				--

					if self.svg then
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, -1, false)
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end

					dxDrawText(self.title, 0, 0, self.w, self.h, self.colortitle, 1, self.font, 'center', 'top', false, false, false, false)
					if self.closebutton then
						dxDrawText("✕", self.w-xw*2, 0, self.w, self.h, self.colortitle, 1, self.font, 'center', 'top', false, false, false, false)
					end

				dxSetRenderTarget(self.rendertarget)

				self.update = nil
			end

			if isElement(self.rendertarget2) then
				dxDrawImage(0, 0, self.w, self.h, self.rendertarget2, 0, 0, 0, -1, false)
			end
--
			for i, v in ipairs(self.childs) do
				if isElement(v) then
					Render[v.type](v, element)
				end
			end
			
		dxSetBlendMode( 'blend' )
		dxSetRenderTarget()
		
		if isElement(self.rendertarget) then
			dxDrawImage(self.x, self.y, self.w, self.h, self.rendertarget, 0, 0, 0, -1, true)
		end

		if isCursorOver(self.x, self.y, self.w, self.h) or self.moved then

			if getKeyState( 'mouse1' ) and not self.click then
				if self.isMoved and not self.moved then
					self.moved = isCursorOver(self.x, self.y, self.w, xh) and {getAbsoluteCursorPosition()}
				end
			end

			if self.moved then
				if getKeyState( 'mouse1' ) then

					local ax, ay = getAbsoluteCursorPosition()

					self.x = self.x + (ax - self.moved[1])
					self.y = self.y + (ay - self.moved[2])

					self.moved = {ax, ay}

				else

					self.moved = nil

				end
			end

		end

		if self.closebutton and isCursorOver(self.x+self.w-xw*2, self.y, xw*2, xh) then
			if getKeyState( 'mouse1' ) and not self.click then

				triggerEvent('onClose', element)
				if not wasEventCancelled(  ) then
					self.isVisible = false
				end
				
			end
		end

		self.click = getKeyState( 'mouse1' )
	end
end
