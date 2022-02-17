cycle={i=1,'Standard','Chaotic','Gallery','Options','Quit'}
cycle_opts4={i=1,'Scale=3x','Scale=4x','Scale=1x','Scale=2x'}
cycle_opts3={i=1,'Fullscreen=false','Fullscreen=true'}
cycle_opts2={i=1,'Music volume=100%','Music volume=75%','Music volume=50%','Music volume=25%','Music volume=0%'}
cycle_opts1={i=1,'SFX volume=100%','SFX volume=75%','SFX volume=50%','SFX volume=25%','SFX volume=0%'}
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
                for i=2,5 do _G['smolrect'..tostring(i)]=nil end
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
    for i=1,4 do
        local co=_G['cycle_opts'..tostring(i)]
        co.x=co.x or 309/2-smolfont:getWidth(visualize(co[co.i]))/2
    end
    if tapped('left') then 
        opts_state.dx=8
        opts_state.flip=nil
    elseif tapped('right') then 
        opts_state.dx=-8
        opts_state.flip=nil
    end
    if tapped('up') then
        for i=1,4 do
        if opts_state==_G['cycle_opts'..tostring(i)] then 
            local j=i+1; if j>4 then j=1 end
            opts_state=_G['cycle_opts'..tostring(j)] 
            break
        end
        end
    end
    if tapped('down') then
        for i=1,4 do
        if opts_state==_G['cycle_opts'..tostring(i)] then 
            local j=i-1; if j<1 then j=4 end
            opts_state=_G['cycle_opts'..tostring(j)] 
            break
        end
        end
    end
    cycle_act(cycle_opts4,function() 
        scale=tonumber(sub(cycle_opts4[cycle_opts4.i],7,7))
        local fs=love.window.getFullscreen()
        love.window.setMode(309*scale,309*scale,{fullscreen=fs})
    end)
    cycle_act(cycle_opts3,function() 
        local ci=cycle_opts3[cycle_opts3.i]
        local fs=sub(ci,string.find(ci,'=')+1,#ci)
        if fs=='true' then
            love.window.setFullscreen(true)
        else print(love.window.setFullscreen(false)) end
    end)
    cycle_act(cycle_opts1,function() 
        local ci=cycle_opts1[cycle_opts1.i]
        svol=tonumber(sub(ci,string.find(ci,'=')+1,string.find(ci,'%%')-1))
        svol=svol/100.0
        local sfx={'bump','crush','powerup','fall','get','shutter'}
        for i,v in ipairs(sfx) do
            if v=='get' or v=='shutter' then
                audio[v]:setVolume(svol*0.7)
            else
                audio[v]:setVolume(svol)
            end
        end
        playsnd(audio[sfx[random(#sfx)]])
    end)
    cycle_act(cycle_opts2,function() 
        local ci=cycle_opts2[cycle_opts2.i]
        mvol=tonumber(sub(ci,string.find(ci,'=')+1,string.find(ci,'%%')-1))
        mvol=mvol/100.0
        for i=1,4 do
            audio['mewsic'..tostring(i)]:setVolume(mvol)
        end
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