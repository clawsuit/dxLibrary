function dxList( x, y, w, h, parent, rounded)
	
	local self, element = createElement( 'dxList', parent, sourceResource )
	if self then
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.parent = parent

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = back.listbackground
		self.colortext = back.listtext
		self.colorrectangle = back.listrectangle
		self.colorrectangle2 = back.listrectangle2

		self.colorselected = front.listselected

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.font = Files['font']['Basic-Regular'][10]
        self.fontH = dxGetFontHeight( 1, self.font )
        --
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
		table.insert(self.items, item)
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
		return self.selected, self.items[self.selected]
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

