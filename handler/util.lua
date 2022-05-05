Cache = {}
Render = {}

Files = {}
checkBoxTypes = {'✔', '●', '✕'}
ElementTypeChildrenAvailable = {['dxWindow'] = true}

filesAvailables = {
    {'Basic-Regular.ttf', {10, false}, {11, true}},
    --'boton.png',
}

sx, sy = GuiElement.getScreenSize(  )
sw, sh = sx/1366, sy/768

addEventHandler( "onClientResourceStart", resourceRoot,
    function()
        for k, v in pairs(filesAvailables) do

            if type(v) == 'table' then
                if fileExists( 'files/font/'..v[1] ) then

                    Files['font'] = Files['font'] or {}
                    Files['font'][v[1]] = {}
                    --
                    for i = 2, #v do
                        Files['font'][v[1]][v[i][1]] = DxFont('files/font/'..v[1], v[i][1], v[i][2] )
                    end

                end
            else
                if fileExists( 'files/image/'..v[1] ) then

                    Files['image'] = Files['image'] or {}
                    Files['image'][v:sub(1, v:find('.')-1)] = DxTexture('files/image/'..v[1], 'argb', false, 'clamp')

                end
            end

        end

        fontH = dxGetFontHeight( 1, Files['font']['Basic-Regular.ttf'][10] )
    end
)

-- local rawSvg = [[
--     <svg width="64" height="64" viewBox="0 0 20 20" fill="#ffffff" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M13.354 3.646a.5.5 0 010 .708L7.707 10l5.647 5.646a.5.5 0 01-.708.708l-6-6a.5.5 0 010-.708l6-6a.5.5 0 01.708 0z" clip-rule="evenodd"/>
-- </svg>
-- ]]
-- Flecha = svgCreate(64, 64, rawSvg, function()  end)


function svgCreateRoundedRectangle(width, height, ratio, color1, borderWidth, color2)
    local r,g,b,a = bitExtract(color1,16,8),bitExtract(color1,8,8), bitExtract(color1,0,8), bitExtract(color1,24,8)
    local _color1 = string.format("#%.2X%.2X%.2X", r,g,b)
    --
    local r2,g2,b2,a2 = bitExtract((color2 or color1),16,8),bitExtract((color2 or color1),8,8), bitExtract((color2 or color1),0,8), bitExtract((color2 or color1),24,8)
    local _color2 = string.format("#%.2X%.2X%.2X", r2,g2,b2)
    --
    local rawSvgData = [[
        <svg width="]]..(width+0)..[[" height="]]..(height+0)..[[">
            <rect x="0" y="0" rx="]]..ratio..[[" ry="]]..ratio..[[" width="]]..(width-0)..[[" height="]]..(height-0)..[["
            fill="]].._color1..[[" stroke="]].._color2..[[" stroke-width="]]..(borderWidth or 0)..[[" stroke-opacity="]]..(a2/255)..[[" opacity="]]..(a/255)..[[" />
        </svg>
    ]]
    --
    return svgCreate(width, height, rawSvgData)
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

function DxDrawBorderedRectangle( x, y, width, height, color1, color2, _width, postGUI )
    local _width = _width or 1
    dxDrawRectangle ( x+1, y+1, width-1, height-1, color1, postGUI )
    dxDrawLine ( x, y, x+width, y, color2, _width, postGUI ) -- Top
    dxDrawLine ( x, y, x, y+height, color2, _width, postGUI ) -- Left
    dxDrawLine ( x, y+height, x+width, y+height, color2, _width, postGUI ) -- Bottom
    dxDrawLine ( x+width, y, x+width, y+height, color2, _width, postGUI ) -- Right
end

function dxGetScreen( x, y )
    return sx, sy, sx/(x or sx), sy/(y or sy)
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

function dxDrawBorderedText (outline, text, left, top, right, bottom, color, color2, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText (text, left + oX, top + oY, right + oX, bottom + oY, color2, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end