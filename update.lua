debug=false

score=0

shifters={}
grid=flr(43/2+1)

ball={x=309/2-12, y=96, dx=0, dy=0, img=lg.newCanvas(26,26)}
lg.setCanvas(ball.img)
fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
circ('fill',13,13,13)
fg(0xf0/255.0,0xf0/255.0,0xf0/255.0)
circ('fill',13,13,12.8)
lg.setCanvas()
ball.imgdata=ball.img:newImageData()
plrbonus=0
if debug then plrbonus=10 end

for i=1,5 do
    local sx,sy=grid*i+1,309/2-grid+grid*i+1
    ins(shifters,{x=sx,y=sy})
    ins(shifters,{x=309-sx-43,y=sy})
end
spawn_t=2000
ball.lethalt=0

bonuses={}

rp={i=1}

srndtop={x=0,y=0}
srndbottom={x=0,y=flr(309/2)+1}

xspeed=0.065
grav=0.06

function init()
    if not audio.mewsic:isPlaying() then
        audio.mewsic:play()
    end
end

function playsnd(snd)
    snd:stop(); snd:play()
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

function input()
    local press=false
    if ((love.keyboard.isDown('a') or love.keyboard.isDown('left')) and love.update~=replay) or (love.update==replay and find(rp[rp.i],'a')) then
        press=true
        if ball.dx > -1 then
            ball.dx = ball.dx-math.abs((ball.dx-(-1))/2.0)
        end
        ball.dx=ball.dx-xspeed
        if love.update~=replay then ins(rp[#rp],'a') end
    end
    if ((love.keyboard.isDown('d') or love.keyboard.isDown('right')) and love.update~=replay) or (love.update==replay and find(rp[rp.i],'d')) then
        press=true
        if ball.dx < 1 then
            ball.dx = ball.dx+math.abs((ball.dx-1)/2.0)
        end
        ball.dx=ball.dx+xspeed
        if love.update~=replay then ins(rp[#rp],'d') end
    end
    if (plrbonus>0 and ((tapped('lshift') or tapped('rshift')) and love.update~=replay) and not ball.bonus) or (love.update==replay and find(rp[rp.i],'shift')) then
        ball.bonus=65
        plrbonus=plrbonus-1
        audio.powerup:stop()
        audio.powerup:play()
        --print('bonus')
        if love.update~=replay then ins(rp[#rp],'shift') end
    end
    if not press then
        ball.dx=ball.dx*0.98
    end
end

function bonus_mvmt()
    for i=#bonuses,1,-1 do
        local bn=bonuses[i]
        bn.t=bn.t or 0
        bn.lethalt=bn.lethalt or 0
        local args={_sc={},c=0,spd=speed(bn),bn=bn}
        if bn.t>=8 then
            collide(bn,args)
            if args.removed then goto removed end
        end
        bn.t=bn.t+1

        bn.dy=bn.dy+grav

        bn.x=bn.x+bn.dx
        bn.y=bn.y+bn.dy
        --bn.dx=bn.dx*0.98

        pixelperfect(bn,bn.imgdata,ball,ball.imgdata,function(args)
            plrbonus=plrbonus+1
            playsnd(audio.get)
            rem(bonuses,find(bonuses,args.bn))
            return true
        end,args)
        ::removed::
    end
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

function speed(_ball)
    return math.sqrt(math.pow(_ball.dx,2)+math.pow(_ball.dy,2))
end

shouts={}
function shout(msg,mx,my)
    ins(shouts,{msg=msg,x=mx,y=my,t=0})
end

function check_same(_sc)
    local sdx,sdy=0,0
    local scsame=0
    for i,s in ipairs(_sc) do
        if s.dx~=nil and s.dy~=nil and s.dx~=sdx and s.dy~=sdy then
            if sdx~=0 and sdy~=0 then
            scsame=2
            end
            sdx=s.dx; sdy=s.dy
        elseif s.dx~=nil and s.dy~=nil and s.dx==sdx and s.dy==sdy then
            if scsame~=2 then
                scsame=1
            end
        end
    end
    return scsame
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

--love.update= update
love.update=tutor