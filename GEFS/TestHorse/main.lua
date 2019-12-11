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

t = 0
horsePos = -6
snakePos = 0
count = 0

treeColliders = {}
horseColliders = {}

--Crystal variables
crystalColliders = {}
gridLayer = 0

function animateHorse(dt)

  --Main animal moves back and forth
  if moveRightHorse then
    horsePos = horsePos + 1*dt*horseSpeed[curAction]

    --figure out when to turn around
    if horsePos > 7 then
      moveRightHorse = false 
      --rotate model
      --rotateModel(modelID,rotYvel*dt, 0, 1, 0)
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
    if snakePos > 7 then
      moveRightSnake = false 
      --rotate model
      --rotateModel(modelID,rotYvel*dt, 0, 1, 0)
    end

  else 
    snakePos = snakePos - 1*dt*snakeSpeed[curAction]

    --figure out when to turn around
    if snakePos < -4 then
      moveRightSnake = true 
      --rotate model
    end
  end 

  --Update the camera based on radius and theta
  -- CameraPosX = radius*math.cos(theta)
  -- CameraPosZ = radius*math.sin(theta)
  -- CameraDirX = -CameraPosX
  -- CameraDirZ = -CameraPosZ

  t = t + dt
  if t > 1 then
    t = t-1
  end
  placeModel(snake[curAction],-1,1,snakePos)
  selectChild(snake[curAction],t)
end

--Special function that is called every frame
--The variable dt containts how much times has pased since it was last called
function frameUpdate(dt)
  frameDt = dt
  animateHorse(dt)
  animateSnake(dt)

  collision = getCollisionsWithLayer(crystalColliders[1])
  if collision == -1 then
    print("You hit something")
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
horse[i] = addModel("Llama-Jump",0,1,0); horseSpeed[i] = .5; i = i+1
--horse[i] = addModel("Horse-Dash",0,1,0); horseSpeed[i] = 3.0; i = i+1
--horse[i] = addModel("Snake-Attack",0,1,0); horseSpeed[i] = 1.2; i = i+1 --No one velocity is right!
--horse[i] = addModel("Horse-Fall",0,1,0); horseSpeed[i] = 0.0; i = i+1
horseColliders[i] = addCollider(horse[i], gridLayer, 0.6, 0, 0, 0)

i = 1 --Lau is typically 1-indexed
snake = {}
snakeSpeed = {}
snake[i] = addModel("Snake-Attack",0,1,0); snakeSpeed[i] = 1.3; i = i+1
snake[i] = addModel("Horse-Dash",0,1,0); snakeSpeed[i] = 3.0; i = i+1
snake[i] = addModel("Snake-Attack",0,1,0); snakeSpeed[i] = 1.2; i = i+1 --No one velocity is right!
snake[i] = addModel("Horse-Fall",0,1,0); snakeSpeed[i] = 0.0; i = i+1


--Only draw one of the actions
curAction = 1
for i = 1,#horse do
  if curAction ~= i then
    hideModel(horse[i])
    hideModel(snake[i])
  end
end

-- forest
trees = {} --idx ->modelID
prize = {}
idx = 1
prizeIdx = 1
for k = -5, 5 do
  for l = -5, 5 do
    if k % 2 == 0 then
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

--Trees around the outside