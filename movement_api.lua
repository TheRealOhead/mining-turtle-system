-- An API for controlling the movement of a turtle while keeping track of its position


require "valuable_blocks"

function in_table(t,check)
      for k,v in pairs(t) do
            if v == check then
                  return true
            end
      end

      return false
end

mapi = {}
mapi.directionNames = {
	"North",
	"East",
	"South",
	"West"
}

ignoreValuables = false

-- Move forward specified number of blocks
mapi.f = function()

	local _, block = turtle.inspect()
	
	if (in_table(valuable_blocks,block.name) and not ignoreValuables) then
		mapi.veinMinerMode()
	end

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
	mapi.goHomeIfNoMoreFuel()
	mapi.inventoryCheck()
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
	if turtle.up() then
		mapi.position.y = mapi.position.y + 1
	end

	mapi.goHomeIfNoMoreFuel()
	mapi.inventoryCheck()
end
mapi.up = mapi.u


-- Go down
mapi.d = function ()
	turtle.digDown()
	if turtle.down() then
		mapi.position.y = mapi.position.y - 1
	end

	mapi.goHomeIfNoMoreFuel()
	mapi.inventoryCheck()
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
			mapi.left()
		end
	end

	-- X, then Z, then Y
	if x ~= mapi.position.x then -- Can't make this shit into its own function because mapi.position._ is changing and we're checking for it
		if x > mapi.position.x then
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
		if z > mapi.position.z then
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
	ignoreValuables = true
	mapi.goToPosition(mapi.home.x,mapi.home.y,mapi.home.z)
	os.exit()
end

mapi.goHomeIfNoMoreFuel = function ()
	-- Compare fuel count to distance home and see if we're running too low on fuel. If so, then go home
	local distanceHome = math.abs(mapi.position.x - mapi.home.x) + math.abs(mapi.position.y - mapi.home.y) + math.abs(mapi.position.z - mapi.home.z)

	if distanceHome > turtle.getFuelLevel() - 10 then
		mapi.goHome()
	end
end


mapi.inventoryCheckInterval = 10
-- Check for and throw out junk items. Also go home if there aren't any slots left
inventoryCheckIndex = 0
mapi.inventoryCheck = function ()
	inventoryCheckIndex = inventoryCheckIndex + 1
	if inventoryCheckIndex > mapi.inventoryCheckInterval then
		inventoryCheckIndex = 0
		for i=1,16 do
			turtle.select(i)
			if (turtle.getItemDetail() and (not in_table(valuable_blocks,turtle.getItemDetail().name))) then
				turtle.drop()
			end
		end
	end
end


-- Initialize position
mapi.init = function(x,y,z,direction,veinMinerMode)
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
	mapi.veinMinerMode = veinMinerMode
end

return mapi