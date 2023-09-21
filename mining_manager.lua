require "movement_api"
require "valuable_blocks"
require "config"


print("Enter current X: ")
local x = tonumber(read())
print("Enter current Y: ")
local y = tonumber(read())
print("Enter current Z: ")
local z = tonumber(read())
print("Enter direction (1 for North, 2 for East, 3 for South, 4 for West): ")
local direction = tonumber(read())

valuable_blocks_table = {}
function in_valuable_block_table(check)
      for k,v in pairs(valuable_blocks_table) do
            if v.x == check.x and v.y == check.y and v.z == check.z then
                  return true
            end
      end

      return false
end

function in_table(t,check)
      for k,v in pairs(t) do
            if v == check then
                  return true
            end
      end

      return false
end

mapi.init(x,y,z,direction,function ()
	print("Vein miner activated")
	function investigateSurroundings()
		function inspect(block,direction)
			if in_table(valuable_blocks,block.name) then

				print("Found valuable block")

				xOffset = 0
				yOffset = 0
				zOffset = 0

				if direction == "up" then
					yOffset = 1
				end
				if direction == "down" then
					yOffset = -1
				end
				if direction == "forward" then
					if mapi.direction == 1 then
						zOffset = zOffset - 1
					end
					if mapi.direction == 2 then
						xOffset = xOffset + 1
					end
					if mapi.direction == 3 then
						zOffset = zOffset + 1
					end
					if mapi.direction == 4 then
						xOffset = xOffset - 1
					end
				end

				vbtEntry = {
					x = mapi.position.x + xOffset,
					y = mapi.position.y + yOffset,
					z = mapi.position.z + zOffset,
				}

				if not in_valuable_block_table(vbtEntry) then
					print("Was not already in the table")
					table.insert(valuable_blocks_table,vbtEntry)
				end
			end
		end

		for i=1,4 do
			local _, block = turtle.inspect()
			inspect(block,"forward")
			mapi.l()
		end

		local _, block = turtle.inspectUp()
		inspect(block,"up")
		local _, block = turtle.inspectDown()
		inspect(block,"down")
	end

	investigateSurroundings()
	while valuable_block_table do
		mapi.goToPosition(vbtEntry[1].x,vbtEntry[1].y,vbtEntry[1].z)

		table.remove(vbtEntry,1)

		investigateSurroundings()
	end
end)



--while true do
--	mapi.goToPosition(math.floor((math.random() - .5) * 2 * config.search_range),config.target_y_level,math.floor((math.random() - .5) * 2 * config.search_range))
--end
mapi.veinMinerMode()