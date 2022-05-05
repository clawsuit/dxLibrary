function dxImage( x, y, w, h, path, parent, rounded, colorformat, mipmaps, textureType)
	
	local self, element = createElement( 'dxImage', parent, sourceResource )
	if self then
		
		self.x = x 
		self.y = y
		self.w = w
		self.h = h
		self.path = path
		self.parent = parent
		--
		self.texture = DxTexture(path, (colorformat or "dxt5"), (mipmaps or true), (textureType or "clamp") )
		self.colorbackground = -1
		--

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end
        
		if rounded then
			self.shader = DxShader("files/fx/hud_mask.fx")
			self.textureMask = DxTexture("files/image/circle_mask.png", "dxt5", false, "clamp" )
			self.shader:setValue("sPicTexture", self.texture)
			self.shader:setValue("sMaskTexture", self.textureMask)
		end

		

        self.update = true
        return element
	
	end
end
