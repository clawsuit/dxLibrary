memoCreated = {}

function dxMemo(x, y, w, h, title, parent, rounded, readonly, colorbackground, colortext)

	local self, element = createElement('dxMemo', parent, sourceResource)
	if self then

		self.x = math.round(x)
		self.y = math.round(y)
		self.w = math.round(w)
		self.h = math.round(h)

        self.currentX = self.x
        self.currentY = self.y

		self.title = title
		self.rounded = tonumber(rounded) or rounded == true and 13 or false

		self.text = ''
        memoCreated[tostring(element)] = element

		local back = dxLibraryThemes['back'][dxLibraryThemeBackSelected]
        local front = dxLibraryThemes['front'][dxLibraryThemeFrontSelected]

		self.colorbackground = colorbackground or back.editbackground
		self.colortext = colortext or back.edittitle
		--
		self.readonly = readonly or false
		self.maxCharacters = nil
		--
        self.font = Files['font']['Basic-Regular'][10]
		self.fontH = dxGetFontHeight( 1, self.font )

		if self.parent then
			self.offsetX = self.x - Cache[self.parent].x
        	self.offsetY = self.y - Cache[self.parent].y
        end

        self.webBrowser = createBrowser(self.w, self.h, true, true)
        addEventHandler("onClientBrowserCreated", self.webBrowser, 
            function()
                source:loadURL("http://mta/"..resource.name.."/cef/cef.html");
            end
        )

		local json = {
			key = tostring(element),
			x = 0,
			y = 0,
			w = self.w,
			h = self.h,
			title = title,
			rounded = rounded,
			readonly = readonly,
			text = self.text,
			background = 'rgba('..table.concat({colorToRgba(self.colorbackground)}, ', ')..')',
			colortext = 'rgba('..table.concat({colorToRgba(self.colortext)}, ', ')..')',
		}

        addEventHandler("onClientBrowserDocumentReady", self.webBrowser,
            function ()
				self.ready = true
			   	source:executeJavascript("cefMemo('"..toJSON(json).."')")
				dxSetText(element, self.text)
            end
        )
  	
        return element
	end
end

function dxMemoSetReadOnly(element, readonly)
	local self = Cache[element]
	if self then	

		self.readonly = readonly
		cefSetProperty(element, 'readonly', self.readonly and "true" or "false")

		return true
	end
	return false
end

-- addEventHandler('onClientResourceStart', root,
-- 	function()
-- 		memo1 = dxMemo(451, 80, 300, 300, 'escribe aqui tus notas !!!', win, 10, true, tocolor(20,20,20), tocolor(255,255,255))
-- 		dxSetText(memo1, 'holanda')
-- 	end
-- )

-- local bool = true
-- bindKey('k', 'down',
-- 	function()
-- 		-- bool = not bool
-- 		-- dxMemoSetReadOnly(memo1, bool)
-- 		-- print(bool, 'ola', math.random(999))

-- 		dxSetProperty(memo1, 'colortext', tocolor(math.random(255),math.random(255),math.random(255)))
-- 	end
-- )
-- --

-- addCommandHandler('cambio', 
-- 	function(cmd, o)
-- 		dxSetRounded(memo1, tonumber(o))
-- 	end
-- )
