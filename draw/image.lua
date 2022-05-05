function Render.dxImage(element, parent)
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		local x, y, x2, y2 = self.x, self.y, self.x, self.y
		if parent then
			x, y = self.offsetX, self.offsetY
			x2, y2 = Cache[parent].x + x, Cache[parent].y + y
		end
	
		dxDrawImage(x, y, self.w, self.h, (self.shader or self.texture), 0, 0, 0, self.colorbackground, false)

	end
end