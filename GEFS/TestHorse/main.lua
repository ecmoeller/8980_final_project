print("Llama collects crystals game")

--These 9 special variables are querried by the engine each
-- frame and used to set the camera pose.
--Here we set the intial camera pose:
--y pos use to be 2 and dirY is 0
--xpos -4
--posz = -6
CameraPosX = -8.0; CameraPosY = 9; CameraPosZ = -6
CameraDirX = 1; CameraDirY = -6.5; CameraDirZ = 5.0
CameraUpX = 0.0; CameraUpY = 1.0; CameraUpZ = 0.0

theta = 0; radius = 4 --Helper variabsle for camera control

--Other variables
flipVelocity = 4.0
t = 0
gridLayer = 0

--Starting z position for each animal
horsePos = -3
snakePos = 0
snake2Pos = -1

--Colliders variables
crystalColliders = {}
treeColliders = {}
horseColliders = {}


function animateHorse(dt)

  --Main animal moves back and forth
  if moveRightHorse then
    horsePos = horsePos + 1*dt*horseSpeed[curAction]

    --figure out when to turn around
    if horsePos > 5 then
      moveRightHorse = false 
      --rotate model
      --rotateModel(modelID,rotYvel*dt, 0, 1, 0)
      --rotateModel(horse[curAction], flipVelocity*dt, 1 , 0, 0)
      rotateModel(horse[curAction], 180, 1 , 0, 0)
    end

  else 
    horsePos = horsePos - 1*dt*horseSpeed[curAction]

    --figure out when to turn around
    if horsePos < -4 then
      moveRightHorse = true 
      --rotate model
    end
  end 

  --Update the camera based on radius and theta
  CameraPosX = radius*math.cos(theta)
  CameraPosZ = radius*math.sin(theta)
  CameraDirX = -CameraPosX
  CameraDirZ = -CameraPosZ

  t = t + dt
  if t > 1 then
    t = t-1
  end
  placeModel(horse[curAction],-3,1,horsePos)
  selectChild(horse[curAction],t)
end

function animateSnake(dt)

  --Snake moves back and forth
  if moveRightSnake then
    snakePos = snakePos + 1*dt*snakeSpeed[curAction]

    --figure out when to turn around
    if snakePos > 5 then
      moveRightSnake = false 
      --Should rotate model here
    end

  else 
    snakePos = snakePos - 1*dt*snakeSpeed[curAction]

    --figure out when to turn around
    if snakePos < -4 then
      moveRightSnake = true 
      --Should rotate model here
    end
  end 

  t = t + dt
  if t > 1 then
    t = t-1
  end
  placeModel(snake[curAction],-1,1,snakePos)
  selectChild(snake[curAction],t)
end

function animateSnake2(dt)

  --Snake moves back and forth
  if moveRightSnake2 then
    snake2Pos = snake2Pos + 1*dt*snake2Speed[curAction]

    --figure out when to turn around
    if snake2Pos > 5 then
      moveRightSnake2 = false 
      --rotate model
      --rotateModel(modelID,rotYvel*dt, 0, 1, 0)
    end

  else 
    snake2Pos = snake2Pos - 1*dt*snake2Speed[curAction]

    --figure out when to turn around
    if snake2Pos < -4 then
      moveRightSnake2 = true 
      --rotate model
    end
  end 

  t = t + dt
  if t > 1 then
    t = t-1
  end
  placeModel(snake2[curAction],0,1,snake2Pos)
  selectChild(snake2[curAction],t)
end

--Special function that is called every frame
--The variable dt containts how much times has pased since it was last called
function frameUpdate(dt)

  frameDt = dt
  
  animateHorse(dt)
  animateSnake(dt)
  animateSnake2(dt)
  mainAnimalCrystalCollision()

  
end

function mainAnimalCrystalCollision()
  crystalCollision = getCollisionsWithLayer(math.floor(prize[prizeIdx]), 0)
  horseCollision = getCollisionsWithLayer(math.floor(horse[curAction]), 0)

  if crystalCollision ~= nil and horseCollision ~= nil then

    --Main animal is colliding with a crystal
    if crystalCollision == horse[curAction] or horseCollision == prize[prizeIdx] then
      print("horse and crystal are colliding")
      --Remove the crystal
      deleteModel(prize[prizeIdx])

      --Add another crystal in a new location?
    end
  end
end

