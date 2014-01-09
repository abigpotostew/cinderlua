--local mult = (2)*v
--print("[Lua]",mult.x,mult.y,mult.z)

audio = nil -- in global namespace so interactive prompt can safely interact with it.

function setup()
  window.size(640,360)
    print(window)
    print(window.width..", "..window.height)
  --audio = Audio()
  --audio:loadTrack("/Users/stew/Documents/Code/Cinder/MetatronsGroove/resources/Jamelia_DJ-Kozes-Alarmclock.mp3")
  --print(audio)
  --audio:loadTrack("/Users/stew/Dropbox/Code/Cinder/MetatronsGroove/resources/Sunlight_Reigns.mp3")
  --audio:loadTrack("/Users/stew/Documents/Code/Cinder/MetatronsGroove/resources/guitar.mp3")
  print("[Lua] setup")
end

vars={}
vars.rotate_offset = 0
vars.rings = 60
vars.radius = 75
vars.r_div = 1
print("[Lua] hello objc")

local prevtime = time.seconds()

function draw()
    gl.clear(0,0,0,1)
    gl.pushMatrices()
    gl.translate(window.width/2, window.height/2)
    local radius = vars.radius
    local r2 = radius/vars.r_div
    for i=0, vars.rings do
        gl.strokedCircle(0,r2,radius)
        gl.rotate(360/vars.rings + time.seconds()) --rotate takes degrees
    end
    gl.popMatrices()
    
    if(time.seconds() - prevtime > 2) then
        prevtime = time.seconds()
        --print("YO ".. prevtime)
    end
    gl.solidCircle(0,0,100)
end


--[[function draw()
    gl.clear(0,0,0,1)
    audio:update()
    local p = Vec3(window.width/2,window.height/2,0)
    local x, y = p:xy()
    local spectrum = audio:getSpectrum()
    local size = audio:getBandCount()
    local w_step = window.width/size
    local val = 0


    gl.pushMatrices()
    local height = 100
    gl.translate(0,window.height/2)
    gl.shapeBegin(gl.LINES)
    for i=1,size do
        val=spectrum[(i-1)%size+1]
        gl.vertex2(i*w_step,-val*height)
        gl.vertex2(i*w_step,0)
    end
    gl.vertex2(0,-height)
    gl.vertex2(window.width,-height)
    gl.shapeEnd()
    gl.popMatrices()
end
--]]
