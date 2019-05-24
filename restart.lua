local composer = require( "composer" )
local scene = composer.newScene()

math.randomseed( os.time() )
-- Set physics
local physics = require("physics")
physics.start()
----------------------------------------------------------
W = display.contentWidth
H = display.contentHeight

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
--local backGroup = display.newGroup()  -- Display group for the background image
--local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
--local uiGroup = display.newGroup()    -- Display group for UI objects like the score

local bg --background
local start = display.newText( "Jogar novamente", X, 200, native.systemFont, 30 )
local restart

local function gotoPressToStart()
    composer.gotoScene( "game", { time=500, effect="crossFade" } )
  end

--                      COMPOSER                        --
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
--                      COMPOSER                        --


composer.recycleOnSceneChange = true;
function scene:create( event )
  local sceneGroup = self.view

  ------Background----------
  local background = display.newImageRect("Game over.png",1890,1500)
  background.X = display.contentCenterX
  background.Y = display.contentCenterY 
  local playButton = display.newImageRect("menu do restart.png",250,70)
  playButton.X = display.contentCenterX
  playButton.Y = display.contentCenterY + 50

  -------- INSERT --------
  --sceneGroup:insert(bg)
  --sceneGroup:insert(restart)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

		start:addEventListener( "tap", gotoPressToStart )
    -- audio.stop(1)
    --audio.stop(3)
    --deathmusic = audio.loadSound( "musica.wav" )
    --audio.play( deathmusic, {channel=2, loops=-1} )

    elseif(phase =="did")then
       -- Code here runs when the scene is entirely on screen
        --audio.play( musicGame )
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
	  -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
      
    end
end

function scene:destroy( event )
  
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
  
end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene