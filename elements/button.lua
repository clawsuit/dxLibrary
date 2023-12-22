function dxButton(x, y, w, h, text, parent, rounded, colorbackground, colortext, colorselected)

	local self, element = createElement('dxButton', parent, sourceResource)
	if self then

		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.text = text
		self.rounded = tonumber(rounded) or rounded == true and 6 or false
		--
		self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )
		--

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorbackground or back.buttonbackground
		self.colortext = colortext or back.buttontext
		self.colorselected = colorselected or front.buttonselected
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end
 
        if tonumber(self.rounded) then
        	local rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, tocolor(255,255,255))
        	self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
        else
        	self.update = true
        end
  	
        return element

	end

end

function dxButtonSetFont( element, font )
	local self = Cache[element]
	if self then
		self.font = font
	end
end

