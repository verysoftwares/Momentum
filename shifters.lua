-- the given update function for moving shifters
-- (when not moving, their update is nil)

function shiftupdate(s,w)
    local oncoll=function()
        s.x=s.x-s.dx
        s.y=s.y-s.dy
        s.update=nil
    end

    if s.spec then oncoll=function(args,ent2)
        s.x=s.x-s.dx
        s.y=s.y-s.dy
        s.dx=-s.dx
        s.dy=-s.dy
        if ent2 and ent2.spec then
        ent2.x=ent2.x-ent2.dx
        ent2.y=ent2.y-ent2.dy
        ent2.dx=-ent2.dx
        ent2.dy=-ent2.dy
        end
        return true
    end end
    
    if s.t<20 then
        if s.t%3==0 then s.x=s.x+s.dx; s.y=s.y+s.dy end
    else
        s.x=s.x+s.dx; s.y=s.y+s.dy
    end

    pixelperfect(s,shifterdata,srndtop,surroundtopdata,oncoll)
    pixelperfect(s,shifterdata,srndbottom,surroundbottomdata,oncoll)

    for i2,s2 in ipairs(w.shifters) do
    if s2~=s then
        pixelperfect(s,shifterdata,s2,shifterdata,oncoll)
    end
    end

    s.t=s.t+1
end

-- shifter starts to move
function shift(s,w)
    if w.ball.x+13>s.x+grid then s.dx=1 
    else s.dx=-1 end
    if w.ball.y+13>s.y+grid then s.dy=1 
    else s.dy=-1 end
    if not (s.spec and s.t) then
    s.t=0
    end

    -- first time moving -> add spawner
    if s.myspawn==nil then
    if w.mode=='Standard' then
        ins(w.spawners,{t=w.spawn_t,x=s.x,y=s.y})
        s.myspawn=w.spawners[#w.spawners]
        w.spawn_t=w.spawn_t+w.spawn_dt
    elseif w.mode=='Chaotic' then    
        ins(w.spawners,{t=math.max(w.spawn_t,w.score+w.spawn_dt),x=s.x,y=s.y,spec=s.spec})
        s.myspawn=w.spawners[#w.spawners]
        w.spawn_t=w.spawn_t+w.spawn_dt
        if w.spawn_dt>100 then w.spawn_dt=w.spawn_dt-50 end
        --print(spawners[#spawners].t, spawn_t)
        end
    end

    s.update=shiftupdate
end

-- spawn new shifter and powerup.
-- called every frame
function spawn(w)
    for i=#w.spawners,1,-1 do
    local sp=w.spawners[i]
    local spawnblocked=false
    if w.score>=sp.t then
        for i2,s2 in ipairs(w.shifters) do
        pixelperfect(sp,shifterdata,s2,shifterdata,function(args)
            spawnblocked=true
            return true
        end)
        if spawnblocked then goto skip end
        end

        ins(w.bonuses,{x=sp.x+12,y=sp.y-12,dx=0,dy=-1.5,img=lg.newCanvas(26,26)})
        if w.bonuses[#w.bonuses].x<309/2 then w.bonuses[#w.bonuses].dx=1.5
        else w.bonuses[#w.bonuses].dx=-1.5 end
        lg.setCanvas(w.bonuses[#w.bonuses].img)
        fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
        circ('fill',13,13,13)
        fg(0xf0/255.0,0xa0/255.0,0xb0/255.0)
        circ('fill',13,13,12.8)
        lg.setCanvas()        
        w.bonuses[#w.bonuses].imgdata=w.bonuses[#w.bonuses].img:newImageData()
        --if not bonusimg then bonusdata=bonuses[#bonuses].img end

        ::skip::
        ins(w.shifters,{x=sp.x,y=sp.y})
        if w.mode=='Chaotic' and not sp.spec then 
            prep_spec(w.shifters[#w.shifters],w,spawnblocked)
        end
        if spawnblocked then
            particlespam(w.shifters[#w.shifters],w)
            playsnd(audio.crush)
            rem(w.shifters,#w.shifters)
        end
        rem(w.spawners,i)
    end
    end
end

-- check if all colliding shifters
-- travel to the same direction.
-- returns 1 if true, else 0 or 2
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

-- initializing red shifters
function prep_spec(s,w,spawnblocked)
    s.spec=true
    if not spawnblocked then
    shift(s,w)
    end
    s.dy=-1
    if s.x<309/2 then s.dx=1
    else s.dx=-1 end
end