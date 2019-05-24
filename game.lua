local composer = require( "composer" )
local scene = composer.newScene()

local function gotoRestart()
    composer.gotoScene( "menu", { time=500, effect="crossFade" } )
end

local physics = require( "physics" )

physics.start()
--physics.setDrawMode("hybrid")

----------------------------------------------------------
W = display.contentWidth 
H = display.contentHeight 

X = display.contentCenterX
Y = display.contentCenterY
----------------------------------------------------------
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score

local bgSub
local vidas = 3
local tempo = 0
local contVidas = 0
local contpessoas = 0
local pessoasnosub = 0
local score = 0

local fimJogo = false

------- Submarino
local sub = display.newImageRect(mainGroup,"submarine.png", 100, 40)
sub.x = display.contentCenterX
sub.y = display.contentCenterY
sub.myName = "submarine"
physics.addBody( sub, "dynamic", { bounce=0.5, isSensor = false } )
sub.gravityScale = 0

local deep = display.newRect(backGroup, 130, 320, 1000, 10 )
print(deep)
deep:setFillColor( 1 )
deep.alpha = 0
deep.myName = "deep"
physics.addBody( deep, "static" )

local beach = display.newRect(backGroup, 130, 70, 1000, 10 )
beach:setFillColor( 1 )
beach.alpha = 0
beach.myName = "beach"
physics.addBody( beach, "static" )


local musicTrack = audio.loadStream( "musica.wav")


local btnupObject = display.newImageRect(uiGroup,"btn-up.png", 50,30)
btnupObject.alpha = 0.50
btnupObject.myName = "up"
btnupObject.x = X -230
btnupObject.y = Y +80
physics.addBody( btnupObject, "static" ,{ isSensor = false } )


local btndown = display.newImageRect(uiGroup,"btn-down.png" ,50,30)
btndown.x = X -230
btndown.y= Y + 130
btndown.alpha = 0.80
btndown.myName = "down"
physics.addBody( btndown, "static" ,{ isSensor = false } )



local btnLeft = display.newImageRect(uiGroup,"btn-left.png",30,30)
btnLeft.x = X+150
btnLeft.y = Y+130
btnLeft.alpha = 0.8
btnLeft.myName = "left"
physics.addBody( btnLeft, "static", { isSensor = true } )
 
local btnRight = display.newImageRect(uiGroup,"btn-right.png",30,30)
btnRight.x = X+200
btnRight.y = Y+130
btnRight.alpha = 0.8
btnRight.myName = "right"
physics.addBody( btnRight, "static", { isSensor = true } )

---------------------------------------------------
local obstacleTable = {}
---------------------------------------------------

---------------------------------------------------
--                  FUNÇÕES                      -- 
---------------------------------------------------

local function dragsubmarine( event )
  
    if ( event.phase == "began" ) then
        -- Code executed when the button is touched
        sub:setLinearVelocity(0,-30)
        if(sub.y <= 110)then
            print("chegou  "..pessoasnosub)
            contpessoas = contpessoas + pessoasnosub
            pessoasnosub = 0
            contpessoastext.text = "Resgate " .. contpessoas
        end

        
    elseif ( event.phase == "moved" ) then
        -- Code executed when the touch is moved over the object
        print("Subiu moved")
       
    elseif ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
        sub:setLinearVelocity(0,0)
        print("subiu ended")
        
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
btnupObject:addEventListener("touch",dragsubmarine)

local function downsubmarine( event )
 
    if ( event.phase == "began" ) then
        -- Code executed when the button is touched
        sub:setLinearVelocity(0,30)
        
    elseif ( event.phase == "moved" ) then
        -- Code executed when the touch is moved over the object
       
    elseif ( event.phase == "ended" ) then
        -- Code executed when the touch lifts off the object
        sub:setLinearVelocity(0,0)
        
    end
    return true  -- Prevents tap/touch propagation to underlying objects
end
btndown:addEventListener("touch",downsubmarine)



local function fireMissilLeft()
  
    local missil = display.newImageRect(mainGroup,"missilLeft.png", 40, 15)
    physics.addBody( missil, "dynamic", { isSensor=true } )
    missil.isBullet = true
    missil.myName = "missil"
    missil.gravityScale = 0

    missil.x = sub.x
    missil.y = sub.y

    missil:setLinearVelocity(-400,0)

end

