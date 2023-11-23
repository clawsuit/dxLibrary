Cache = {}
Order = {}

Render = {}
resourceFonts = {}

Files = {}
checkBoxTypes = {'✓', '•', '✕'}

dxElements = {
    defaultRounded = {
        ['dxButton'] = 6,
        ['dxEdit'] = 13,
        ['dxProgressBar'] = 4,
        ['dxTabPanel'] = 10,
        ['dxWindow'] = 10,
        ['dxMemo'] = 5,
        ['dxScroll'] = 10,
    },

    parentAvailable = {
        ['dxWindow'] = true,
        ['dxScrollPane'] = true,
        ['dxTabPanel'] = true,
        ['dxTab'] = true,
    },
}

dxElements.click = {}

filesAvailables = {
    {'Basic-Regular.ttf', {10, false}, {11, true}},
    {'letterbold.otf', {9, true}, {10, true}},
    {'Comforta_regular.ttf', {10, false}, {11, false}, {12, false}, {13, false}},
    'round.png',
    'switch.png',
}

sx, sy = GuiElement.getScreenSize(  )
sw, sh = sx/1366, sy/768

addEventHandler( "onClientResourceStart", resourceRoot,
    function()
        for k, v in pairs(filesAvailables) do

            if type(v) == 'table' then
                if fileExists( 'files/font/'..v[1] ) then

                    local name = v[1]:sub(0, v[1]:find('%.')-1)
                    Files['font'] = Files['font'] or {}
                    Files['font'][name] = {}
                    --
                    for i = 2, #v do
                        Files['font'][name][v[i][1]] = DxFont('files/font/'..v[1], v[i][1]*sw, v[i][2] )
                    end

                end
            else
                if fileExists( 'files/image/'..v ) then

                    Files['image'] = Files['image'] or {}
                    Files['image'][v:gsub('%.(%w+)','')] = DxTexture('files/image/'..v, 'argb', false, 'clamp')

                end
            end

        end

    end
)



function svgCreateRoundedRectangle(width, height, ratio, color1, borderWidth, color2)
    local r,g,b,a = bitExtract(color1,16,8),bitExtract(color1,8,8), bitExtract(color1,0,8), bitExtract(color1,24,8)
    local _color1 = string.format("#%.2X%.2X%.2X", r,g,b)
    --
    local r2,g2,b2,a2 = bitExtract((color2 or color1),16,8),bitExtract((color2 or color1),8,8), bitExtract((color2 or color1),0,8), bitExtract((color2 or color1),24,8)
    local _color2 = string.format("#%.2X%.2X%.2X", r2,g2,b2)
    --
   return [[
        <svg width="]]..(width+0)..[[" height="]]..(height+0)..[[">
            <rect x="0" y="0" rx="]]..ratio..[[" ry="]]..ratio..[[" width="]]..(width-0)..[[" height="]]..(height-0)..[["
            fill="]].._color1..[[" stroke="]].._color2..[[" stroke-width="]]..(borderWidth or 0)..[[" stroke-opacity="]]..(a2/255)..[[" opacity="1" />
        </svg>
    ]]
    --
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end


function isCursorOver(x,y,w,h)

    if isCursorShowing() then

        local sx,sy = guiGetScreenSize(  ) 
        local cx,cy = getCursorPosition(  )
        local px,py = sx*cx,sy*cy

        if (px >= x and px <= x+w) and (py >= y and py <= y+h) then

            return true

        end

    end
    return false
end

function isCursorText(x,y,w,h)

    if isCursorShowing() then

        local sx,sy = guiGetScreenSize(  ) 
        local cx,cy = getCursorPosition(  )
        local px,py = sx*cx,sy*cy
        local w,h = w-x, h-y

        if (px >= x and px <= x+w) and (py >= y and py <= y+h) then

            return true

        end

    end
    return false
end


function math.lerp(from,to,alpha)
    return from + (to-from) * alpha
end

function getAbsoluteCursorPosition()
    if isCursorShowing( ) then
        local cx, cy = getCursorPosition(  )
        return cx*sx, cy*sy
    end
end


