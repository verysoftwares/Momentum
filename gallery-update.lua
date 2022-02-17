cycle2={i=1,'Most recent first','Highest score first'}
-- for skipping back in time in replays:
-- cached points in time to simulate from 
worldcache={{},{},{}}

function rp_gallery(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    init(4)

    if tapped('escape') or tapped('x') then
        love.update=menufade
        love.draw=galleryfadeout
    end

    if t-sc_t==-1 then
        gallery.i=1
        preview1=lg.newCanvas(309*scale,309*scale)
        worldprev1=new_world()
        preview2=lg.newCanvas(309*scale,309*scale)
        worldprev2=new_world()
        if #gallery>1 then
            worldprev2.rp=gallery[2]
            worldprev2.rp.i=1
            worldprev2.mode=worldprev2.rp.mode
        end
    end

    if gallery[1] and gall_state==nil and tapped('left') then 
        gallery.i=gallery.i-1
        if gallery.i<1 then gallery.i=1 
        else
        worldprev2=main_wld
        main_wld=worldprev1
        worldprev1=new_world()
        worldprev1.rp=gallery[gallery.i-1]
        if worldprev1.rp then 
            worldprev1.rp.i=1 
            worldprev1.mode=worldprev1.rp.mode
        end
        worldcache[3]=worldcache[2]
        worldcache[2]=worldcache[1]
        worldcache[1]={}
        end
        --reset(w,true)
        --preview1=nil; preview2=nil
    elseif gallery[1] and gall_state==nil and tapped('right') then 
        gallery.i=gallery.i+1
        if gallery.i>#gallery then gallery.i=#gallery
        else
        worldprev1=main_wld
        main_wld=worldprev2
        worldprev2=new_world()
        worldprev2.rp=gallery[gallery.i+1]
        if worldprev2.rp then 
            worldprev2.rp.i=1 
            worldprev2.mode=worldprev2.rp.mode
        end
        worldcache[1]=worldcache[2]
        worldcache[2]=worldcache[3]
        worldcache[3]={}
        end
    end
    if gallery[1] and gall_state==nil and tapped('down') then
        gall_state='sort'
    end
    
    cycle2.x=cycle2.x or 309/2-smolfont:getWidth(visualize(cycle2[cycle2.i]))/2
    if gall_state=='sort' then
        if tapped('left') then 
            cycle2.dx=8
            cycle2.flip=nil
        elseif tapped('right') then 
            cycle2.dx=-8
            cycle2.flip=nil
        end
        if tapped('up') then
            gall_state=nil
        end
    end

    cycle_act(cycle2,function() 
        if cycle2[cycle2.i]=='Most recent first' then table.sort(gallery,function(a,b) return a.time>b.time end) end
        if cycle2[cycle2.i]=='Highest score first' then table.sort(gallery,function(a,b) return a.score>b.score end) end
        worldprev1=new_world()
        worldprev2=new_world()
        if #gallery>1 then
            worldprev2.rp=gallery[2]
            worldprev2.rp.i=1
            worldprev2.mode=worldprev2.rp.mode
        end
        reset(main_wld,true)
        main_wld.rp=gallery[1]
        main_wld.rp.i=1
        main_wld.mode=main_wld.rp.mode
        gallery.i=1        
    end)
    
    if gall_state==nil and gallery[1] and (tapped('z') or tapped('return')) then
        love.update=rp_zoom
        love.draw=galleryzoom
    end

    t=t+1
end

function rp_zoom(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        lhold=lhold or 0
        if lhold==0 or lhold>15 then
        local skipto=main_wld.t-20
        local seektime=skipto-skipto%50
        while 1 do
            if seektime<=0 then
                seektime=0
                reset(main_wld)
                main_wld.rp.i=1
                break
            end
            if worldcache[2][seektime] then 
                main_wld=deepcopy(worldcache[2][seektime])
                main_wld.t=seektime
                break 
            end
            seektime=seektime-50
        end
        for i=seektime,skipto do
            simulate(main_wld,nil,true,true)
        end
        end
        lhold=lhold+1
    else
        lhold=nil
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        rhold=rhold or 0
        if rhold==0 or rhold>15 then
        for i=1,19 do
        simulate(main_wld,nil,true,true)
        end
        end
        rhold=rhold+1
    else
        rhold=nil
    end

    if tapped('escape') or tapped('x') then
        love.update=rp_gallery
        love.draw=gallerydraw
    end

    t=t+1
end

function simulate(w,canv,mute,nodraw)
    local old_update=love.update
    local old_draw=love.draw
    local old_playsnd=playsnd
    if mute then
    playsnd=function() end
    end
    love.update=replay
    update(nil,w)
    if mute then playsnd=old_playsnd end
    love.update=old_update
    love.draw=old_draw
    if not nodraw then
    gamedraw(true,canv,w)
    end
    if not w.rp[w.rp.i] then reset(w); w.rp.i=1 end
    if w.t>0 and w.t%50==0 then
        local target=worldcache[2]
        if w==worldprev1 then target=worldcache[1] end
        if w==worldprev2 then target=worldcache[3] end
        target[w.t]=deepcopy(w)
        --print(fmt('added cache for %d',w.t))
    end
end
