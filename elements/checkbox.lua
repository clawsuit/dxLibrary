function dxCheckBox( x, y, w, h, parent, rounded)
	
	local self, element = createElement( 'dxCheckBox', parent, sourceResource )
	if self then
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.parent = parent

		self.colorbackground = tocolor( 25, 25, 35, 255 )
		self.colorborder = tocolor( 51, 33, 112, 255 )
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.font = Files['font']['Basic-Regular'][10]
        self.fontH = dxGetFontHeight( 1, self.font )
        --
        self.style = 1
        self.text = ""
        self.state = false

        if rounded then
  			local rawSvg = [[<svg width="]]..(self.w)..[[" height="]]..(self.h)..[["> <circle cx="]]..((self.w)/2)..[[" cy="]]..((self.h)/2)..[[" r="]]..((self.w)/2)..[[" stroke="rgb(51, 33, 112)" fill="rgb(25, 25, 35)" stroke-width="1"></circle> </svg> ]]
  			self.svg = svgCreate(self.w, self.h, rawSvg, function() self.update = true end)
  		else
  			self.update = true
  		end

        return element
	
	end

end

function dxCheckBoxSetState(element, bool)
	local self = Cache[element]
	if self then	
		self.state = bool
		self.update = true
		return true
	end
	return false
end

function dxCheckBoxGetState(element, bool)
	local self = Cache[element]
	if self then	
		return self.state
	end
	return false
end

function dxCheckBoxSetStyle(element, style)
	local self = Cache[element]
	if self then
		if checkBoxTypes[style] then
            self.style = style	
			self.update = true
			return true
		end
	end
	return false
end