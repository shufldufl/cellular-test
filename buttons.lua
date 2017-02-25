local buttons = {}

buttons.addDefault = function(bx,by,wid,hi,text,callback)
	local drawfunc = function(b)
		love.graphics.setColor(unpack(b.isAnimating and {0,0,0} or {220,220,220}))
		love.graphics.rectangle("fill",b.x,b.y,b.width,b.height)
		love.graphics.setColor(unpack(b.isAnimating and {255,255,255} or {0,0,0}))
		love.graphics.print(b.text,b.x,b.y+1)
	end
	buttons.add(bx,by,wid,hi,text,callback,drawfunc,3)
end

buttons.add = function(bx,by,wid,hi,text,callback,drawback,dur)
	buttons[#buttons+1] = {
		x = bx,
		y = by,
		width = wid,
		height = hi,
		callback = callback or function() end,
		drawback = drawback or function(b) 
			love.graphics.setColor(240,240,240)
			love.graphics.rectangle("fill",b.x,b.y,b.width,b.height)
			love.graphics.setColor(0,0,0)
			love.graphics.print(b.text,b.x,b.y+1)
		end,
		text = text or "",
		dur = dur or 1,
		count = 0,
		animating = false,
	}
end

buttons.flush = function()
	for i=1,#buttons do 
		buttons[i] = nil
	end
end

buttons.check = function(x,y)
	local t = false
	for _,b in ipairs(buttons) do
		if x >= b.x and x <= b.x+b.width
		and y >= b.y and y <= b.y+b.height then
			if not b.isAnimating then
				b.callback(b)
				b.isAnimating = true
				t = true
			end
		end
	end
	return t
end

buttons.update = function()
	for _,b in ipairs(buttons) do
		if b.isAnimating then
			b.count = b.count + 1
			if b.count > b.dur then
				b.isAnimating = false
				b.count = 0
			end
		end
	end
end

buttons.draw = function()
	for _,b in ipairs(buttons) do
		b:drawback()
	end
end

return buttons
