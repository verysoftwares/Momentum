loaded=false
function love.load()
    if loaded then return end
    loaded=true
    lcdfont = lg.newFont('wares/advanced_pixel_lcd-7.ttf', 20)
    smolfont = lg.newFont('wares/nokiafc22.ttf', 8)
    explainfont = lg.newFont('wares/RobotoCondensed-Regular.ttf', 18)
    titlefont = lg.newFont('wares/DaysOne-Regular.ttf', 48)
    lg.setFont(lcdfont)
    
    audio={}
    mvol=mvol or 1
    audio.mewsic1= love.audio.newSource('wares/foothold-full.ogg','stream')
    --audio.mewsic1:setVolume(0.7)
    audio.mewsic1:setLooping(true)
    audio.mewsic2= love.audio.newSource('wares/foothold2.ogg','stream')
    --audio.mewsic2:setVolume(0.7)
    audio.mewsic2:setLooping(true)
    audio.mewsic3= love.audio.newSource('wares/foothold2-intro.ogg','stream')
    --audio.mewsic3:setVolume(0.7)
    audio.mewsic3:setLooping(false)
    audio.mewsic4= love.audio.newSource('wares/foothold3.ogg','stream')
    audio.mewsic4:setLooping(true)
    svol=svol or 1
    audio.bump= love.audio.newSource('wares/bump.mp3','static')
    audio.crush= love.audio.newSource('wares/340899__passairmangrace__cansmash2-crunchy-bip.wav','static')
    --audio.crush= love.audio.newSource('wares/497704__miksmusic__bone-crush-1.wav','static')
    audio.powerup= love.audio.newSource('wares/579628__neopolitansixth__riser-or-powerup-128-bpm.wav','static')
    audio.fall= love.audio.newSource('wares/202753__sheepfilms__slide-whistle.wav','static')
    audio.get= love.audio.newSource('wares/611111__5ro4__bell-ding-3.wav','static')
    audio.get:setVolume(0.7)
    audio.shutter= love.audio.newSource('wares/95120__robinhood76__01673-robotics-move.wav','static')
    audio.shutter:setVolume(0.7)
    
    images={}
    images.bg1=lg.newImage('wares/surroundbg.png')
    images.bg1_t=lg.newImage('wares/surroundbg_trans.png')
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
    images.shiftred=lg.newImage('wares/shiftred.png')
    
    images.arrow=lg.newImage('wares/shift2.png')
    images.alert=lg.newImage('wares/shift3.png')
end