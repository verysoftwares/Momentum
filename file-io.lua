function loadprogress(file)
    local file = file or 'scores.soft'
    local chunk = love.filesystem.load(file)

    if chunk then chunk() 
        print(fmt('loaded persistent data from %s',file))
        --the saved table exists now
    else
        print(fmt('no save file %s',file))
    end 

    local file = 'unlocks.soft'
    local chunk = love.filesystem.load(file)

    if chunk then chunk() 
        print(fmt('loaded persistent data from %s',file))
        --the saved table exists now
    else
        print(fmt('no save file %s',file))
    end 
end

function saveprogress(file)
    local file = file or 'scores.soft'

    local out=fmt('hiscore_standard=%d\n',hiscore_standard)
    out=out..fmt('hiscore_chaotic=%d',hiscore_chaotic)
    love.filesystem.write(file, out)

    local file = 'unlocks.soft'

    local out='cycle_unlocks={'
    for i,c in ipairs(cycle) do
        if cycle_unlocks[c] then
        out=out..c..'=true,'
        end
    end
    out=out..'}'
    love.filesystem.write(file, out)
end