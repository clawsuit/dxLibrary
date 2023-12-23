local TEST = false


if TEST then

	bindKey('m', 'down', function() showCursor(not isCursorShowing()) end)
	local panes = {}
	addEventHandler( "onClientResourceStart", resourceRoot,
		function()
			local sx, sy, x, y = dxGetScreen(1366, 768)

			dxSetTheme(2, 2)

			dxFont('files/font/letterbold.otf', 12, true)
		 	
			--showCursor(true)
			--win = dxScrollPane(251*x, 21*y, 783*x, 635*y)
			win = dxWindow(251, 21*y, 783*x, 635*y, 'Window DEMO', true, true)

			do

				local x, w = sx/2, 783
				local y, h = sy/2, 635
		
				dxAddAnimation(win, 'Linear', 2000, [[
		
					local x,w = ]]..x..[[, ]]..w..[[
		
					-- self.w = w * progress
					-- self.x = interpolateBetween(x, 0, 0, 251, 0, 0, progress, 'Linear')
					self.alpha = 255 * progress
	
		
				]]
				, false, {
					postFun = function(ele)
						dxAddAnimation(ele, 'Linear', 2000, [[
		
							local x,w = ]]..x..[[, ]]..w..[[
							
							-- self.w = w * progress
							-- self.x = interpolateBetween(x, 0, 0, 251, 0, 0, progress, 'Linear')
							self.alpha = 255 * progress
				
						]], true, {
								cancelCloseButton = true,
								postFun = dxSetVisible,
								false
							}
						)
					end,
				}
				)
			end

			--tabpanel = dxTabPanel(281*x, 170*y, 500*x, 400*y, win, true, false, 80*x)
			tabpanel = dxTabPanel(281*x, 170*y, 500*x, 400*y, win, true, false, 100*x)
			

			for _, c in ipairs({{'Opcions'}, {'Botones', false, false}, {'Listas'}, {'Images'}}) do
				panes[_] = dxAddTab(tabpanel, c[1], c[2], c[3], c[4])
			end

			radioB = dxRadioButton(290*x, 220*y, 'Modo de dia', panes[3])
			radioB2 = dxRadioButton(290*x, 245*y, 'Modo de tarde', panes[3])
			radioB3 = dxRadioButton(290*x, 270*y, 'Modo de noche', panes[3])
			
			list2 = dxGridList( 373*x, 180*y, 380*x, 150*y, panes[1])
			--list2 = dxGridList( 1250*x, 800*y, 380*x, 150*y, win)
			bot = dxButton(1300*x, (80+149)*y, 100*x, 40*y, 'Button demo', win, true)

			--if true then return end

			for _, c in ipairs({{'Vehiculo', 2, true}, {'Dueño', 2}, {'Costo', 1}}) do
				dxGridListAddColumn(list2, c[1], c[2])
			end

			for _, v in ipairs({{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'}}) do
				dxGridListAddItem(list2, unpack(v))
			end

			--bot = dxButton(380*x, (80+149)*y, 100*x, 40*y, 'Button demo', panes[2], true)
			bot2 = dxButton(400*x, (126+149)*y, 100*x, 40*y, 'Button demo 2', panes[3], false)

			-- sex = dxCheckBox(270*x, 120*y, 26*x, 26*x, win)
			-- sex1 = dxCheckBox((270+40)*x, 120*y, 26*x, 26*x, win, true)

			edit1 = dxEdit(400*x, 40*y, 150*x, 35*y, 'edit demo 1', win, true)
			edit2 = dxEdit(400*x, 100*y, 150*x, 35*y, 'edit demo 2', win, false)

			list1 = dxList( 392*x, 347*y, 250*x, 203*y, panes[3])
			--dxTabPanelSetSelected(tabpanel, panes[3])


			bar = dxProgressBar(283*x, 596*y, 270*x, 38*y, win, true)

			label1 = dxLabel(282, 212, 780, 226, 'Label DEMO', panes[2], 'center', 'center')
			dxSetFont(label1, 'letterbold', 10)

			for i = 1, 20 do
	        	dxListAddItem(list1, 'Row '..i)
	        end

	        img1 = dxImage(439*x, 186*y, 222*x, 132*y, ":admin/client/images/map.png", panes[4])
			img2 = dxImage(439*x, 419*y, 222*x, 132*y, ":admin/client/images/map.png", panes[4])

			addEventHandler( "onClick", root, _fEvent )

			dxSwitchButton(570*x, 600*y, 50*x, 26*y, win)

			--if true then return end
			

			scrollH = dxScroll(302*x, 317*y, 317*x, false, win, true)
			scrollV = dxScroll(277*x, 317*y, 317*x, true, win, false)	

		end
	)

	local lala = false
	bindKey('k', 'down',
		function()
			lala = not lala
			dxSetRounded(scrollV, lala and 10 or false)
		end
	)



	function _fEvent()
		if source == sex then
		 	if dxGet(source, 'state') then
		 		dxSet(edit1, 'text', math.random(100000, 999999)..'')
		 	else
		 		dxSet(edit1, 'text', '')
		 	end
		elseif source == sex1 then
			if dxGet(source, 'state') then
		 		dxImageApplyMask(img2, "files/image/circle_mask.png")
		 	else
		 		dxImageRemoveMask(img2)
		 	end
		elseif source == bot2 then
			outputChatBox( "Button 2", 255, 255, 255 )
			--iprint( dxRadioButtonGetSelected( radioB ) )
			iprint( dxRadioButtonGetSelected( radioB2 ) )
			--destroyElement( win )
		end
	end

end

-- addEventHandler('onClientResourceStart', resourceRoot,
-- 	function()
		
-- 		local x, w = sx/2, 783
-- 		local y, h = sy/2, 635
-- 		--local win = dxWindow(x, x, w, h, 'Window DEMO', false, true)

-- 		dxAddAnimation(win, 'Linear', 2000, [[

-- 			local x,w = ]]..x..[[, ]]..w..[[
-- 			local y,h = ]]..y..[[, ]]..h..[[

-- 			self.w = w * progress
-- 			self.x = x - (w * progress)/2

-- 			self.h = h * progress
-- 			self.y = y - (h * progress)/2

-- 		]])
-- 	end
-- )


