function dxScrollPane( x, y, w, h, parent, colorbackground)
	
	local self, element = createElement( 'dxScrollPane', parent, sourceResource )
	if self then
		 
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.parent = parent
        
        --self.rendertarget = DxRenderTarget(self.w, self.h, true)

        self.scrollV = dxScroll(self.x+self.w-math.round(17*sh), self.y, self.h, true, parent)
        self.scrollH = dxScroll(self.x, self.y+self.h-math.round(17*sh), self.w-math.round(17*sh), false, parent)

        Cache[self.scrollH].isVisible = false
        Cache[self.scrollV].isVisible = false
        Cache[self.scrollV].attached = element

        self.w = math.round(w-math.round(17*sh))
        self.h = math.round(h-math.round(17*sh))

        self.colorbackground = colorbackground or tocolor(255,255,255,0)

        self.scrollX = 0
        self.scrollY = 0

        if self.parent then
            self.offsetX = self.x - Cache[self.parent].x
            self.offsetY = self.y - Cache[self.parent].y
        end

        --Timer(function() self.update = true end, 1200, 1)

        return element
	end
end

