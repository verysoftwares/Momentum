-- draw setup
    lg.setDefaultFilter('nearest')
    
canvas=lg.newCanvas(309,309)
canvas2=lg.newCanvas(309,309)

function draw()
    lg.setCanvas(canvas)
    bg(153/255.0,152/255.0,100/255.0)
    fg(1,1,1,1)
    lg.draw(images.bg1)

    lg.setCanvas(canvas2)
    bg(0,0,0,0)

    -- trails
    for i,s in ipairs(shifters) do
        local r=0
        if s.update then
            local ox,oy=0,-1
            if s.dx==1 and s.dy==1 then r=pi/2; ox=-grid/2+6+24; oy=-grid/2+6-12+2 end
            if s.dx==-1 and s.dy==1 then r=pi; ox=-grid+10; oy=-grid-10+3 end
            if s.dx==-1 and s.dy==-1 then r=pi/2*3; ox=-grid/2-6; oy=-grid/2-4+1 end
            lg.push()
            lg.translate(s.x+grid/2,s.y+grid/2)
            lg.rotate(r-pi/4)
            fg(0xf0/255.0,0xb0/255.0,0x90/255.0,0.6)
            local lol=30
            if r==pi/2*3 then lol=29 end
            rect('fill',ox,oy, 309, lol)
            lg.pop()
            fg(1,1,1,1)
        end
    end

    -- actual shifters
    for i,s in ipairs(shifters) do
        lg.draw(images.shift,flr(s.x),flr(s.y))
        if s.update then
            local r=0
            if s.dx==1 and s.dy==1 then r=pi/2; end
            if s.dx==-1 and s.dy==1 then r=pi end
            if s.dx==-1 and s.dy==-1 then r=pi/2*3; end
            lg.draw(images.arrow,flr(s.x+grid),flr(s.y+grid),r,1,1,grid,grid)
        end
    end

    for i,sp in ipairs(spawners) do
        if score+500>=sp.t then
            if t%32<16 then
            lg.draw(images.alert,flr(sp.x),flr(sp.y))
            end
            lg.setFont(smolfont)
            lg.print(sp.t-score,flr(sp.x)+8+4+2,flr(sp.y)+grid-2-2-1)
        end
    end

    for i=#bonuses,1,-1 do
        local b=bonuses[i]
        lg.draw(b.img,flr(b.x),flr(b.y))
    end

    if love.update~=gameover then
    if ball.bonus then
        local r,g,b,a=HSL((t*6)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
    else
        fg(1,1,1,1)
    end
    lg.draw(ball.img,flr(ball.x),flr(ball.y))
    end

    lg.setFont(smolfont)
    for i,s in ipairs(shouts) do s.proc=false end
    for i=#shouts,1,-1 do
        local s=shouts[i]
        lg.print(s.msg,s.x,s.y)
        for i2,s2 in ipairs(shouts) do
            if not s2.proc and not s.proc and s2~=s and AABB(s2.x,s2.y,smolfont:getWidth(s2.msg),8,s.x,s.y,smolfont:getWidth(s.msg),8) then
            s2.x=s2.x+2
            s.x=s.x-2
            s.y=s.y-1
            s2.y=s2.y+1
            s.proc=true; s2.proc=true
            end
        end
        s.y=s.y-1
        s.t=s.t+1
        if s.t>90 then rem(shouts,i) end
    end

    lg.draw(images.bg2a)
    lg.draw(images.bg2b,0,flr(309/2)+1)

    if plrbonus>0 then
    local r,g,b,a=lg.getColor()
    --fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
    --circ('fill',309-60-12,309-40+12,13)
    fg(0xf0/255.0,0xa0/255.0,0xb0/255.0)
    circ('fill',309-60-12,309-40+12,12.8)
    fg(r,g,b,a)
    lg.setFont(smolfont)
    lg.print('Shift to use.',309-60-12,309-40+12+12+4)
    end

    lg.setFont(lcdfont)
    lg.push()
    lg.rotate(-pi/4)
    if love.update~=gameover or (love.update==gameover and t%64<32) then
    lg.print(fmt('%.5d',score),-60+4,15+60+15)
    end
    lg.setFont(lcdfont)
    if plrbonus>0 then lg.print(plrbonus,-60+4+20+20,15+60+15+15+260) end
    lg.pop()
    if love.update==replay then
    lg.push()
    lg.rotate(pi/4)
    if t%64<32 then
    local r,g,b,a=lg.getColor()
    fg(0xb0/255,0x20/255,0x40/255,1)
    lg.print('REPLAY',60+80+10+1,-60-80+20-12+2+2)
    fg(r,g,b,a)
    end
    lg.pop()
    end

    if love.update==gameover then
    lg.setFont(smolfont)
    local tx=309/2-smolfont:getWidth('GAME OVER')/2
    for c=1,#('GAME OVER') do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('GAME OVER',c,c),tx,309/2-40+2+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('GAME OVER',c,c))
    end
    tx=309/2-smolfont:getWidth('R to reset.')/2
    for c=1,#('R to reset.') do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('R to reset.',c,c),tx,309/2+14-40+2)--+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('R to reset.',c,c))
    end
    if t-sc_t>=90 then
    tx=309/2-smolfont:getWidth('Replay in')/2
    for c=1,#('Replay in') do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('Replay in',c,c),tx,309/2+14+14+14-40+2)--+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('Replay in',c,c))
    end
    local n=tostring(flr(5-(t-sc_t-90+1)/60))

    if n=='0' then rp.i=1; love.update=replay end

    tx=309/2-smolfont:getWidth(n)/2
    for c=1,#(n) do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub(n,c,c),tx,309/2+14+14+14+14-40+2)--+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub(n,c,c))
    end
    end
    end

    if love.update==tutor then
        lg.setFont(smolfont)
        tx=309/2-smolfont:getWidth('Arrows or A/D to move')/2
        for c=1,#('Arrows or A/D to move') do
            local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
            fg(r/255.0,g/255.0,b/255.0,a/255.0)
            lg.print(sub('Arrows or A/D to move',c,c),tx,309/2+14+6-40+2)--+sin(c*0.8+t*0.2)*3)
            tx=tx+smolfont:getWidth(sub('Arrows or A/D to move',c,c))
        end
        
    end

    fg(1,1,1,1)
    for i=#particles,1,-1 do
        local p=particles[i]
        p.i = p.i or i
        lg.push()
        lg.translate(p.x+2,p.y+2)
        lg.rotate((p.i+t)*0.1)
        lg.draw(p.img,0,0,0,sin((p.i+t)*0.1))
        lg.pop()
        p.x=p.x+p.dx; p.y=p.y+p.dy
        p.dy=p.dy+grav
        if p.y>=309 then rem(particles,i) end
    end

    lg.setCanvas()
    fg(1,1,1,1)
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas2,0,0,0,scale,scale)
end

love.draw= draw

