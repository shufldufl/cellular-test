local wrapmap = {
	around = function(grid,x,y) 
			return grid[((y-1)%grid.height)+1][((x-1)%grid.width)+1]
	end,
	dead = function(grid) return grid.dead end,
	alive = function(grid) return grid.alive end
}

local makeGrid = function(par)
	local rulesets = require("rules")
	local grid = {}
	grid.init = par
	grid.alive = 1
	grid.dead = 0

	grid.OOB = function(grid,x,y)
			return (x < 1 or x > grid.width)
				or (y < 1 or y > grid.height)
	end

	grid.setWrap = function(grid,wrap)
		if type(wrap) == "function" then
			grid.wrap = wrap
		else
			grid.wrap = wrapmap[wrap or "around"]	
		end
	end

	grid:setWrap(par.wrap)

	grid.clear = function(grid)
		for y=1,grid.height do
			for x=1,grid.width do
				grid[y][x] = 0
			end
		end
	end

	grid.flipCell = function(grid,x,y)
		if not grid:OOB(x,y) then
			if grid[y][x] == 0 then
				grid[y][x] = 1
			else
				grid[y][x] = 0
			end
		end
	end
	grid.getCell = function(grid,x,y)
		if grid:OOB(x,y) then
			return grid:wrap(x,y)
		else
			return grid[y][x]
		end
	end

	grid.sum = function(grid,rx,ry)
		local nh = math.floor((#grid.rule.neighbors - 1) / 2)
		local nw = math.floor((#grid.rule.neighbors[1] - 1) / 2)
		local sum = 0 
		for x=rx-nw,rx+nw do
			for y=ry-nh,ry+nh do
				if (x~=rx) or (y~=ry) then
					local n = grid:getCell(x,y)
					if type(n) == "number" then
						sum = sum + n
					end
				end
			end
		end
		return sum
	end

	grid.map = function(grid,cval,sum)
		local row = grid.rule[cval]
		return row[sum] or row.other
	end

	grid.width = par.width
	grid.height = par.height or 1

	if par.grid then
		grid.__grid = par.grid
	else
		grid.__grid = {}
		for y=1,grid.height do
			grid.__grid[y] = {}
			for x=1,grid.width do
				grid.__grid[y][x] = grid.dead
			end
		end
	end

	if type(par.ruleset) == "string" then
		grid.rule = rulesets[par.ruleset]
	else
		grid.rule = par.ruleset
	end
	
	grid.update = function(grid)
		local nmap = {}
		for y=1,grid.height do
			nmap[y] = {}
			for x=1,grid.width do
				if type(grid.rule) == "table" then
					nmap[y][x] = grid:map(grid[y][x],grid:sum(x,y))
				else
					nmap[y][x] = grid:rule(grid[y][x],x,y)
				end
			end	
		end
		grid.__grid = nmap
	end
	
	grid.serialize = function(grid)
		local s = '{\n'
		for y=1,grid.height do
			s = s .. '{'	
			for x=1,grid.width do
				s = s .. grid:getCell(x,y) .. ','
			end
			s = s .. '},\n'
		end
		return s .. '}'
	end
	return setmetatable(grid,{__index = function(grid,n) return grid.__grid[n] end})
end

return makeGrid			
								