function DxDrawBorderedRectangle( x, y, w, h, color1, color2, s, postGUI )
    local s = s or 1
    --dxDrawRectangle ( x+1, y+1, width-1, height-1, color1, postGUI )
    local x, y, w, h = x, y, w, h
    dxDrawRectangle( x, y, w, h, color1, postGUI)

    dxDrawRectangle( x, y, s, h, color2, postGUI)
    dxDrawRectangle( x+s, y, w-s*2, s, color2, postGUI)

    dxDrawRectangle( x+w-s, y, s, h, color2, postGUI)
    dxDrawRectangle( x+s, y+h-s, w-s*2, s, color2, postGUI)
end

function dxGetScreen( x, y )
    return sx, sy, sx/(x or sx), sy/(y or sy)
end

function dxFont( font, arg )
    if font and arg then
        return DxFont( font, arg )
    end
end


function table.find(t, i, f)
    --print(debug.traceback())
    if (not f) then
        f = i
        i = false
    end
    for k, v in pairs(t) do
        if i then
            if v[i] and (v[i] == f) then
                return k, v, v[i]
            end
        elseif (v == f) then
            return k, v
        end
    end
    return false
end

function table.removeValue(t, i, v)
    local index, value = table.find(t, i, v)
    if index then
        if tonumber(index) then
            table.remove(t, index)
        else
            t[index] = nil
        end
        return value
    end
end

function table.deepcopy(t)
	local known = {}
	local function _deepcopy(t)
		local result = {}
		for k,v in pairs(t) do
			if type(v) == 'table' then
				if not known[v] then
					known[v] = _deepcopy(v)
				end
				result[k] = known[v]
			else
				result[k] = v
			end
		end
		return result
	end
	return _deepcopy(t)
end

function dxDrawBorderedText (outline, text, left, top, right, bottom, color, color2, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText (text, left + oX, top + oY, right + oX, bottom + oY, color2, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end
 
function dxDrawText2(t,x,y,w,h,...)
    return dxDrawText(t,x,y,w+x,h+y,...)
end

function math.round(number, decimals)
    return tonumber(string.format(("%."..(decimals or 0).."f"), number))
end

function getLastLetterPos(str)
    local last = 0
    local f = str:find('/', last)
    while f do
        last = f+1
        if last >= #str then break end
        f = str:find('/', last)
    end
    return last
end


function colorToRgba(color)
   return bitExtract(color,16,8),bitExtract(color,8,8), bitExtract(color,0,8), bitExtract(color,24,8)
end

function RGBToHex(red, green, blue, alpha)
    if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
        return nil
    end
    if(alpha) then
        return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
    else
        return string.format("#%.2X%.2X%.2X", red,green,blue)
    end
end

function colorToHex(color)
    local red, green, blue, alpha = colorToRgba(color)
    return RGBToHex(red, green, blue)
end


function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function dxDrawRounded1(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    local segmens = 7
    local color2 = color
    dxDrawRectangle(x+radius, y+radius, width-(radius), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color2, color2, segmens, 1, postGUI)
    dxDrawRectangle(x+radius, y, width-(radius), radius, color, postGUI, subPixelPositioning) -- arriba en medio de los circles
    --dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, segmens, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)

    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color2, color2, segmens, 1, postGUI)
    dxDrawRectangle(x+radius, (y+height)-radius, width-(radius), radius, color, postGUI, subPixelPositioning) -- arriba en medio de los circles
end

function dxDrawRounded2(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    local segmens = 7
    local color2 = color
    dxDrawRectangle(x, y+radius, width-(radius), height-(radius*2), color, postGUI, subPixelPositioning)

    dxDrawRectangle(x, y, width-(radius), radius, color, postGUI, subPixelPositioning)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color2, color2, segmens, 1, postGUI)

    dxDrawRectangle(x+(width-(radius)), y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)

    dxDrawCircle(x+(width-(radius)), y+(height-radius), radius, 0, 90, color2, color2, segmens, 1, postGUI)
    dxDrawRectangle(x, y+(height-radius), width-(radius), radius, color, postGUI, subPixelPositioning)
end