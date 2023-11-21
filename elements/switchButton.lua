function dxSwitchButton(x, y, w, h, parent, colorbackground, colorOn, colorOff)
	
	local self, element = createElement( 'dxSwitchButton', parent, sourceResource )
	if self then
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.min(math.round(w), math.round(53*sw))
		self.h = math.min(math.round(h), math.round(23*sh))
		self.parent = parent

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorbackground or back.switchbuttonbackground
		self.colorOn = colorOn or front.switchbuttonOn
		self.colorOff = colorOff or front.switchbuttonOff
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.bx = 0
        self.state = false
      	self.update = true
        return element
	
	end
end
 
function dxSwitchButtonSetState(element, bool)
	local self = Cache[element]
	if self then
		self.state = bool
		self.tick = getTickCount()
		self.update = true
		return true
	end
	return false
end

function dxSwitchButtonGetState(element)
	local self = Cache[element]
	if self then
		return self.state
	end
	return false
end

function dxSwitchButtonSetColorOn(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colorOn = tocolor(r, g, b, a)
		self.update = true
		return true
	end
	return false
end

function dxSwitchButtonSetColorOff(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colorOff = tocolor(r, g, b, a)
		self.update = true
		return true
	end
	return false
end