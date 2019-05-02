--[[----------------------------------------------------------------------------

  Application Name:
  ImageSeries_InspectorP

  Summary:
  Setting up camera and taking image series of variable length, which can be started
  and stopped by external trigger

  How to Run:
  A connected InpspectorP6 device with a connected trigger source is necessary to run
  this sample. Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10).
  Set a breakpoint on the first row inside the main or processImage function to debug step-by-step.
  See the acquired images in the image viewer on the DevicePage.

  More Information:
  See the tutorial "Devices - InspectorP - TriggeringAndAcquisition".

------------------------------------------------------------------------------]]

--Start of Global Scope---------------------------------------------------------

-- Create and configure camera
local camera = Image.Provider.Camera.create()

local config = Image.Provider.Camera.V2DConfig.create()
config:setBurstLength(0) -- Continuous acquisition within series
config:setFrameRate(10) -- Hz
config:setShutterTime(700) -- us
config:setStartSource('DI1', 'ON_ACTIVE') -- Trigger start
config:setStopSource('DI1', 'ON_INACTIVE') -- Trigger stop

camera:setConfig(config)

-- Create viewer
local viewer = View.create()

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  camera:enable()
end
Script.register('Engine.OnStarted', main)

local function processImage(im, sensorData)
  viewer:clear()
  viewer:addImage(im)
  viewer:present()
  print(sensorData:toString())
end
camera:register('OnNewImage', processImage)

--End of Function and Event Scope--------------------------------------------------
