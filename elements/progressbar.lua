
function dxProgressBar(x, y, w, h, parent, rounded)

	local self, element = createElement('dxProgressBar', parent, sourceResource)
	if self then

		self.x = x
		self.y = y
		self.w = w
		self.h = h
		self.rounded = rounded and 4 or false

		self.colorbackground = tocolor(25, 25, 35, 255)
		self.colorprogress = tocolor(120, 95, 205, 255)
		--
		self.from = 0
		self.to = 50
		--
		self.progress = 50
		
		if self.parent then
 
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y

        end

        if tonumber(self.rounded) then
        	self.svg = svgCreateRoundedRectangle(self.w, self.h, self.rounded, tocolor(255,255,255), border,  border and tocolor(255,255,255) or false)
        	setTimer(function() self.update = true end, 100, 1)
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


addCommandHandler('progress',
	function(_, num)

		dxProgressBarSetProgress(bar, tonumber(num))

	end
)