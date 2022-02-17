cycle={i=1,'Standard','Chaotic','Gallery','Options','Quit'}
cycle_opts1={i=1,'Scale=3x','Scale=4x','Scale=1x','Scale=2x'}
cycle_opts2={i=1,'Volume=100%','Volume=75%','Volume=50%','Volume=25%','Volume=0%'}
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
        if tapped('escape') then
            if cycle.i==5 then
                love.event.push('quit')
            end
            cycle.i=5
            cycle.x=309/2-smolfont:getWidth(visualize(cycle[cycle.i]))/2
            cycle.dx=nil
            cycle.flip=nil
        end
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
            if cycle[cycle.i]=='Options' then
                love.update=menuopts
                love.draw=menuopts_draw
                opts_state=cycle_opts1
                smolrect2=nil
                smolrect3=nil
                return
            end
            if cycle[cycle.i]=='Quit' then
                love.event.push('quit')
            end
        end

        cycle_act(cycle)
    end
    t=t+1
end

-- how to display current selection in cycle
function visualize(c)
    if love.update==menuopts then
        if find(opts_state,c) then return '< '..c..' >' end 
        return c 
    end
    if love.update~=rp_gallery and love.update~=rp_zoom then
    if cycle_unlocks[c] then
        return '< '..c..' >'
    end
    return '< ??? >'
    end
    if love.update==rp_gallery or love.update==rp_zoom then
        if gall_state==nil then return c end
        if gall_state=='sort' then return '< '..c..' >' end
    end
end

function menufade(dt)
    st=love.timer.getTime()
    deltat=dt
    
    t=t+1
end

function menuopts(dt,w)
    st=love.timer.getTime()
    deltat=dt
    
    if tapped('escape') or tapped('x') then
        love.update=menu
        love.draw=menudraw
    end
    cycle_opts1.x=cycle_opts1.x or 309/2-smolfont:getWidth(visualize(cycle_opts1[cycle_opts1.i]))/2
    cycle_opts2.x=cycle_opts2.x or 309/2-smolfont:getWidth(visualize(cycle_opts2[cycle_opts2.i]))/2
    if tapped('left') then 
        opts_state.dx=8
        opts_state.flip=nil
    elseif tapped('right') then 
        opts_state.dx=-8
        opts_state.flip=nil
    end
    if tapped('up') or tapped('down') then
        if opts_state==cycle_opts1 then opts_state=cycle_opts2
        else opts_state=cycle_opts1 end
    end
    cycle_act(cycle_opts1,function() 
        scale=tonumber(sub(cycle_opts1[cycle_opts1.i],7,7))
        love.window.setMode(309*scale,309*scale)
        love.window.setFullscreen(true)
    end)
    cycle_act(cycle_opts2,function() 
        vol=tonumber(sub(cycle_opts2[cycle_opts2.i],8,string.find(cycle_opts2[cycle_opts2.i],'%%')-1))
        vol=vol/100.0
        love.audio.setVolume(vol)
    end)

    t=t+1
end

function cycle_act(_cycle,swapf)
    if _cycle.dx then
        _cycle.x=_cycle.x+_cycle.dx
        if _cycle.dx>0 and _cycle.x>=309+40 then 
            _cycle.i=_cycle.i-1; if _cycle.i<1 then _cycle.i=#_cycle end
            _cycle.x=-smolfont:getWidth(visualize(_cycle[_cycle.i])); _cycle.flip=true 
        elseif _cycle.dx<0 and _cycle.x<-40-smolfont:getWidth(visualize(_cycle[_cycle.i])) then 
            _cycle.i=_cycle.i+1; if _cycle.i>#_cycle then _cycle.i=1 end
            _cycle.x=309+40; _cycle.flip=true 
        end
        local ctx=309/2-smolfont:getWidth(visualize(_cycle[_cycle.i]))/2
        if _cycle.flip and ((_cycle.dx>0 and _cycle.x>=ctx) or (_cycle.dx<0 and _cycle.x<=ctx)) then
            _cycle.x=ctx
            _cycle.dx=nil
            _cycle.flip=nil
            if swapf then swapf() end
        end
    end
end

unlocks={}