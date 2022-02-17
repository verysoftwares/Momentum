function loadprogress()
    local file = 'scores.soft'
    local chunk = love.filesystem.load(file)

    if chunk then chunk() 
        print(fmt('loaded persistent data from %s',file))
    else
        print(fmt('no save file %s',file))
    end 

    file = 'unlocks.soft'
    chunk = love.filesystem.load(file)

    if chunk then chunk() 
        print(fmt('loaded persistent data from %s',file))
    else
        print(fmt('no save file %s',file))
    end 

    file = 'replays.soft'
    chunk = love.filesystem.load(file)

    if chunk then chunk() 
        print(fmt('loaded persistent data from %s',file))

        for i,g in ipairs(gallery) do g.saved=true end

        if cycle2[cycle2.i]=='Most recent first' then table.sort(gallery,function(a,b) return a.time>b.time end) end
        if cycle2[cycle2.i]=='Highest score first' then table.sort(gallery,function(a,b) return a.score>b.score end) end
    else
        print(fmt('no save file %s',file))
    end

    file = 'options.soft'
    chunk = love.filesystem.load(file)

    if chunk then chunk() 
        print(fmt('loaded persistent data from %s',file))
        for i=1,4 do _G[fmt('cycle_opts%d_set',i)]() end
    else
        print(fmt('no save file %s',file))
    end
end

function saveprogress(w)
    local file = 'scores.soft'

    local out=fmt('hiscore_standard=%d\n',hiscore_standard)
    out=out..fmt('hiscore_chaotic=%d',hiscore_chaotic)

    love.filesystem.write(file, out)

    file = 'unlocks.soft'

    out='cycle_unlocks={'
    for i,c in ipairs(cycle) do
        if cycle_unlocks[c] then
        out=out..c..'=true,'
        end
    end
    out=out..'}'

    love.filesystem.write(file, out)

    file = 'replays.soft'

    local info = love.filesystem.getInfo('replays.soft', {})
    if not info then
        out='gallery={}\n'
        love.filesystem.write(file, out)
    end    
    out=''
    for i,rp in ipairs(gallery) do
        if not rp.saved then
        out=out..'ins(gallery,{'
        for j,keys in ipairs(rp) do
            out=out..'{'
            for k,key in ipairs(keys) do
                out=out..'\''..key..'\''..','
            end
            out=out..'},'
        end
        out=out..fmt('score=%d,',rp.score)..fmt('mode=\'%s\',',rp.mode)..fmt('time=%d',rp.time)
        out=out..'})\n'
        rp.saved=true
        end
    end

    love.filesystem.append(file, out)

    file = 'options.soft'

    out=''
    for i=1,4 do
        out=out..fmt('cycle_opts%d.i=%d\n',i,_G['cycle_opts'..tostring(i)].i)
    end

    love.filesystem.write(file, out)
end