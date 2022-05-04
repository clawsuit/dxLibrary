function dxList( x, y, w, h, parent, rounded)
	
	local self, element = createElement( 'dxList', parent, sourceResource )
	if self then
		
		self.x = x 
		self.y = y
		self.w = w
		self.h = h
		self.parent = parent

		self.colorbackground = tocolor( 20, 20, 30, 255 )
		self.colortext = tocolor(255, 255, 255, 255)
		self.colorselected = tocolor(120, 95, 205, 255)
		self.colorrectangle = tocolor(25, 25, 35, 255)
		self.colorrectangle2 = tocolor(35, 35, 45, 255)
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.from = nil
        self.to = nil
        self.mul = 0

        self.items = {}
        self.scroll = 0
        self.selected = -1

        self.update = true
        return element
	
	end
end

function dxListAddItem(element, item)
	local self = Cache[element]
	if self then
		table.insert(self.columns, item)
		self.update = true
		return true
	end
	return false
end

function dxListRemoveItem(element, index)
	local self = Cache[element]
	if self then
		if self.items[index] then
			table.remove(self.items, index)
			self.update = true
			return true
		end
	end
	return false
end

function dxListGetItemSelected(element)
	local self = Cache[element]
	if self then
		return self.selected
	end
	return false
end

function dxListSetItemSelected(element, index)
	local self = Cache[element]
	if self then
		if index == -1 or self.items[index] then
			self.selected = index
			self.update = true
			return true
		end
	end
	return false
end

function dxListSetColorBackground(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colorbackground = tocolor(r, g, b, a)
		self.update = true
		return true
	end
	return false
end

function dxListSetColorText(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colortext = tocolor(r, g, b, a)
		self.update = true
		return true
	end
	return false
end

function dxListSetColorSelected(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colorselected = tocolor(r, g, b, a)
		self.update = true
		return true
	end
	return false
end

function dxListSetColorFilaItem(element, r, g, b, a, r2, g2, b2, a2)
	local self = Cache[element]
	if self then

		if r and g and b and a then
			self.colorrectangle = tocolor(r, g, b, a)
		end

		if r2 and g2 and b2 and a2 then
			self.colorrectangle2 = tocolor(r2, g2, b2, a2)
		end

		self.update = true
		return true
	end
	return false
end