--Special function that is called each frame. The variable
--keys containts information about which keys are currently .
function keyHandler(keys)

  --Move camera radius and theta based on up/down/left/right keys
  if keys.right then
    theta = theta + 1*frameDt
  end
  if keys.left then
    theta = theta - 1*frameDt
  end
  if keys.up then
    CameraPosX = CameraPosX + CameraDirX*frameDt
    CameraPosZ = CameraPosZ + CameraDirZ*frameDt
  end
  if keys.down then
    CameraPosX = CameraPosX - CameraDirX*frameDt
    CameraPosZ = CameraPosZ - CameraDirZ*frameDt
  end

  -- apply theta changes
  CameraDirX = math.cos(theta)
  CameraDirZ = -math.sin(theta)

  --When tab is pressed hide the current animation and unhide the next one
  if keys.tab and not tabDownBefore then
    t = 0
    hideModel(horse[curAction])
    hideModel(snake[curAction])
    curAction = (curAction % #horse) + 1
    unhideModel(horse[curAction])
    unhideModel(snake[curAction])
  end
  tabDownBefore = keys.tab --Needed so that single tab press only counts once

  if keys.r then --Reset Position
    horsePos = -5
    snakePos = -3
  end

end

--Add base floor model
floor = addModel("Floor",0,.95,0)
setModelMaterial(floor,"Flooring")

--Try new floor
--id = addModel("FloorPart",0,0,0)
--placeModel(id,0,-.02,0)
--scaleModel(id,10,1,10)
--setModelMaterial(id,"Clay")

--Load various animated models of main animal's actions
i = 1 --Lau is typically 1-indexed
horse = {}
horseSpeed = {}
horse[i] = addModel("Llama-Jump",0,1,0); horseSpeed[i] = 1.5; 
horseColliders[i] = addCollider(horse[i], gridLayer, 0.6, 0, 0, 0)
print("Main animal collider "..horseColliders[i])
i = i+1
horse[i] = addModel("Horse-Dash",0,1,0); horseSpeed[i] = 3.0; i = i+1
horse[i] = addModel("Snake-Attack",0,1,0); horseSpeed[i] = 1.2; i = i+1 --No one velocity is right!
horse[i] = addModel("Pig-Jump",0,1,0); horseSpeed[i] = 0.5; i = i+1
--print("What is i "..i)
--print("after models added "..horseColliders[1])

i = 1 --Lau is typically 1-indexed
snake = {}
snakeSpeed = {}
snake[i] = addModel("Snake-Attack",0,1,0); snakeSpeed[i] = 1.3; i = i+1
snake[i] = addModel("Snake-Attack",0,1,0); snakeSpeed[i] = 3.0; i = i+1
snake[i] = addModel("Snake-Attack",0,1,0); snakeSpeed[i] = 1.2; i = i+1 --No one velocity is right!
snake[i] = addModel("Snake-Attack",0,1,0); snakeSpeed[i] = 0.5; i = i+1

i = 1 --Lau is typically 1-indexed
snake2 = {}
snake2Speed = {}
snake2[i] = addModel("Snake-Attack",0,1,0); snake2Speed[i] = 1.3; i = i+1
snake2[i] = addModel("Snake-Attack",0,1,0); snake2Speed[i] = 3.0; i = i+1
snake2[i] = addModel("Snake-Attack",0,1,0); snake2Speed[i] = 1.2; i = i+1 --No one velocity is right!
snake2[i] = addModel("Snake-Attack",0,1,0); snake2Speed[i] = 0.5; i = i+1


--Only draw one of the actions
curAction = 1
for i = 1,#horse do
  if curAction ~= i then
    hideModel(horse[i])
    hideModel(snake[i])
    hideModel(snake2[i])
  end
end

-- forest
trees = {} --idx ->modelID
prize = {}
idx = 1
prizeIdx = 1
for k = -5, 2 do
  for l = -5, 5 do
    if k == -5 or k == 2 or l == -5 or l == 5 then
      trees[idx] = addModel("Tree", k, 1, l)
      --I guess .6 is the bounding radius
      treeColliders[trees[idx]] = addCollider(trees[idx], gridLayer, 0.6, 0, 0, 0)
      idx = idx + 1
    end
  end
end

--Adding on e prize
prize[prizeIdx] = addModel("Crystal", -3,1,0)
crystalColliders[prizeIdx] = addCollider(prize[prizeIdx], gridLayer, 0.6, 0, 0, 0)
crysCol = getCollisionsWithLayer(math.floor(prize[prizeIdx]), 0)

