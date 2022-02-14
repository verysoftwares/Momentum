cycle={i=1,'Standard','Chaotic','Gallery','Options','Quit'}
cycle_unlocks={}
--for i=1,#cycle do
--    cycle_unlocks[cycle[i]]=false
--end
cycle_unlocks['Standard']=true
cycle_unlocks['Options']=true
cycle_unlocks['Quit']=true

gallery={}

function menu(dt)
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
                mode='Standard'
                reset()
                love.update = menufade
                love.draw = menufadeout
                --love.update = tutor
                --love.draw = gamedraw
                return
            end
            if cycle[cycle.i]=='Chaotic' and cycle_unlocks[cycle[cycle.i]] then
                sc_t=t+1
                title='MOMENTUM'
                mode='Chaotic'
                reset()
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
                cycle.x=309/2-smolfont:getWidth(visualize(cycle[cycle.i]))/2
                cycle.dx=nil
                cycle.flip=nil
            end
        end
    end
    t=t+1
end

-- how to display current selection in cycle
function visualize(c)
    if cycle_unlocks[c] then
        return '< '..c..' >'
    end
    return '< ??? >'
end

function menufade(dt)
    st=love.timer.getTime()
    deltat=dt
    
    t=t+1
end

function rp_gallery(dt)
    st=love.timer.getTime()
    deltat=dt

    gallery.i=gallery.i or 1
    if tapped('left') and gallery[1] then 
        gallery.i=gallery.i-1
        if gallery.i<1 then gallery.i=1 end
        rp=gallery[gallery.i]
        rp.i=1
        reset(true)
        preview1=nil; preview2=nil
    elseif tapped('right') and gallery[1] then 
        gallery.i=gallery.i+1
        if gallery.i>#gallery then gallery.i=#gallery end
        rp=gallery[gallery.i]
        rp.i=1
        reset(true)
        preview1=nil; preview2=nil
    end

    t=t+1
end

unlocks={}