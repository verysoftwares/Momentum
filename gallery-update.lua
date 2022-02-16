cycle2={i=1,'Most recent first','Highest score first'}

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

    if gall_state==nil and gallery[1] and tapped('z') then
        love.update=rp_zoom
        love.draw=galleryzoom
    end

    t=t+1
end

function rp_zoom(dt,w)
    w=w or main_wld
    st=love.timer.getTime()
    deltat=dt

    if tapped('escape') then
        love.update=rp_gallery
        love.draw=gallerydraw
    end

    t=t+1
end
