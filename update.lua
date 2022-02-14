score=0
hiscore_standard=0
hiscore_chaotic=0

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
spawn_dt=1000

srndtop={x=0,y=0}
srndbottom={x=0,y=flr(309/2)+1}

xspeed=0.065
grav=0.06

rp={i=1}

function init(n)
    if not audio['mewsic'..n]:isPlaying() then
        audio['mewsic'..n]:play()
    end
end

function update(dt)
    st=love.timer.getTime()
    if dt~=nil then deltat=dt end

    if love.update==update then init(1) end

    if love.keyboard.isDown('escape') then
        back_to_menu()
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

    for i,s in ipairs(shouts) do s.proc=false end
    for i=#shouts,1,-1 do
        local s=shouts[i]
        for i2,s2 in ipairs(shouts) do
            if not s2.proc and not s.proc and s2~=s and AABB(s2.x,s2.y,smolfont:getWidth(s2.msg),8,s.x,s.y,smolfont:getWidth(s.msg),8) then
            s2.x=s2.x+2
            s.x=s.x-2
            s.y=s.y-1
            s2.y=s2.y+1
            s.proc=true; s2.proc=true
            end
        end
        s.y=s.y-1
        s.t=s.t+1
        if s.t>90 then rem(shouts,i) end
    end

    for i=#particles,1,-1 do
        local p=particles[i]    
        p.i = p.i or i
        p.x=p.x+p.dx; p.y=p.y+p.dy
        p.dy=p.dy+grav
        if p.y>=309 then rem(particles,i) end
    end

    bonus_mvmt()

    if t>0 then 
        score=score+1 
        if mode=='Standard' and score>=5000 and not cycle_unlocks['Gallery'] and not find(unlocks,'Gallery') then
            ins(unlocks,'Gallery')
        end
        if mode=='Standard' and score>=10000 and not cycle_unlocks['Chaotic'] and not find(unlocks,'Chaotic') then
            ins(unlocks,'Chaotic')
        end
    end

    t = t+1
end

function gameover(dt)
    st=love.timer.getTime()
    deltat=dt

    if love.keyboard.isDown('escape') then
        back_to_menu()
    end
    if tapped('r') then
        reset()
        return
    end

    t=t+1
end

function show_unlocks(dt)
    st=love.timer.getTime()
    deltat=dt

    if tapped('z') or tapped('return') then
        rem(unlocks,1)
        if #unlocks>0 then 
            love.update=show_unlocks
            unlock_ty=309
        else
            love.update=gameover
            sc_t=t+1
        end
    end

    t=t+1
end

function replay(dt)
    st=love.timer.getTime()
    if dt~=nil then deltat=dt end

    if love.keyboard.isDown('escape') then
        back_to_menu()
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
    st=love.timer.getTime()
    deltat=dt

    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or love.keyboard.isDown('left') or love.keyboard.isDown('right') then
    reset()
    return
    end

    t=t+1
end

function reset(noresettime)
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
    spawn_dt=1000
    spawners={}

    shouts={}

    if love.update~=replay and love.update~=rp_gallery then 
        rp={i=1} 
        love.update=update
    end

    if not noresettime then
    t=0
    end
end

function back_to_menu()
    love.update=menufade
    love.draw=menufadein
    old_canvas=old_canvas or lg.newCanvas(309*scale,309*scale)
    local cn=lg.getCanvas()
    lg.setCanvas(old_canvas)
    fg(1,1,1,1)
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas2,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)
    lg.setCanvas(cn)
    cycle.x=309/2-smolfont:getWidth(visualize(cycle[cycle.i]))/2
    cycle.dx=nil
    cycle.flip=nil
    onlyoncem2=nil
end

--love.update= update