print("Animated Hourse with Several States (Walk, Dash, Jump, Fall)")

--These 9 special variables are querried by the engine each
-- frame and used to set the camera pose.
--Here we set the intial camera pose:
CameraPosX = -4.0; CameraPosY = 2; CameraPosZ = -1.8
CameraDirX = 1.0; CameraDirY = -0.0; CameraDirZ = -0.0
CameraUpX = 0.0; CameraUpY = 1.0; CameraUpZ = 0.0

theta = 0; radius = 4 --Helper variabsle for camera control

t = 0
horsePos = -6
function animate(dt)
  horsePos = horsePos + 1*dt*speed[curAction]

  --Update the camera based on radius and theta
  CameraPosX = radius*math.cos(theta)
  CameraPosZ = radius*math.sin(theta)
  CameraDirX = -CameraPosX
  CameraDirZ = -CameraPosZ

  t = t + dt
  if t > 1 then
    t = t-1
  end
  placeModel(horse[curAction],-4,1,horsePos)
  selectChild(horse[curAction],t)
end

--Special function that is called every frame
--The variable dt containts how much times has pased since it was last called
function frameUpdate(dt)
  frameDt = dt
  animate(dt)
end

--Special function that is called each frame. The variable
--keys containts information about which keys are currently .
function keyHandler(keys)

  -- --Move camera radius and theta based on up/down/left/right keys
  -- if keys.right then
  --   theta = theta + 1*frameDt
  -- end
  -- if keys.left then
  --   theta = theta - 1*frameDt
  -- end
  -- if keys.up then
  --   CameraPosX = CameraPosX + CameraDirX*frameDt
  --   CameraPosZ = CameraPosZ + CameraDirZ*frameDt
  --   print("CameraPosX "..CameraPosX)
  --   print("CameraPosZ "..CameraPosZ)
  -- end
  -- if keys.down then
  --   CameraPosX = CameraPosX - CameraDirX*frameDt
  --   CameraPosZ = CameraPosZ - CameraDirZ*frameDt
  --   print("CameraPosX "..CameraPosX)
  --   print("CameraPosZ "..CameraPosZ)
  -- end

  -- rotate camera to the left
  if keys.left then
    theta = theta + 1*frameDt
  end
  -- rotate camera to the right
  if keys.right then
    theta = theta - 1*frameDt
  end
  -- move camera forward
  if keys.up then
    CameraPosX = CameraPosX + CameraDirX*frameDt
    CameraPosZ = CameraPosZ + CameraDirZ*frameDt
  end
  -- move camera backward
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
    curAction = (curAction % #horse) + 1
    unhideModel(horse[curAction])
  end
  tabDownBefore = keys.tab --Needed so that single tab press only counts once

  if keys.r then --Reset Position
    horsePos = -5
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

--Load various animated models of horse actions
i = 1 --Lau is typically 1-indexed
horse = {}
speed = {}
horse[i] = addModel("Llama-Jump",0,1,0); speed[i] = 0.3; i = i+1
horse[i] = addModel("Horse-Dash",0,1,0); speed[i] = 3.0; i = i+1
horse[i] = addModel("Snake-Attack",0,1,0); speed[i] = 1.2; i = i+1 --No one velocity is right!
horse[i] = addModel("Horse-Fall",0,1,0); speed[i] = 0.0; i = i+1

--Only draw one of the actions
curAction = 1
for i = 1,#horse do
  if curAction ~= i then
    hideModel(horse[i])
  end
end

-- forest
trees = {}
idx = 1
for k = -10, 10 do
  for l = -10, 10 do
    trees[idx] = addModel("Tree", k, 1, l)
    idx = idx + 1
  end
end