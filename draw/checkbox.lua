function Render.dxCheckBox( element, parent, offX, offY )
	
	local self = Cache[element]
	if self then

		if not self.isVisible then
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

		-- if getKeyState( 'mouse1' ) and not self.click and not self.isDisabled then
		-- 	if isCursorOver(x2, y2, self.w, self.h) then
		-- 		if not self.isDisabled then
		-- 			self.state = not self.state
		-- 	 		triggerEvent('onClick', element)
		-- 		end
		-- 	end
		-- end

		local postgui
		if self.postgui then
			if not isElement(self.parent) then
				postgui = true
			end
		end

		dxSetBlendMode("add")
			local R,G,B,A = colorToRgba(self.colorbackground)
        	A = A * (self.alpha/255)

			if isElement(self.svg) then 
				dxDrawImage(x, y, self.w, self.h, self.svg, 0, 0, 0, tocolor( 255, 255, 255, A ), postgui)
			end
		dxSetBlendMode("blend")

		dxSetBlendMode( 'modulate_add' )
			if self.state then
				local R,G,B,A = colorToRgba(self.colorchecker)
        		A = A * (self.alpha/255)
				--
				dxDrawText2('✓', x, y, self.w, self.h, tocolor(R,G,B,A), 1, self.font, 'center', 'center', false, false, postgui)
			end

			local R,G,B,A = colorToRgba(self.colortext)
        	A = A * (self.alpha/255)

			dxDrawText2(self.text, x+self.w+4, y, self.w, self.h-2, tocolor(R,G,B,A), 1, self.font, 'left', 'center', false, false, postgui)
		dxSetBlendMode("blend")
		
		self.click = getKeyState( 'mouse1' )
	end
end

