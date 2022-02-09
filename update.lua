debug=false

score=0

grid=flr(43/2+1)

ball={x=309/2-12, y=96, dx=0, dy=0, img=lg.newCanvas(26,26)}
lg.setCanvas(ball.img)
fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
circ('fill',13,13,13)
fg(0xf0/255.0,0xf0/255.0,0xf0/255.0)
circ('fill',13,13,12.8)
lg.setCanvas()
ball.imgdata=ball.img:newImageData()
ball.lethalt=0

bonuses={}
plrbonus=0
if debug then plrbonus=10 end

shifters={}
for i=1,5 do
    local sx,sy=grid*i+1,309/2-grid+grid*i+1
    ins(shifters,{x=sx,y=sy})
    ins(shifters,{x=309-sx-43,y=sy})
end
spawn_t=2000

srndtop={x=0,y=0}
srndbottom={x=0,y=flr(309/2)+1}

xspeed=0.065
grav=0.06

rp={i=1}

function init()
    if not audio.mewsic:isPlaying() then
        audio.mewsic:play()
    end
end

function update(dt)
    local st=love.timer.getTime()
    
    init()

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if ball.bonus then ball.bonus=ball.bonus-1; if ball.bonus==0 then ball.bonus=nil end end

    if love.update~=replay then ins(rp,{}) end
    input()
    if love.update==replay then rp.i=rp.i+1 end

    for i,s in ipairs(shifters) do
        if s.update then s.update(s) end
    end

    local args={_sc={},c=0,spd=speed(ball)}
    collide(ball,args)
    
    ball.dy=ball.dy+grav

    ball.x=ball.x+ball.dx
    ball.y=ball.y+ball.dy
    
    spawn()

    bonus_mvmt()

    if t>0 then score=score+1 end

    local et=love.timer.getTime()
    while dt+et-st<1/60 do et=love.timer.getTime() end
    
    t = t+1
end

function gameover(dt)
    local st=love.timer.getTime()

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
    if tapped('r') then
        love.update=update
        reset()
        return
    end

    local et=love.timer.getTime()
    while dt+et-st<1/60 do et=love.timer.getTime() end

    t=t+1
end

function replay(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
    if tapped('r') then
        love.update=update
        reset()
        return
    end
    if rp.i==1 then reset() end
    update(dt)
    --t=t+1
end

function tutor(dt)
    local st=love.timer.getTime()

    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or love.keyboard.isDown('left') or love.keyboard.isDown('right') then
    reset()
    return
    end

    local et=love.timer.getTime()
    while dt+et-st<1/60 do et=love.timer.getTime() end

    t=t+1
end

function reset()
    score=0
    ball.x=309/2-12; ball.y=96; ball.dx=0; ball.dy=0; ball.bonus=nil
    plrbonus=0
    if debug then plrbonus=10 end
    bonuses={}

    shifters={}
    for i=1,5 do
        local sx,sy=grid*i+1,309/2-grid+grid*i+1
        ins(shifters,{x=sx,y=sy})
        ins(shifters,{x=309-sx-43,y=sy})
    end
    spawn_t=2000
    spawners={}

    shouts={}

    if love.update~=replay then 
        rp={i=1} 
        love.update=update
    end

    t=0
end

--love.update= update
love.update=tutor