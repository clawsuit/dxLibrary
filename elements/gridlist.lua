function dxGridList( x, y, w, h, parent)
	
	local self, element = createElement( 'dxGridList', parent, sourceResource )
	
	if self then
		
		self.x = x 
		self.y = y
		self.w = w
		self.h = h
		self.parent = parent

		self.colorbackground = tocolor( 20, 20, 30, 255 )
		self.colortext = tocolor(255, 255, 255, 255)
		self.colorselected = tocolor(120, 95, 205, 255)
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

  		self.scrollV = dxScroll(x+w-17*sw, y, h, true, parent)
  		self.scrollH = dxScroll(x, y+h-17*sh, w-17*sw, false, parent)

  		Cache[self.scrollH].isVisible = false
  		Cache[self.scrollV].isVisible = false
  		Cache[self.scrollV].gridlist = element

        self.from = nil
        self.to = nil
        self.mul = 0

		self.columns = {}
        self.items = {}

        self.scrollX = 0
        self.scrollY = 0
        --
        self.selected = -1

        self.update = true

        return element
	
	end

end

function dxGridListAddItem(element, ...)
	local self = Cache[element]
	if self then
		table.insert(self.items, {...})
		self.update2 = true
		return true
	end
	return false
end

function dxGridListRemoveItem(element, index)
	local self = Cache[element]
	if self then
		if self.items[index] then
			table.remove(self.items, index)
			self.update2 = true
			return true
		end
	end
	return false
end

function dxGridListAddColumn(element, name, size)
	local self = Cache[element]
	if self then
		table.insert(self.columns, {name, size})
		self.update = true
		return name
	end
	return false
end

function dxGridListRemoveColumn(element, name)
	local self = Cache[element]
	if self then
		local index = table.find(self.columns, 1, name)
		if index then
			table.remove(self.columns, index)
			self.update = true
			return true
		end
	end
	return false
end

function dxGridListGetItemSelected(element)
	local self = Cache[element]
	if self then
		return self.selected
	end
	return false
end

function dxGridListSetItemSelected(element, index)
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

