-- the given update function for moving shifters
-- (when not moving, their update is nil)
function shiftupdate(s)
    if s.t<20 then
        if s.t%3==0 then s.x=s.x+s.dx; s.y=s.y+s.dy end
    else
        s.x=s.x+s.dx; s.y=s.y+s.dy
    end

    function oncoll()
        s.x=s.x-s.dx
        s.y=s.y-s.dy
        s.update=nil
    end
    pixelperfect(s,shifterdata,srndtop,surroundtopdata,oncoll)
    pixelperfect(s,shifterdata,srndbottom,surroundbottomdata,oncoll)

    for i2,s2 in ipairs(shifters) do
    if s2~=s then
        pixelperfect(s,shifterdata,s2,shifterdata,oncoll)
    end
    end

    s.t=s.t+1
end

spawners={}
-- shifter starts to move
function shift(s)
    if ball.x+13>s.x+grid then s.dx=1 
    else s.dx=-1 end
    if ball.y+13>s.y+grid then s.dy=1 
    else s.dy=-1 end
    s.t=0

    -- first time moving -> add spawner
    if s.myspawn==nil then
    ins(spawners,{t=spawn_t,x=s.x,y=s.y})
    s.myspawn=spawners[#spawners]
    spawn_t=spawn_t+1000
    end

    s.update=shiftupdate
end

-- spawn new shifter and powerup.
-- called every frame
function spawn()
    for i=#spawners,1,-1 do
    local sp=spawners[i]
    local spawnblocked=false
    if score>=sp.t then
        for i2,s2 in ipairs(shifters) do
        pixelperfect(sp,shifterdata,s2,shifterdata,function(args)
            spawnblocked=true
            return true
        end)
        if spawnblocked then goto skip end
        end

        ins(bonuses,{x=sp.x+12,y=sp.y-12,dx=0,dy=-1.5,img=lg.newCanvas(26,26)})
        if bonuses[#bonuses].x<309/2 then bonuses[#bonuses].dx=1.5
        else bonuses[#bonuses].dx=-1.5 end
        lg.setCanvas(bonuses[#bonuses].img)
        fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
        circ('fill',13,13,13)
        fg(0xf0/255.0,0xa0/255.0,0xb0/255.0)
        circ('fill',13,13,12.8)
        lg.setCanvas()        
        bonuses[#bonuses].imgdata=bonuses[#bonuses].img:newImageData()
        --if not bonusimg then bonusdata=bonuses[#bonuses].img end

        ::skip::
        ins(shifters,{x=sp.x,y=sp.y})
        if spawnblocked then
            particlespam(shifters[#shifters])
            playsnd(audio.crush)
            rem(shifters,#shifters)
        end
        rem(spawners,i)
    end
    end
end

-- check if 2 of #_sc colliding blocks
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