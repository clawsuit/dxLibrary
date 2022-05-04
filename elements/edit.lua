function dxEdit(x, y, w, h, title, parent, rounded)

	local self, element = createElement('dxEdit', parent, sourceResource)
	if self then

		self.x = x
		self.y = y
		self.w = w
		self.h = h
		self.title = title
		self.rounded = rounded and 6 or false

		self.text = ''

		self.caretA = 0
		self.caretB = 0
		self.caretC = 0

		self.colorbackground = tocolor(14, 14, 23, 255)
		self.colortitle = tocolor(255, 255, 255, 255)
		--
		self.colorline = tocolor(51, 33, 112, 255)
		self.colorselected = tocolor(120, 95, 205, 255)
		--
		self.masked = nil
		self.maxCharacters = nil
		--

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        if tonumber(self.rounded) then

      --   	local r2,g2,b2,a2 = bitExtract(self.colorbackground,16,8),bitExtract(self.colorbackground,8,8), bitExtract(self.colorbackground,0,8), bitExtract(self.colorbackground,24,8)
    		-- local _color2 = string.format("#%.2X%.2X%.2X", r2,g2,b2)

      --   	local rawSvgData = [[
		    --     <svg width="]]..(self.w)..[[" height="]]..(self.h)..[[">
		    --         <rect x="0" y="0" rx="]]..self.rounded..[[" ry="]]..self.rounded..[[" width="]]..(self.w)..[[" height="]]..(self.h)..[["
		    --         fill="rgb(0,0,0)" stroke="]].._color2..[[" stroke-width="1.5" stroke-opacity="0.5" opacity="1" />
		    --     </svg>
		    -- ]]
		    -- --
    

      --   	self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end) --svgCreateRoundedRectangle(self.w, self.h, self.rounded, tocolor(255,255,255, 0), 1.5,  self.colorbackground)
      --   	setTimer(function() self.update = true end, 100, 1)
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