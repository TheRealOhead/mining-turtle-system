-- An API for controlling the movement of a turtle while keeping track of its position
mapi = {}
mapi.directionNames = {
	"North",
	"East",
	"South",
	"West"
}

-- Move forward specified number of blocks
mapi.f = function()
	
	turtle.dig()
	status, err = turtle.forward()
	if (status) then -- Twas a success
		
		-- Set new position
		if mapi.direction == 1 then
			mapi.position.z = mapi.position.z - 1
		end
		if mapi.direction == 2 then
			mapi.position.x = mapi.position.x + 1
		end
		if mapi.direction == 3 then
			mapi.position.z = mapi.position.z + 1
		end
		if mapi.direction == 4 then
			mapi.position.x = mapi.position.x - 1
		end
	else
		return err
	end
end
mapi.forward = mapi.f



-- Turn left
mapi.l = function ()
	mapi.direction = mapi.direction - 1
	mapi.fixDirection()
	turtle.turnLeft()
end
mapi.left = mapi.l



-- Turn right
mapi.r = function ()
	mapi.direction = mapi.direction + 1
	mapi.fixDirection()
	turtle.turnRight()
end
mapi.right = mapi.r

-- Go up
mapi.u = function ()
	turtle.digUp()
	turtle.up()

	mapi.goHomeIfNoMoreFuel()
end
mapi.up = mapi.u


-- Go down
mapi.d = function ()
	turtle.digDown()
	turtle.down()

	mapi.goHomeIfNoMoreFuel()
end
mapi.down = mapi.d

-- Make direction in correct range
mapi.fixDirection = function ()
	mapi.direction = ((mapi.direction - 1) % 4) + 1
end


-- This is horrible and ugly and I hate it
mapi.goToPosition = function (x,y,z)
	function align(targetDirection)
		while (mapi.direction ~= targetDirection) do
			mapi.turnLeft()
		end
	end

	-- X, then Z, then Y
	if x ~= mapi.position.x then -- Can't make this shit into its own function because mapi.position._ is changing and we're checking for it
		if x < mapi.position.x then
			targetDirection = 2 -- East
		else
			targetDirection = 4 -- West
		end
		align(targetDirection)
		while (x ~= mapi.position.x) do
			mapi.f()
		end
	end

	if z ~= mapi.position.z then -- Can't make this shit into its own function because mapi.position._ is changing and we're checking for it
		if z < mapi.position.z then
			targetDirection = 3 -- South
		else
			targetDirection = 1 -- North
		end
		align(targetDirection)
		while (z ~= mapi.position.z) do
			mapi.f()
		end
	end

	-- Don't need direction bullshit for Y becuase direction is irrelivant
	while (y ~= mapi.position.y) do
		if (y < mapi.position.y) then
			mapi.d()
		else
			mapi.u()
		end
	end
end


mapi.goHome = function ()
	mapi.goToPosition(home.x,home.y,home.z)
end

mapi.goHomeIfNoMoreFuel = function ()
	-- Compare fuel count to distance home and see if we're running too low on fuel. If so, then go home
	local distanceHome = math.abs(mapi.position.x - mapi.home.x) + math.abs(mapi.position.y - mapi.home.y) + math.abs(mapi.position.z - mapi.home.z)

	if distanceHome > fuel - 10 then
		mapi.goHome()
	end
end


mapi.inventoryCheckInterval = 10
-- Check for and throw out junk items. Also go home if there aren't any slots left
mapi.inventoryCheck = function ()
	-- TODO: Implement
end


-- Initialize position
mapi.init = function(x,y,z,direction)
	mapi.home = {
		x = x,
		y = y,
		z = z
	}
	mapi.position = {
		x = x,
		y = y,
		z = z
	}
	mapi.direction = direction
end

return mapi