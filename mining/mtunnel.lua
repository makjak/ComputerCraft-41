term.clear()
term.setCursorPos(1,1)
print ("--------------------------------------")
print ("|              mtunnel               |")
print ("|              v2.4.1                |")
print ("--------------------------------------")


print ("Number of tunnel pairs? ")
local tpNum = tonumber(read())

print("Number of side tunnel cycles (1 = 10 blocks): ")
local cnum = tonumber(read())



function checkUp()
	if turtle.detectUp() == true then
		repeat
			turtle.digUp()
			sleep(0.3)
		until turtle.detectUp() == false
	end
end

function checkDown()
	if turtle.detectDown() == false then
		turtle.select(15)
		turtle.placeDown()
		else
	end
end

function checkFront()
	if turtle.detect() == true then
		repeat
			turtle.dig()
			sleep(0.3)
		until turtle.detect() == false
	end
end

function moveFwd()
	if turtle.forward() == false then
		repeat
			turtle.dig()
			sleep(0.3)
		until turtle.forward() == true
	end
end

function placeTorch()
	if turtle.getItemCount(16) > 1 then
		turtle.dig()
		moveFwd()
		turtle.dig()
		moveFwd()
		turtle.back()
		checkDown()
		turtle.back()
		turtle.select(16)
		turtle.place()
		else
		print ("Out of torches!")
		rednet.broadcast("Out of torches!")
		sleep(5)
	end
end

function checkFuel()
	while turtle.getFuelLevel() <= 20 do
		if turtle.getItemCount(14) > 0 then
			turtle.select(14)
			turtle.refuel(1)
			rednet.broadcast("Refueled. Fuel level now at: "..turtle.getFuelLevel())
			else
			print ("Out of fuel!")
			rednet.broadcast("Out of fuel!")
			sleep(5)
		end
		sleep(0.1)
	end
end

function smallTunnel()
	local cnLoop = cnum
	for i=1,cnum do	
		for j=1,10 do
			checkFuel()
			turtle.dig()
			moveFwd()
			checkDown()
			turtle.digUp()
			sleep(0.5)
			checkUp()
		end
		turtle.turnLeft()
		turtle.up()
		placeTorch()
		turtle.turnRight()
		turtle.down()
	end
	
	turtle.turnLeft()
	turtle.turnLeft()	
	
	while cnLoop > 0 do
		repeat
			for k=1,10 do
				moveFwd()
			end
			checkFuel()
			cnLoop = cnLoop - 1
		until cnLoop == 0
	end
end

function msDig()
	checkFuel()
	moveFwd()
	checkUp()
	turtle.turnLeft()
	checkFront()
	turtle.up()
	checkFront()
	for tr=1,2 do	
		turtle.turnRight()
	end
	checkFront()
	turtle.down()
	checkFront()
end

function mainShaft()
	msDig()
	turtle.turnLeft()
	msDig()
	turtle.turnLeft()
	msDig()
end	

rednet.broadcast("Mining started, I will complete ")
rednet.broadcast(tpNum.." tunnel pairs, "..cnum.." cycles each.")
rednet.broadcast("Starting fuel level: "..turtle.getFuelLevel())

while tpNum > 0 do
	mainShaft()
	moveFwd()
	smallTunnel()
	for mf=1,2 do
		moveFwd()
	end
	smallTunnel()
	moveFwd()
	turtle.turnLeft()
	tpNum = tpNum - 1
	rednet.broadcast(tpNum.." tunnel pairs remaining of "..cnum.." cycles each.")
end		

rednet.broadcast("Mining completed.")