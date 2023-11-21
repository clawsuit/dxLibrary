function dxLabel( x, y, w, h, text, parent, alignX, alignY, border, colortext, colorborder, guiCoord)
	
	local self, element = createElement( 'dxLabel', parent, sourceResource )
	if self then

		local w, h = w, h
		if guiCoord then
			w = w + x
			h = h + y
		end
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.max(0, math.round(w) - math.round(x))
		self.h = math.max(0, math.round(h) - math.round(y))
		self.text = text
		self.parent = parent

		self.realX, self.realY = self.x, self.y

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colortext = colortext or tocolor(255, 255, 255, 255)
		self.colorborder = colorborder or self.colortext
		--
		self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )
		--
		self.alignX = alignX or 'left'
        self.alignY = alignY or 'top'
        self.border = tonumber(border) or nil
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

      	self.update = true
        return element
	
	end
end

