# dxLibrary
Modern Library For MTA

## For More Information :heavy_check_mark:
> https://wiki.multitheftauto.com/wiki/Modern-Library
## Usage Example :heavy_check_mark:
```lua
loadstring(exports.dxlib:dxGetLibrary())()

local sx, sx, x, y = dxGetScreen(1366, 768)
dxFont('files/font/letterbold.otf', 12, true)

win = dxWindow(251 * x, 21 * y, 783 * x, 635 * y, 'Window DEMO', false, true)
dxSetFont(win, 'letterbold', 12)

bot = dxButton(276 * x, 80 * y, 100 * x, 40 * y, 'Button demo', win, false)
bot2 = dxButton(276 * x, 126 * y, 100 * x, 40 * y, 'Button demo 2', win, true)

bar = dxProgressBar(312 * x, 583 * y, 295 * x, 41 * y, win, false)

scrollH = dxScroll(302 * x, 317 * y, 677 * x, false, win, true)
scrollV = dxScroll(277 * x, 317 * y, 317 * y, true, win, false)

edit1 = dxEdit(277 * x, 184 * y, 197 * x, 46 * y, 'edit demo 1', win, false)
edit2 = dxEdit(277 * x, 240 * y, 197 * x, 46 * y, 'edit demo 2', win, false)

check1 = dxCheckBox(432 * x, 83 * y, 32 * x, 32 * x, win)
check2 = dxCheckBox((432+40) * x, 83 * y, 32 * x, 32 * x, win, true)

list1 = dxList( 312 * x, 347 * y, 250 * x, 203 * y, win)

for i = 1, 20 do
  dxListAddItem(list1, 'Row '..i)
end

list2 = dxGridList( 588 * x, 349 * y, 351 * x, 120 * y, win)

for _, c in ipairs({{'Vehicle', 2}, {'Owner', 2}, {'Price', 3}}) do
  dxGridListAddColumn(list2, c[1], c[2])
end

for _, v in ipairs({{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Boy', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Boy', '5000200'},{'Infernus', 'Claw', '50000'}, {'Sultan', 'Pand', '500000'}, {'Towtruck', 'Boy', '5000200'}}) do
  dxGridListAddItem(list2, unpack(v))
end
```
