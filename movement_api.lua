-- An API for controlling the movement of a turtle while keeping track of its position
mapi = {}
mapi.directionNames = {
	"North",
	"East",
	"South",
	"West"
}

-- Move forward specified number of blocks
mapi.f = function(blocksToMove)
	
	while blocksToMove > 0 do
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

			blocksToMove = blocksToMove - 1
		else
			return err
		end
	end
end
mapi.forward = mapi.f



-- Turn left
mapi.l = turtle.turnLeft
mapi.left mapi.l



-- Turn right
mapi.r = turtle.turnRight
mapi.right = mapi.r



-- Initialize position
mapi.init = function(x,y,z,direction)
	mapi.position = {
		x = x,
		y = y,
		z = z
	}
	mapi.direction = direction
end

return mapi