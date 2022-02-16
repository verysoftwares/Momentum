hiscore_standard=0
hiscore_chaotic=0

grid=flr(43/2+1)

srndtop={x=0,y=0}
srndbottom={x=0,y=flr(309/2)+1}

xspeed=0.065
grav=0.06

main_wld=new_world()

function init(n)
    if not audio['mewsic'..n]:isPlaying() then
        audio['mewsic'..n]:play()
    end
end

function update(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    if dt~=nil then deltat=dt end

    if love.update==update then 
        init(1) 

        if love.keyboard.isDown('escape') then
            back_to_menu()
        end
    end

    local ball=w.ball
    if ball.bonus then ball.bonus=ball.bonus-1; if ball.bonus==0 then ball.bonus=nil end end

    if love.update~=replay then ins(w.rp,{}) end
    input(w)
    if love.update==replay then w.rp.i=w.rp.i+1 end

    for i,s in ipairs(w.shifters) do
        if s.update then s.update(s,w) end
    end

    local args={_sc={},c=0,spd=speed(ball)}
    collide(ball,args,w)
    
    ball.dy=ball.dy+grav

    ball.x=ball.x+ball.dx
    ball.y=ball.y+ball.dy
    
    spawn(w)

    bonus_mvmt(w)

    floaters_update(w)

    if w.t>0 then 
        w.score=w.score+1 
        if w.mode=='Standard' and w.score>=5000 and not cycle_unlocks['Gallery'] and not find(unlocks,'Gallery') then
            ins(unlocks,'Gallery')
        end
        if w.mode=='Standard' and w.score>=10000 and not cycle_unlocks['Chaotic'] and not find(unlocks,'Chaotic') then
            ins(unlocks,'Chaotic')
        end
    end

    w.t = w.t+1
end

function floaters_update(w)
    for i,s in ipairs(w.shouts) do s.proc=false end
    for i=#w.shouts,1,-1 do
        local s=w.shouts[i]
        for i2,s2 in ipairs(w.shouts) do
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
        if s.t>90 then rem(w.shouts,i) end
    end

    for i=#w.particles,1,-1 do
        local p=w.particles[i]    
        p.i = p.i or i
        p.x=p.x+p.dx; p.y=p.y+p.dy
        p.dy=p.dy+grav
        if p.y>=309 then rem(w.particles,i) end
    end
end

function gameover(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    if love.keyboard.isDown('escape') then
        back_to_menu()
    end
    if tapped('r') then
        reset()
        return
    end
    floaters_update(w)

    w.t=w.t+1
end

function show_unlocks(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    if tapped('z') or tapped('return') then
        rem(unlocks,1)
        if #unlocks>0 then 
            love.update=show_unlocks
            unlock_ty=309
        else
            love.update=gameover
            sc_t=w.t+1
        end
    end
    floaters_update(w)

    w.t=w.t+1
end

function replay(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    if dt~=nil then deltat=dt end

    if love.keyboard.isDown('escape') then
        back_to_menu()
    end
    if tapped('r') then
        love.update=update
        reset(w)
        return
    end
    if w.rp.i==1 then reset(w) end
    update(dt,w)
    --t=t+1
end

function tutor(dt,w)
    w = w or main_wld
    st=love.timer.getTime()
    deltat=dt

    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or love.keyboard.isDown('left') or love.keyboard.isDown('right') then
    reset()
    return
    end

    w.t=w.t+1
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