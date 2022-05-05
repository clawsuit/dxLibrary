addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		showCursor(true)

		win = dxWindow(251, 21, 783, 635, 'Window DEMO', false, true)
		bot = dxButton(277, 126, 100, 40, 'Button DEMO 2', win, true)
		bot2 = dxButton(276, 80, 100, 40, 'Button DEMO', win, true)
		bar = dxProgressBar(312, 583, 295, 41, win, false)

		scrollH = dxScroll(302, 317, 677, false, win, true)
		scrollV = dxScroll(277, 317, 317, true, win, false)

		edit1 = dxEdit(277, 184, 197, 46, 'edit memo 1', win, false)
		edit2 = dxEdit(277, 240, 197, 46, 'edit memo 2', win, false)

		sex = dxCheckBox(432, 83, 32, 32, win)
		sex1 = dxCheckBox(432+40, 83, 32, 32, win, true)

		-----
		list1 = dxList( 312, 347, 250, 203, win)

		for i = 1, 20 do
        	dxListAddItem(list1, 'Row '..i)
        end
		-----

		---------
		list2 = dxGridList( 588, 349, 351, 120, win)

		for _, c in ipairs({{'Vehiculo', 2}, {'Dueño', 2}, {'Costo', 3}}) do
			dxGridListAddColumn(list2, c[1], c[2])
		end

		for _, v in ipairs({{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Bert', '5000200'}}) do
			dxGridListAddItem(list2, unpack(v))
		end
		---------

		label1 = dxLabel(251, 50, 783+251, fontH+50, 'Label DEMO', win, 'center', 'center')

		img1 = dxImage(561, 92, 116, 92, ":admin/client/images/map.png", win)
		img2 = dxImage(561, 92*2 + 5, 116, 92, ":admin/client/images/map.png", win, true)
		
		

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
	end
end


