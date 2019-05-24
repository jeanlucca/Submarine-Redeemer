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

local bg --background
local start
local title

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
	sceneGroup = self.view

	bg = display.newImageRect("ocean-menu.png", 580, 680)
	bg.x = X
	bg.y = Y+100

	start = display.newImageRect("start.png", 100, 20)
	start.x = X
	start.y = Y+100
	start.alpha = 1
	physics.addBody( start, "static", { isSensor = false } )
    start:toFront()
    
    title = display.newImageRect("Titulo.png",400,100)
    title.x = X+30
	title.y = Y-50

	sceneGroup:insert(bg)
    sceneGroup:insert(start)
    sceneGroup:insert(title)
    --sceneGroup:insert(textuto)
    --sceneGroup:insert(textuto1)
    --sceneGroup:insert(textuto2)
    
    --local Texttuto = display.newTexttuto( "3 vidas", native.systemFont, 25 ) 
    --local Texttuto1 = display.newTexttuto( "Se encostar perde", native.systemFont, 25 ) 
    --local Texttuto2 = display.newTexttuto( "Se atirar na pessoa acaba o jogo", native.systemFont, 25 ) 
    
    display.remove(btnupObject)
    display.remove(btndown)
    display.remove(btnLeft)
    display.remove(btnRight)
    display.remove(personage)
    display.remove(tubarao)
    display.remove(submi)
    

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

		start:addEventListener( "touch", gotoPressToStart )
    elseif ( phase == "did" ) then

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
  
end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene