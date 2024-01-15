function Render.dxMemo(element, parent, offX, offY)
	local self = Cache[element]
	if self then

		if not self.isVisible then
			return
		end

		local x, y, x2, y2 = self.x, self.y, self.x, self.y
		if isElement(parent) then
			x, y = self.offsetX, self.offsetY
			--
			if x2 ~= (Cache[parent].x + x) or y2 ~= (Cache[parent].y + y) then
                x2, y2 = Cache[parent].x + x, Cache[parent].y + y
                self.x, self.y = x2, y2
            end
		end

		x, y = x + (offX or 0), y + (offY or 0)
		x2, y2 = x2 + (offX or 0), y2 + (offY or 0)
		
		local color = self.colorborder
		local postgui
		if self.postgui then
			if not isElement(self.parent) then
				postgui = true
			end
		end

        --self.webBrowser:executeJavascript("cefSetMemoState('"..toJSON({key=tostring(element), property='left', value = x2..'px'}).."')")
        --self.webBrowser:executeJavascript("cefSetMemoState('"..toJSON({key=tostring(element), property='top', value = y2..'px'}).."')")

        dxDrawImage(x, y, self.w, self.h, self.webBrowser, 0, 0, 0, tocolor(255,255,255,self.alpha), postgui)
    end 
end


addEventHandler("onClientClick", root,
	function(button, state)
		if not isElement(onMemo) then return end
		local self = Cache[onMemo]
		if not self.isDisabled and self.isVisible and (not isElement(self.parent) or Cache[self.parent].isVisible) and (not isElement(self.rootParent) or Cache[self.rootParent].isVisible) and (not isElement(self.attached) or Cache[self.attached].isVisible) then
			if self.webBrowser:isFocused() and isCursorShowing() then
				if state == "down" then
					self.webBrowser:injectMouseDown(button)
				else
					self.webBrowser:injectMouseUp(button)
				end
			end
		end
	end
)

addEventHandler("onClientCursorMove", root,
	function (relativeX, relativeY, absoluteX, absoluteY)
		if not isElement(onMemo) then return end
		local self = Cache[onMemo]
		if not self.isDisabled and self.isVisible and (not isElement(self.parent) or Cache[self.parent].isVisible) and (not isElement(self.rootParent) or Cache[self.rootParent].isVisible) and (not isElement(self.attached) or Cache[self.attached].isVisible) then
			if self.webBrowser:isFocused() and isCursorShowing() then
				self.webBrowser:injectMouseMove(absoluteX-self.x, absoluteY-self.y)
			end
		end
	end
)

addEventHandler("onClientKey", root,
	function(button)
		if not isElement(onMemo) then return end
		local self = Cache[onMemo]
		if not self.isDisabled and self.isVisible and (not isElement(self.parent) or Cache[self.parent].isVisible) and (not isElement(self.rootParent) or Cache[self.rootParent].isVisible) and (not isElement(self.attached) or Cache[self.attached].isVisible) then
			if self.webBrowser:isFocused() and isCursorShowing() then
				if button == "mouse_wheel_down" then
					self.webBrowser:injectMouseWheel(-50, 0)
				elseif button == "mouse_wheel_up" then
					self.webBrowser:injectMouseWheel(50, 0)
				end
			end
		end
	end
)


addEvent('onGeneralEvent')
addEventHandler('onGeneralEvent', root,
	function(event, key, ...)
		local arg = {...}
		if event == 'onChange' then
            local memo = memoCreated[key]
            if isElement(memo) then
                if Cache[memo].webBrowser:isFocused() then
					if not Cache[memo].isDisabled and Cache[memo].isVisible and (not isElement(Cache[memo].parent) or Cache[Cache[memo].parent].isVisible) and (not isElement(Cache[memo].rootParent) or Cache[Cache[memo].rootParent].isVisible) and (not isElement(Cache[memo].attached) or Cache[Cache[memo].attached].isVisible) then
                		Cache[memo].text = arg[1]
                	end
				end
            end
		end
	end
)