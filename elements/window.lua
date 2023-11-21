function dxWindow(x, y, w, h, title, closebutton, rounded, border, colorbackground, colortitle, colorborder)

	local self, element = createElement('dxWindow', false, sourceResource)
	if self then

		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.title = title
		self.closebutton = (closebutton == nil and true) or (closebutton == false and false) or (closebutton == true and true)
		self.rounded = tonumber(rounded) or rounded == true and 10 or false
		
		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorbackground or back.windowbackground
		self.colortitle = colortitle or back.windowtitle
		self.colorborder = colorborder or front.windowborder

		self.border = border
		self.rendertarget = DxRenderTarget(self.w, self.h, true)
		self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        if tonumber(self.rounded) then
        	local rawSvgData = svgCreateRoundedRectangle(self.w, self.h, self.rounded, self.colorbackground, border,  border and self.colorborder or false)
        	self.svg = svgCreate(self.w, self.h, rawSvgData, function() self.update = true end)
        else
        	self.update = true
        end

        return element

	end

end

function dxWindowGetCloseState( element )
	local self = Cache[element]
	if self then
		return self.closebutton
	end
end

function dxWindowSetCloseState( element, bool )
	local self = Cache[ element ]
	if self then
		self.closebutton = bool
		return true
	end
end


--bindKey('m', 'down', function() showCursor(not isCursorShowing()) end)