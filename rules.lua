local rules = {}

local moores = {{1,1,1},
				{1,0,1},
				{1,1,1}}

local neumann = {{0,1,0},
				 {1,0,1},
				 {0,1,0}}

rules.conway = {
	neighbors = moores,
	[0] = {
		[3] = 1,
		other = 0},
	[1] = {
		[0] = 0,
		[1] = 0,
		[2] = 1,
		[3] = 1,
		other = 0}
}

rules.lifeWithoutDeath = {
	neighbors = moores,
	[0] = {
		[3] = 1,
		other = 0},
	[1] = {
		other = 1},
}

rules.seeds = {
	neighbors = moores,
	[0] = {
		[2] = 1,
		other = 0},
	[1] = {
		other = 0},
}

rules.briansBrain = {
	neighbors = moores,
	[0] = {
		[2] = 1,
		other = 0},
	[1] = {
		other = "dying"},
	dying = {
		other = 0}
}

rules.dayAndNight = {
	neighbors = moores,
	[0] = {
		[3] = 1,
		[6] = 1,
		[7] = 1,
		[8] = 1,
		other = 0},
	[1] = {
		[3] = 1, 
		[4] = 1,
		[6] = 1,
		[7] = 1,
		[8] = 1,
		other = 0}
}

rules.replicator = {
	neighbors = moores,
	[0] = {
		[1] = 1,
		[3] = 1,
		[5] = 1,
		[7] = 1,
		other = 0},
	[1] = {
		[1] = 1,
		[3] = 1,
		[5] = 1,
		[7] = 1,
		other = 0},
}
return rules
