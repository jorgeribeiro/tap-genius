-- 
-- Abstract: ManyCrates sample project
-- Demonstrates simple body construction by generating 100 random physics objects
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require( "physics" )
physics.start()

local widget = require( "widget" )
local score = require( "score" )

display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImageRect( "bkg_clouds.png", 360, 480)
bkg.x = centerX
bkg.y = 240

local grass = display.newImageRect("grass.png", 360, 40)
grass.x = centerX
grass.y = _H - 68

local grass2 = display.newImageRect("grass2.png", 320, 82 ) -- non-physical decorative overlay
grass2.x = centerX
grass2.y = _H - 45
grass2:scale(1.25, 1.25)  -- make it a little bigger to look good on tall devices

physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )


local function newCrate()	
	rand = math.random( 100 )

	local crate

	if (rand < 60) then
		crate = display.newImage("crate.png");
		crate.x = 60 + math.random( 160 )
		crate.y = -100
		physics.addBody( crate, { density=0.9, friction=0.3, bounce=0.3} )
		crate.value = 50
	elseif (rand < 80) then
		crate = display.newImage("crateB.png");
		crate.x = 60 + math.random( 160 )
		crate.y = -100
		physics.addBody( crate, { density=1.4, friction=0.3, bounce=0.2} )
		crate.value = 100
	else
		crate = display.newImage("crateC.png");
		crate.x = 60 + math.random( 160 )
		crate.y = -100
		physics.addBody( crate, { density=0.3, friction=0.2, bounce=0.5} )
		crate.value = 500
		
	end	

	local function onTouch( event )
		print(event.phase)
		if event.phase == "began" then
			score.add(event.target.value)
			timer.performWithDelay(10, function() event.target:removeSelf(); end, 1)
		end
		return true
	end
	crate:addEventListener( "touch", onTouch )
end

local scoreText = score.init({
	fontSize = 20,
	font = "Helvetica",
	x = display.contentCenterX,
	y = 20,
	maxDigits = 7,
	leadingZeros = true,
	filename = "scorefile.txt",
	})

local function saveScore( event )
	if event.phase == "ended" then
		score.save()
	end
	return true
end

local saveButton = widget.newButton({
		width = 200,
		height = 64,
		x = display.contentCenterX,
		y = display.contentHeight - 32,
		label = "Save Score",
		labelColor = { default = { 1, 1, 1 }, over = { 0, 0, 0 } },
		fontSize = 32,
		onEvent = saveScore
	})

local function loadScore( event )
	if event.phase == "ended" then
		local prevScore = score.load()
		if prevScore then
			score.set(prevScore)
		end
	end
	return true
end

local saveButton = widget.newButton({
		width = 200,
		height = 64,
		x = display.contentCenterX,
		y = display.contentHeight - 64,
		label = "Load Score",
		labelColor = { default = { 1, 1, 1 }, over = { 0, 0, 0 } },
		fontSize = 32,
		onEvent = loadScore
	})

local dropCrates = timer.performWithDelay( 1000, newCrate, 100 )