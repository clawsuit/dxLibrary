function Render.dxWindow(element)
	
	local self = Cache[element]
	if self and isElement(element) then

		if not self.isVisible then
			return
		end

		local xw, xh = dxGetTextWidth( "✕", 1, self.font ), self.fontH
		self.w, self.h = math.round(self.w), math.round(self.h)

		if isElement(self.rendertarget) then
			local width, height = dxGetMaterialSize( self.rendertarget )
			if self.w ~= width or height ~= self.h then
				self.rendertarget:destroy()
				self.update = true
			end
		end

		if not isElement(self.rendertarget) then
			if self.w >= 1 and self.h >= 1 then
				self.rendertarget = DxRenderTarget(self.w, self.h, true)
			end
		end

		if not isElement(self.rendertarget) then return end;
		local postgui = false
        if self.postgui then
            if not isElement(self.parent) then
                postgui = true
            end
        end

		-- if isElement(self.svg) then
		-- 	local alpha = bitExtract(self.colorbackground,24,8)
		-- 	dxDrawImage(self.x, self.y, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha), postgui)
		-- else
		-- 	dxDrawRectangle(self.x, self.y, self.w, self.h, self.colorbackground, postgui)
		-- end

		-- dxDrawText2(self.title, self.x, self.y, self.w, self.h, self.colortitle, 1, self.font, 'center', 'top', false, false, postgui, false)
		-- if self.closebutton then
		-- 	dxDrawText2("✕", self.w-xw*2+self.x, self.y, self.w, self.h, -1, 1, self.font, 'left', 'top', false, false, postgui, false)
		-- end

		self.rendertarget:setAsTarget(true)
		dxSetBlendMode( 'modulate_add' )

			--
			if self.update or CLIENT_RESTORE then

				if isElement(self.rendertarget2) then
					self.rendertarget2:destroy()
				end

				if not isElement(self.rendertarget2) then
					self.rendertarget2 = DxRenderTarget(self.w, self.h, true)
				end

				self.rendertarget2:setAsTarget(true)
				--	
				--dxSetBlendMode( 'modulate_add' )
					if isElement(self.svg) then
						local alpha = bitExtract(self.colorbackground,24,8)
						dxDrawImage(0, 0, self.w, self.h, self.svg, 0, 0, 0, tocolor(255,255,255,alpha), false)
					else
						dxDrawRectangle(0, 0, self.w, self.h, self.colorbackground, false)
					end

					dxDrawText(self.title, 0, 0, self.w, self.h, self.colortitle, 1, self.font, 'center', 'top', false, false, false, false)
					if self.closebutton then
						dxDrawText("✕", self.w-xw*2, 0, self.w, self.h, self.colortitle, 1, self.font, 'center', 'top', false, false, false, false)
					end

					--dxSetBlendMode( 'blend' )
				dxSetRenderTarget(self.rendertarget)

				self.update = nil
			end

			if isElement(self.rendertarget2) then
				--dxSetBlendMode("add")
					dxDrawImage(0, 0, self.w, self.h, self.rendertarget2, 0, 0, 0, -1, false)
				--dxSetBlendMode("blend")
			end
			--]]

			for i, v in ipairs(self.childs) do
				if isElement(v) then
					--if v.type ~= 'dxTabPanel' then
						Render[v.type](v, element)
					--end
				end
			end
			
		dxSetBlendMode( 'blend' )
		dxSetRenderTarget()

		
		
		if isElement(self.rendertarget) then
			dxSetBlendMode("add")
				dxDrawImage(math.round(self.x), math.round(self.y), self.w, self.h, self.rendertarget, 0, 0, 0, tocolor(255,255,255,self.alpha), postgui)
			dxSetBlendMode("blend")
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

		

		self.click = getKeyState( 'mouse1' )
	end
end
