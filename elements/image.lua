function dxImage( x, y, w, h, path, parent,colorformat, mipmaps, textureType)
	
	local self, element = createElement( 'dxImage', parent, sourceResource )
	if self then
		
		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)
		self.path = path
		self.parent = parent
		
		self.texture = DxTexture(path, (colorformat or "dxt5"), (mipmaps or true), (textureType or "clamp") )
		self.colorbackground = -1

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end
        
        self.update = true
        return element
	
	end
end

function dxImageApplyMask(element, path)
	local self = Cache[element]
	if self then

		if not isElement( self.shader ) then
			self.shader = DxShader("files/fx/hud_mask.fx")
			self.shader:setValue("sPicTexture", self.texture)
		end

		if isElement(self.textureMask) then
			self.textureMask:destroy()
		end

		self.textureMask = DxTexture((path or "files/image/circle_mask.png"), "dxt5", false, "clamp" )
		self.shader:setValue("sMaskTexture", self.textureMask)

		return true
	end
	return false
end

function dxImageRemoveMask(element)
	local self = Cache[element]
	if self then

		if isElement( self.shader ) then
			self.shader:destroy()
			self.shader = nil
		end

		if isElement(self.textureMask) then
			self.textureMask:destroy()
			self.textureMask = nil
		end

		return true
	end
	return false
end
