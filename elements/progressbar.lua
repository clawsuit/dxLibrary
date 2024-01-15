
function dxProgressBar(x, y, w, h, parent, rounded, colorbackground, colorprogress, colortext)

	local self, element = createElement('dxProgressBar', parent, sourceResource)
	if self then

		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.rounded = tonumber(rounded) or rounded == true and 4 or false

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorbackground or back.progressbarbackground
		self.colorprogress = colorprogress or front.progressbarprogress
		self.colortext = colortext or back.progressbartext
		--
		self.from = 0
		self.to = 0
		--
		self.progress = 0
		self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )
		--
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

function dxProgressBarSetProgress(element, progress)
	local self = Cache[element]
	if self then

		self.from = self.progress
		self.to = math.min(100, math.max(0, progress))
		self.tick = getTickCount(  )

		return true
	end
	return false
end

function dxProgressBarGetProgress(element, progress)
	local self = Cache[element]
	if self then
		return self.progress
	end
	return false
end

function dxProgressBarSetColor(element, r, g, b, a)
	local self = Cache[element]
	if self then
		self.colorprogress = tocolor(r, g, b, a)
		return true
	end
	return false
end