-- splits target sprite to chunks.
function particlespam(ent,w)
    local chunksize=6
    local sh=find(w.shifters,ent)
    if sh then
        if w.shifters[sh].spec then
            chunksplit(ent,images.shiftred,chunksize,w)
        else
            chunksplit(ent,images.shift,chunksize,w)
        end
    elseif ent==w.ball then
        chunksplit(ent,w.ball.img,chunksize,w)
    elseif find(w.bonuses,ent) then
        chunksplit(ent,ent.img,chunksize,w)
    end
end

function chunksplit(who,img,chunksize,w)
    for y=0,img:getHeight(),chunksize do
    for x=0,img:getWidth(),chunksize do
        local prt= lg.newCanvas(chunksize,chunksize)
        lg.setCanvas(prt)
        lg.draw(img,-x,-y)
        lg.setCanvas()
        ins(w.particles, {x=who.x+x,y=who.y+y,dx=0,dy=0,img=prt})
        w.particles[#w.particles].dx=(random(10,30)-20)*0.08
        w.particles[#w.particles].dy=(random(0,20)-20)*0.08
    end
    end    
end