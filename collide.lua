-- pixel-perfect collisions.
-- takes 'oncoll' callback function as argument. 
function pixelperfect(ent1,imgdata1,ent2,imgdata2,oncoll,args)
    for y=imgdata1:getHeight()-1,0,-1 do
    for x=imgdata1:getWidth()-1,0,-1 do
        local r,g,b,a=imgdata1:getPixel(x,y)

        if a==1 then
            local sx=ent1.x-ent2.x+x
            local sy=ent1.y-ent2.y+y

            if sx>=0 and sx<imgdata2:getWidth() and sy>=0 and sy<imgdata2:getHeight() then
                local r2,g2,b2,a2=imgdata2:getPixel(flr(sx),flr(sy))

                if a2==1 then
                    if oncoll(args) then return end
                end
            end
        end
    end
    end
end

-- ball collision setup
function collide(_ball,args,w)
    args.aligned=false
    args.touch=false
    
    ballcollide(_ball,args,w)
    c=args.c

    -- collisions forgiven for 5 frames
    if c>29 then
        _ball.lethalt=_ball.lethalt+1
        if _ball.lethalt<=5 then c=0 end
    else
        _ball.lethalt=0
    end
    local scsame=check_same(args._sc)

    -- _ball is destroyed
    if (c>29 and (_ball.lethalt>=5 or headon(args._sc)) and (#args._sc>=2 and scsame~=1)) or _ball.y>=309 then 
        if not (_ball.y>=309) then
            particlespam(_ball,w)
            playsnd(audio.crush)
        else
            playsnd(audio.fall)
        end
        _ball.lethalt=0

        if _ball==w.ball then
            local rep=love.update==replay
            sc_t=w.t+1; 
            if w.score+1>_G['hiscore_'..string.lower(w.mode)] then _G['hiscore_'..string.lower(w.mode)]=w.score+1 end
            if #unlocks>0 then
            for i,u in ipairs(unlocks) do cycle_unlocks[u]=true end
            love.update=show_unlocks
            unlock_ty=309
            else
            love.update=gameover
            end 
            if not find(gallery,w.rp) then 
                ins(gallery,w.rp) 
                w.rp.score=w.score+1
                w.rp.mode=w.mode
                w.rp.time=os.time()
            end
            if not rep then saveprogress(w) end
        else
            rem(w.bonuses,args.i)
            args.removed=true
        end
    end
end

-- collide with top of the map
-- and with all shifters
function ballcollide(_ball,args,w)
    args._ball=_ball
    args.w=w
    pixelperfect(args._ball,args._ball.imgdata,srndtop,surroundtopdata,ceilcoll,args)
    for i=#w.shifters,1,-1 do
        local s=w.shifters[i]
        args.si=i; args.s=s
        pixelperfect(args._ball,args._ball.imgdata,s,shifterdata,solidcoll,args)
    end
end

-- top of the map
function ceilcoll(args)
    if not find(args._sc,srndtop) then
        ins(args._sc,srndtop)
    end
    args.c=args.c+1
    local yforce=1+args.spd*0.4
    local xforce=yforce*0.5
    args._ball.dy=yforce
    if args._ball.x+13<309/2 then
    args._ball.dx=xforce
    else
    args._ball.dx=-xforce
    end
end

-- shifters
function solidcoll(args)
    if args._ball==args.w.ball and args.w.ball.bonus then
        particlespam(args.s,args.w)
        rem(args.w.shifters,args.si)
        args.w.score=args.w.score+250
        playsnd(audio.crush)
        shout(250,args.w.ball.x+13,args.w.ball.y+13,args.w)
        return true
    end

    if not find(args._sc,args.s) then
        ins(args._sc,args.s)
    end
    args.c=args.c+1
    if not args.touch and args._ball==args.w.ball then
        args.w.score=args.w.score+20
        shout(20,args.w.ball.x+13,args.w.ball.y+13,args.w)
        playsnd(audio.bump)
        args.touch=true
    end
    if args._ball==args.w.ball and not args.s.update then shift(args.s,args.w) end

    NESWalign(args)
end

-- align ball/powerup based on collision data
function NESWalign(args)
    local yforce=1+args.spd*0.4
    local xforce=yforce*0.5
    
    if args._ball.y+13<args.s.y+grid then
        
        args._ball.dy=-yforce
        
        if args._ball.x+13>=args.s.x+grid then
            --print('solidcoll northeast',t)
            local tx=args.s.x+40-2-math.abs(args._ball.y-args.s.y)
            if tx>=args._ball.x then aligned=true; args._ball.x=tx end
            if args._ball~=ball then args._ball.dx=xforce end
        else
            --print('solidcoll northwest',t)
            local tx=args.s.x-20+math.abs(args._ball.y-args.s.y)
            if tx<args._ball.x then aligned=true; args._ball.x=tx end
            if args._ball~=ball then args._ball.dx=-xforce end
        end
    else
        
        args._ball.dy=yforce
        
        if args._ball.x+13<=args.s.x+grid then
            --print('solidcoll southwest',t)
            local tx=args.s.x-28-8+math.abs(args._ball.y-args.s.y)
            if tx<args._ball.x then aligned=true; args._ball.x=tx end
            if args._ball~=ball then args._ball.dx=-xforce end
        else
            --print('solidcoll southeast',t)
            local tx=args.s.x+40+8+8-2-math.abs(args._ball.y-args.s.y)
            if tx>=args._ball.x then aligned=true; args._ball.x=tx end
            if args._ball~=ball then args._ball.dx=xforce end
        end
    end
end

function headon(_sc)
    for i,s in ipairs(_sc) do
    for i2,s2 in ipairs(_sc) do
        if s.dx==-s2.dx and s.dy==-s2.dy then
            return true
        end
    end
    end
    return false
end
