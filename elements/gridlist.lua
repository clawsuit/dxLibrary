function dxGridList( x, y, w, h, parent, colorback, colortext, colorselected, colorLine, colorScrollBack, colorScrollBoton, colorScrollText)
	
	local self, element = createElement( 'dxGridList', parent, sourceResource )
	if self then
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.parent = parent

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorback or back.gridlistbackground
		self.colortext = colortext or back.gridlisttext
		self.colorselected = colorselected or front.gridlistselected
		self.colorLine = colorLine or tocolor(35, 35, 45, 255)
		
		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.font = Files['font']['Basic-Regular'][10]
        self.fontH = dxGetFontHeight( 1, self.font )
        --
  		self.scrollV = dxScroll(self.x+self.w-math.round(17*sh), self.y, self.h, true, parent, false, colorScrollBack, colorScrollBoton, colorScrollText)
  		self.scrollH = dxScroll(self.x, self.y+self.h-math.round(17*sh), self.w-math.round(17*sh), false, parent, false, colorScrollBack, colorScrollBoton, colorScrollText)

  		Cache[self.scrollH].isVisible = false
  		Cache[self.scrollV].isVisible = false
  		Cache[self.scrollV].attached = element
  		Cache[self.scrollH].attached = element

  		-- Cache[self.scrollH].subParent = element
  		-- Cache[self.scrollV].subParent = element

        self.from = nil
        self.to = nil
        self.mul = 0

		self.columns = {}
        self.items = {}
        self.colorItems = {}

        self.scrollX = 0
        self.scrollY = 0
        --
        self.selected = -1
        self.update = true
        Timer(function() self.update = true end, 600, 2)
        --Timer(function() self.update = true end, 1200, 1)

        return element
	
	end
end

function dxGridListClear(element)
	local self = Cache[element]
	if self then
		self.items = {}
		self.colorItems = {}
		self.update2 = true
		return true
	end
end

function dxGridListFindItem(element, column, item)
	local self = Cache[element]
	if self then
		for i, v in ipairs(self.items) do
			if v[column] == item then
				return i,v
			end
		end
	end
	return false
end

function dxGridListAddItem(element, ...)
	local self = Cache[element]
	if self then
		table.insert(self.items, {...})
		table.insert(self.colorItems, {255,255,255})
		self.update2 = true
		return #self.items
	end
	return false
end

function dxGridSetItemColor(element, row, r, g, b)
	local self = Cache[element]
	if self then
		if tonumber(row) and self.colorItems[row] then
			self.colorItems[row] = {r,g,b}
		end
	end
end

function dxGridListSetItemData(element, row, key, value)
	local self = Cache[element]
	if self then
		if self.items[row] then
			self.items[row][key] = value
		end
	end
end

function dxGridListGetItemData(element, row, key)
	local self = Cache[element]
	if self then
		if self.items[row] then
			return self.items[row][key]
		end
	end
	return false
end

function dxGridListRemoveItem(element, index)
	local self = Cache[element]
	if self then
		if self.items[index] then
			table.remove(self.items, index)
			table.remove(self.colorItems, index)
			self.update2 = true
			return true
		end
	end
	return false
end

function dxGridListAddColumn(element, name, size, alingX)
	local self = Cache[element]
	if self then
		table.insert(self.columns, {name, size, alingX or 'left'})
		self.update = true
		return #self.columns
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
		return self.selected, self.items[self.selected]
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

function dxGridListGetScrollHV(element)
	local self = Cache[element]
	if self then
		return self.scrollH, self.scrollV
	end
	return false
end


  		