local function fireMissilRight()
    local missil = display.newImageRect(mainGroup,"missilRight.png", 40, 15)
    physics.addBody( missil, "dynamic", { isSensor=true } )
    missil.isBullet = true
    missil.myName = "missil"
    missil.gravityScale = 0

    missil.x = sub.x
    missil.y = sub.y

    missil:setLinearVelocity(400,0)

end

btnRight:addEventListener( "tap", fireMissilRight )
btnLeft:addEventListener( "tap", fireMissilLeft )


--Gerando os obstaculos na tela aleatoriamente :
local function createObstacles()

    if(fimJogo == false) then
        local whereFrom = math.random( 3 )
        --whereFrom = 3

        if( whereFrom == 1 ) then 
            local inimigo = display.newImageRect(mainGroup,"submi.png", 60, 40 )
            physics.addBody( inimigo, "dynamic", { isSensor = true } )
            inimigo.myName = "inimigo"
            inimigo.gravityScale = 0

            inimigo.x = W+100
            inimigo.y = H-math.random(100, 200)
            inimigo:setLinearVelocity( -20, 0 )

            obstacleTable[#obstacleTable+1] = inimigo

        elseif( whereFrom == 2 ) then
            local inimigo = display.newImageRect( mainGroup, "tubarao.png", 60, 40 )
            physics.addBody( inimigo, "dynamic", { isSensor = true } )
            inimigo.myName = "inimigo"
            inimigo.gravityScale = 0

            inimigo.x = W-500
            inimigo.y = H-math.random(100, 200)
            inimigo:setLinearVelocity( 40, 0 )

            obstacleTable[#obstacleTable+1] = inimigo

        elseif( whereFrom == 3 ) then
        local bem  = display.newImageRect(mainGroup, "personage.png", 40, 40 )
        physics.addBody( bem, "dynamic", { isSensor = true } )
        bem.myName = "pessoa"
        bem.gravityScale = 0

        bem.x = W-500
        bem.y = H-math.random(110, 200)
        bem:setLinearVelocity( 40, 0 )

        
        end
    end
end

local function gameLoop()

    if(fimJogo == false) then
        createObstacles()

        -- Remove obstacles
        if( #obstacleTable ~= 0 ) then
            for i = #obstacleTable, 1, -1  do
                local thisObstacle = obstacleTable[i]
                if(thisObstacle == nil )then
                    table.remove( obstacleTable, i )
                

                elseif ( thisObstacle.x < -100 or thisObstacle.x > display.contentWidth + 100 )then
                    display.remove( thisObstacle )
                    table.remove( obstacleTable, i )
                    print("removeu obstaculo")
                end
            end
        end
    end

end

-- local function gotoPressToStart()
--     composer.gotoScene( "menu", { time=500, effect="crossFade" } )
--   end

gameLoopTimer = timer.performWithDelay( 2000, gameLoop, 0 )

--------Colisões--------------

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
    
    
        if ( ( obj1.myName == "missil" and obj2.myName == "inimigo" ) or
            ( obj1.myName == "inimigo" and obj2.myName == "missil" ) ) 
        then

                --display.remove(obj1)
                --display.remove(obj2)    
               timer.performWithDelay(100, function() obj1.y = -200 obj2.y= -150 end, 1)

        end


        if ( ( obj1.myName == "submarine" and obj2.myName == "inimigo" ) or
            ( obj1.myName == "inimigo" and obj2.myName == "submarine" ) ) 
        then

                --display.remove(obj1)
                --display.remove(obj2)
                vidas = vidas-1

                contVidas.text =   "vidas = ".. vidas

                if(vidas == 0)then
                
                    timer.performWithDelay(100, function() obj1.y = -200 obj2.y= -150 end, 1)
                    timer.cancel(gameLoopTimer)
                    timer.cancel(contagemtimer)

                  
                    local txt = display.newText( uiGroup ,"GAME OVER", X, 150, native.systemFont, 30 )
                    local txt1 = display.newText( uiGroup ,"Jogar novamente", X, 200, native.systemFont, 30 )
                    local txt2 = display.newText(uiGroup ,"Total de Resgates: "..contpessoas, X, 250, native.systemFont, 30 )
                    
                    fimJogo = true
                    
                    txt1:addEventListener( "tap" , gotoRestart )

                    display.remove(btnupObject)
                    display.remove(btndown)
                    display.remove(btnLeft)
                    display.remove(btnRight)
                    display.remove(personage)
                    display.remove(tubarao)
                    display.remove(submi)
                    timer.cancel(contagemtimer)
                    timer.cancel(gameLoopTimer)
                    
                end   

        end

        if (  obj1.myName == "submarine" and obj2.myName == "pessoa" ) 
         
        then
 
                display.remove(obj2)
                pessoasnosub = pessoasnosub + 1
    

        end
        if  ( obj1.myName == "pessoa" and obj2.myName == "submarine" ) 
        then

                display.remove(obj1)
                pessoasnosub = pessoasnosub + 1             
               --timer.performWithDelay(100, function() obj1.y = -200 obj2.y= -150 end, 1)
               if(thisObstacle == nil )then
                table.remove( obstacleTable, i )
            

              elseif ( thisObstacle.x < -100 or thisObstacle.x > display.contentWidth + 100 )
              then
                display.remove( thisObstacle )
                table.remove( obstacleTable, i )
                print("removeu obstaculo")
            end
        end
        if ( ( obj1.myName == "missil" and obj2.myName == "pessoa" ) or
                ( obj1.myName == "pessoa" and obj2.myName == "missil" ) ) then
    
                    --display.remove(obj1)
                    --display.remove(obj2)
    
                   
                   timer.performWithDelay(100, function() obj1.y = -200 obj2.y= -150 end, 1)
                   local txt = display.newText(uiGroup, "GAME OVER", X, 150, native.systemFont, 30 )
                   local txt1 = display.newText(uiGroup,"Jogar novamente", X, 200, native.systemFont, 30 )
                   local txt2 = display.newText(uiGroup ,"Total de Resgates: "..contpessoas, X, 250, native.systemFont, 30 )
                   
                   fimJogo = true
                   txt1:addEventListener("tap", gotoRestart)
                   
                    
                    display.remove(btnupObject)
                    display.remove(btndown)
                    display.remove(btnLeft)
                    display.remove(btnRight)
                    display.remove(tubarao)
                    display.remove(submi)
                    timer.cancel(contagemtimer)
                   
                 end
       end
 end
 Runtime:addEventListener( "collision", onCollision )


---Criando as 3 variavéis
 local countText = display.newText( uiGroup,"tempo", 430, 20, native.systemFont, 25 ) 
     countText:setFillColor( 0, 0, 0 )
     contVidas = display.newText(uiGroup,  "vidas = ".. vidas, 310, 20, native.systemFont, 25 )
     contVidas:setFillColor( 0, 0, 0 )
     contpessoastext = display.newText (uiGroup,"resgates = 0",150,20,native.systemFont,25)
     contpessoastext:setFillColor( 0, 0, 0 )

    
------Função-----
local function contagem()
    tempo = tempo + 1
    countText.text = "Tempo: " .. tempo
    if (tempo >= 500)then
    timer.cancel(gameLoopTimer)
    timer.cancel(contagemtimer)
        local txt = display.newText(uiGroup, "GAME OVER ", X, 150, native.systemFont, 25  )
        local txt1 = display.newText(uiGroup,"Jogar novamente", X, 200, native.systemFont, 30 )
        local txt2 = display.newText(uiGroup ,contpessoas, X, 250, native.systemFont, 30 )
        txt1:addEventListener("tap",gotoRestart)
   end
end

contagemtimer=timer.performWithDelay( 100, contagem, 0 )



--                      COMPOSER                        --
----------------------------------------------------------
--                      COMPOSER                        --


composer.recycleOnSceneChange = true;
function scene:create( event )
    sceneGroup = self.view
    
    bgSub = display.newImageRect( backGroup,"bg1.png", 600, 380 )
    bgSub.x = display.contentCenterX
    bgSub.y = display.contentCenterY

    sceneGroup:insert(bgSub)
    sceneGroup:insert(backGroup)
    sceneGroup:insert(mainGroup)
    sceneGroup:insert(uiGroup)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then

       print("entrou")
       print(musicTrack)
        -- Start the music!
        --audio.play( musicTrack, { channel=1, loops=-1 } )
        -- Stop the music!
        --audio.stop( 1 )

    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase
  
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
      --timer.cancel(contagemtimer)
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
      display.remove(backGroup)
      
      --backGroup = nil
      display.remove(mainGroup)
      --mainGroup = nil
      display.remove(uiGroup)
      --uiGroup = nil
      composer.removeScene("game")
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
