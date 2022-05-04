Keys = {}

KeysAvailables = {
	['mouse_wheel_up'] = true,
	['mouse_wheel_down'] = true,
}

for _key_ in pairs(KeysAvailables) do
	bindKey(_key_,"down", 
		function(_, state) 
			Keys[_key_] = state == 'down'
		end
	)
end

function isKeyPressed(key)
	return Keys[key]
end

function resetKey(key)
	if Keys[key] then
		Keys[key] = false
	end
end

_click_ = {}
function isKeyPressed2(key, ms)
	local key = key or 'mouse1'
	_click_[key] = _click_[key] or {false, getTickCount(  )};
	local yea = false

	if getTickCount(  ) - _click_[key][2] >= (ms or 50) then
		if getKeyState( key ) and not _click_[key][1] then
			_click_[key][1] = true
			_click_[key][2] = getTickCount(  )
			yea = true
		end
	end 

	if not getKeyState( key ) then
		_click_[key][1] = false
	end

	return yea
end
