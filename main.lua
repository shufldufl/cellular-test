function love.load()
	WIDTH = 800 
	HEIGHT = 800 
	love.window.setMode(WIDTH,HEIGHT)
	local gridMaker = require("grid")
	local testgrid = require("default")
	local size = #testgrid
	local rcount
	local rulelist = (function()
			local r = require("rules")
			local keys = {}
			for k,_ in pairs(r) do
				keys[#keys+1] = k
				if k == "conway" then
					rcount = #keys
				end
			end
			return keys
		end)()

	local rule = rulelist[rcount] 
	local wrap = "around"

	local reset = function(grid) 
			return 
			gridMaker({
					width=size,
					height=size,
					ruleset=rule,
					grid=grid or testgrid,wrap=wrap
			}) 
	end

	grid = reset()

	FRAMERATE = 10 
	FRAMECOUNT = 0
	ISPAUSED = false
	buttoner = require("buttons")
	local addb = function(y,t,f)
		buttoner.addDefault(0,y,100,20,t,f)
	end
	addb(0,"CLEAR",function() grid:clear() end)
	addb(20,"PAUSE",
		function(b) 
			ISPAUSED = not ISPAUSED  
			if ISPAUSED then 
				b.text = "START"
			else
				b.text = "PAUSE"
			end
		end)
	addb(40,"STEP",function() grid:update() end)
	do
		local count = 1 
		addb(60,rule,
			function(b)
				count = (count%#rulelist)+1
				rule = rulelist[count]
				grid = reset()
				b.text = rule
			end)
	end
	addb(80,"SIMSPEED",function()end)
	do
		local count = 4
		local speedmap = {40,20,10,5,2,1}
		buttoner.addDefault(100,80,20,20,"4",
			function(b)
				count = (count%#speedmap)+1
				b.text = ""..count
				FRAMERATE = speedmap[count]
			end)
	end
	do
		local count = 1
		local wrapmap = {"around","dead","alive"}
		addb(100,wrapmap[count],
			function(b)
				count = (count%#wrapmap)+1
				wrap = wrapmap[count]
				grid:setWrap(wrap)
				b.text = wrap
			end)
	end
	addb(120,"SAVE!",
		function()
			love.filesystem.write("save.lua","return " .. grid:serialize())
		end)
	addb(140,"LOAD!",
		function()
			local g = love.filesystem.load("save.lua")()
			grid = reset(g)
		end)
	SCALE = WIDTH/grid.width
end

function love.mousepressed(x,y)
	local t = buttoner.check(x,y)
	if not t then
		grid:flipCell(math.floor(x/SCALE)+1,math.floor(y/SCALE)+1)
	end
end

function love.update()
	buttoner.update()
	FRAMECOUNT = FRAMECOUNT + 1
	if FRAMECOUNT >= FRAMERATE and (not ISPAUSED) then
		FRAMECOUNT = 0
		grid:update()
	end
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.scale(SCALE,SCALE)
	for y=1,grid.height do
		for x=1,grid.width do
			if grid[y][x] == 1 then
				love.graphics.rectangle("fill",x-1,y-1,1,1)
			end
		end
	end
	love.graphics.reset()
	buttoner.draw()
end
