function dxEdit(x, y, w, h, title, parent, rounded, colorbackground, colortile, colorborder, colorselected)

	local self, element = createElement('dxEdit', parent, sourceResource)
	if self then

		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.title = title
		self.rounded = tonumber(rounded) or rounded == true and 13 or false

		self.text = ''

		self.caretA = 0
		self.caretB = 0
		self.caretC = 0
 
		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorbackground or back.editbackground
		self.colortitle = colortile or back.edittitle
		--
		self.colorborder = colorborder or front.editborder
		self.colorselected = colorselected or front.editselected
		--
		self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )
		--
		self.masked = nil
		self.maxCharacters = nil
		--

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        if tonumber(self.rounded) then

      		local rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground)--, 2, self.colorborder)
  			self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)

  			local rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground, 2, self.colorselected)
  			self.svg2 = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)

        else
        	self.update = true
        end
  	
        return element

	end

end


function dxEditSetMasked(element, bool)
	local self = Cache[element]
	if self then	
		self.masked = bool
		return true
	end
	return false
end

function dxEditSetMaxCharacters(element, quantity)
	local self = Cache[element]
	if self then	
		self.maxCharacters = quantity
		return true
	end
	return false
end

--[[

function dxEditSetText(element, text)
	local self = Cache[element]
	if self then
			


		self.update = true
		return true
	end
	return false
end

]]