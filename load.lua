function love.load()
    lcdfont = lg.newFont('wares/advanced_pixel_lcd-7.ttf', 20)
    smolfont = lg.newFont('wares/nokiafc22.ttf', 8)
    explainfont = lg.newFont('wares/RobotoCondensed-Regular.ttf', 18)
    lg.setFont(lcdfont)
    
    audio={}
    audio.mewsic= love.audio.newSource('wares/foothold-full.ogg','stream')
    audio.mewsic:setVolume(0.7)
    audio.mewsic:setLooping(true)
    audio.bump= love.audio.newSource('wares/bump.mp3','static')
    audio.crush= love.audio.newSource('wares/340899__passairmangrace__cansmash2-crunchy-bip.wav','static')
    audio.powerup= love.audio.newSource('wares/579628__neopolitansixth__riser-or-powerup-128-bpm.wav','static')
    audio.fall= love.audio.newSource('wares/202753__sheepfilms__slide-whistle.wav','static')
    audio.get= love.audio.newSource('wares/611111__5ro4__bell-ding-3.wav','static')
    audio.get:setVolume(0.7)
    
    images={}
    images.bg1=lg.newImage('wares/surroundbg.png')
    images.bg2a=lg.newImage('wares/surroundtop.png')
    images.bg2b=lg.newImage('wares/surroundbottom.png')
    
    local sd=lg.newCanvas(309,flr(309/2))
    lg.setCanvas(sd)
    bg(0,0,0,0)
    lg.draw(images.bg2a,0,0)
    lg.setCanvas()
    surroundtopdata=sd:newImageData()
    
    lg.setCanvas(sd)
    bg(0,0,0,0)
    lg.draw(images.bg2b,0,0)
    lg.setCanvas()
    surroundbottomdata=sd:newImageData()
    
    images.shift=lg.newImage('wares/shift.png')
    local scanvas=lg.newCanvas(43,43)
    lg.setCanvas(scanvas)
    fg(1,1,1,1)
    bg(0,0,0,0)
    lg.draw(images.shift,0,0)
    lg.setCanvas()
    shifterdata=scanvas:newImageData()
    
    images.arrow=lg.newImage('wares/shift2.png')
    images.alert=lg.newImage('wares/shift3.png')
end