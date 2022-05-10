local TEST = false


if TEST then

	addEventHandler( "onClientResourceStart", resourceRoot,
		function()
			local sx, sx, x, y = dxGetScreen(1366, 768)

			dxFont('files/font/letterbold.otf', 12, true)
			
			showCursor(true)

			win = dxWindow(251*x, 21*y, 783*x, 635*y, 'Window DEMO', false, true)
			dxSetFont(win, 'letterbold', 12)

			bot = dxButton(276*x, 80*y, 100*x, 40*y, 'Button demo', win, false)
			bot2 = dxButton(276*x, 126*y, 100*x, 40*y, 'Button demo 2', win, false)

			bar = dxProgressBar(312*x, 583*y, 295*x, 41*y, win, false)

			scrollH = dxScroll(302*x, 317*y, 677*x, false, win, true)
			scrollV = dxScroll(277*x, 317*y, 317*y, true, win, false)

			edit1 = dxEdit(277*x, 184*y, 197*x, 46*y, 'edit demo 1', win, false)
			edit2 = dxEdit(277*x, 240*y, 197*x, 46*y, 'edit demo 2', win, false)

			sex = dxCheckBox(432*x, 83*y, 32*x, 32*x, win)
			sex1 = dxCheckBox((432+40)*x, 83*y, 32*x, 32*x, win, true)

			-----
			list1 = dxList( 312*x, 347*y, 250*x, 203*y, win)

			for i = 1, 20 do
	        	dxListAddItem(list1, 'Row '..i)
	        end
			-----

			---------
			list2 = dxGridList( 588*x, 349*y, 351*x, 120*y, win)

			for _, c in ipairs({{'Vehiculo', 2}, {'Dueño', 2}, {'Costo', 3}}) do
				dxGridListAddColumn(list2, c[1], c[2])
			end

			for _, v in ipairs({{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'}}) do
				dxGridListAddItem(list2, unpack(v))
			end
			---------

			

			label1 = dxLabel(251*x, 50*y, (783+251)*x, 17+(50*y), 'Label DEMO', win, 'center', 'center')
			dxSetFont(label1, 'letterbold', 10)

			img1 = dxImage(561*x, 92*y, 116*x, 92*y, ":admin/client/images/map.png", win)
			img2 = dxImage(561*x, (92*2 + 5)*y, 116*x, 92*y, ":admin/client/images/map.png", win)
			
			

			addEventHandler( "onClick", root, sexo )

		end
	)

	function sexo()
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
		elseif source == bot then
			outputChatBox( "Button 1", 255, 255, 255 )
			iprint( dxWindowGetCloseState( win ) )
		end
	end

end


