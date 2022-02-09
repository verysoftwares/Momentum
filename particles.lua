particles={}
function particlespam(ent)
    local chunksize=6
    if find(shifters,ent) then
        chunksplit(ent,images.shift,chunksize)
    elseif ent==ball then
        chunksplit(ent,ball.img,chunksize)
    elseif find(bonuses,ent) then
        chunksplit(ent,ent.img,chunksize)
    end
end

function chunksplit(who,img,chunksize)
    for y=0,img:getHeight(),chunksize do
    for x=0,img:getWidth(),chunksize do
        local prt= lg.newCanvas(chunksize,chunksize)
        lg.setCanvas(prt)
        lg.draw(img,-x,-y)
        lg.setCanvas()
        ins(particles, {x=who.x+x,y=who.y+y,dx=0,dy=0,img=prt})
        particles[#particles].dx=(random(10,30)-20)*0.08
        particles[#particles].dy=(random(0,20)-20)*0.08
    end
    end    
end