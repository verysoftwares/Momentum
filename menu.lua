cycle={i=1,'Standard','Chaotic','Gallery','Options','Quit'}
cycle2={i=1,'Most recent first','Highest score first'}
cycle_unlocks={}
--for i=1,#cycle do
--    cycle_unlocks[cycle[i]]=false
--end
cycle_unlocks['Standard']=true
cycle_unlocks['Options']=true
cycle_unlocks['Quit']=true

gallery={}

function menu(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    if t==0 then init(3) end
    if audio.mewsic2:tell()>=4.6252154195011-2 then
        audio.mewsic3:stop()
    end

    if ctrl then
        cycle.x=cycle.x or 309/2-smolfont:getWidth(visualize(cycle[cycle.i]))/2
        if tapped('left') then 
            cycle.dx=8
            cycle.flip=nil
        elseif tapped('right') then 
            cycle.dx=-8
            cycle.flip=nil
        end
        if tapped('z') or tapped('return') then 
            if cycle[cycle.i]=='Standard' then
                sc_t=t+1
                title='MOMENTUM'
                w.mode='Standard'
                reset(w)
                audio.shutter:seek(2.603)
                playsnd(audio.shutter)
                love.update = menufade
                love.draw = menufadeout
                --love.update = tutor
                --love.draw = gamedraw
                return
            end
            if cycle[cycle.i]=='Chaotic' and cycle_unlocks[cycle[cycle.i]] then
                sc_t=t+1
                title='MOMENTUM'
                w.mode='Chaotic'
                reset(w)
                audio.shutter:seek(2.603)
                playsnd(audio.shutter)
                love.update = menufade
                love.draw = menufadeout
                return
            end
            if cycle[cycle.i]=='Gallery' and cycle_unlocks[cycle[cycle.i]] then
                sc_t=t+1
                title='MOMENTUM'
                love.update = menufade
                love.draw = galleryfadein
                return
            end
            if cycle[cycle.i]=='Quit' then
                love.event.push('quit')
            end
        end

        if cycle.dx then
            cycle.x=cycle.x+cycle.dx
            if cycle.dx>0 and cycle.x>=309 then 
                cycle.i=cycle.i-1; if cycle.i<1 then cycle.i=#cycle end
                cycle.x=-smolfont:getWidth(visualize(cycle[cycle.i])); cycle.flip=true 
            elseif cycle.dx<0 and cycle.x<-smolfont:getWidth(visualize(cycle[cycle.i])) then 
                cycle.i=cycle.i+1; if cycle.i>#cycle then cycle.i=1 end
                cycle.x=309; cycle.flip=true 
            end
            local ctx=309/2-smolfont:getWidth(visualize(cycle[cycle.i]))/2
            if cycle.flip and ((cycle.dx>0 and cycle.x>=ctx) or (cycle.dx<0 and cycle.x<=ctx)) then
                cycle.x=ctx
                cycle.dx=nil
                cycle.flip=nil
            end
        end
    end
    t=t+1
end

-- how to display current selection in cycle
function visualize(c)
    if love.update~=rp_gallery then
    if cycle_unlocks[c] then
        return '< '..c..' >'
    end
    return '< ??? >'
    end
    if love.update==rp_gallery then
        if gall_state==nil then return c end
        if gall_state=='sort' then return '< '..c..' >' end
    end
end

function menufade(dt)
    st=love.timer.getTime()
    deltat=dt
    
    t=t+1
end

function rp_gallery(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    init(4)

    if tapped('escape') then
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
    if cycle2.dx then
        cycle2.x=cycle2.x+cycle2.dx
        if cycle2.dx>0 and cycle2.x>=309 then 
            cycle2.i=cycle2.i-1; if cycle2.i<1 then cycle2.i=#cycle2 end
            cycle2.x=-smolfont:getWidth(visualize(cycle2[cycle2.i])); cycle2.flip=true 
        elseif cycle2.dx<0 and cycle2.x<-smolfont:getWidth(visualize(cycle2[cycle2.i])) then 
            cycle2.i=cycle2.i+1; if cycle2.i>#cycle2 then cycle2.i=1 end
            cycle2.x=309; cycle2.flip=true 
        end
        local ctx=309/2-smolfont:getWidth(visualize(cycle2[cycle2.i]))/2
        if cycle2.flip and ((cycle2.dx>0 and cycle2.x>=ctx) or (cycle2.dx<0 and cycle2.x<=ctx)) then
            cycle2.x=ctx
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
            cycle2.dx=nil
            cycle2.flip=nil
        end
    end


    t=t+1
end

unlocks={}