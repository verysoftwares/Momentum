-- draw setup
    lg.setDefaultFilter('nearest')
    
canvas=lg.newCanvas(309,309)
canvas2=lg.newCanvas(309,309)
-- rotated text layer
canvas3=lg.newCanvas(309+200,309+200)
-- for UI elements
canvas4=lg.newCanvas(309,309)
        
function gamedraw(nocap,virtual_canvas,w)
    w=w or main_wld
    lg.setCanvas(canvas)
    if virtual_canvas then bg(0,0,0,0)
    else
    bg(0xcd/255.0,0xcd/255.0,0xc8/255.0)
    end
    fg(1,1,1,1)
    lg.draw(images.bg1_t)

    lg.setCanvas(canvas4)
    bg(0,0,0,0)
    lg.setCanvas(canvas3)
    bg(0,0,0,0)
    lg.setCanvas(canvas2)
    bg(0,0,0,0)

    -- trails
    for i,s in ipairs(w.shifters) do
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
    for i,s in ipairs(w.shifters) do
        lg.draw(images.shift,flr(s.x),flr(s.y))
        if s.update then
            local r=0
            if s.dx==1 and s.dy==1 then r=pi/2; end
            if s.dx==-1 and s.dy==1 then r=pi end
            if s.dx==-1 and s.dy==-1 then r=pi/2*3; end
            lg.draw(images.arrow,flr(s.x+grid),flr(s.y+grid),r,1,1,grid,grid)
        end
    end

    for i,sp in ipairs(w.spawners) do
        if w.score+500>=sp.t then
            if w.t%32<16 then
            lg.draw(images.alert,flr(sp.x),flr(sp.y))
            end
            lg.setFont(smolfont)
            lg.print(sp.t-w.score,flr(sp.x)+8+4+2,flr(sp.y)+grid-2-2-1)
        end
    end

    for i=#w.bonuses,1,-1 do
        local b=w.bonuses[i]
        lg.draw(b.img,flr(b.x),flr(b.y))
    end

    if love.update~=gameover and love.update~=show_unlocks then
    if w.ball.bonus then
        local r,g,b,a=HSL((t*6)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
    else
        fg(1,1,1,1)
    end
    lg.draw(w.ball.img,flr(w.ball.x),flr(w.ball.y))
    end
    
    lg.setFont(smolfont)
    for i=#w.shouts,1,-1 do
        local s=w.shouts[i]
        lg.print(s.msg,s.x,s.y)
    end

    -- to stop color bleeding messing with transparency
    if virtual_canvas then fg(1,1,1,1) end
    
    if w.plrbonus>0 and love.update~=replay and not virtual_canvas then
    lg.setFont(smolfont)
    lg.push()
    local cn=lg.getCanvas()
    lg.setCanvas(canvas3)
    --lg.rotate(-pi/4)
    fg(1,1,1,1)
    lg.print('Shift to use.',309-100-40+4+4,309-100-10+150+40-4)
    lg.setCanvas(cn)
    lg.pop()
    end

    lg.setFont(lcdfont)
    lg.push()
    lg.rotate(-pi/4)
    if (love.update~=gameover and love.update~=show_unlocks) or ((love.update==gameover or love.update==show_unlocks) and w.t%64<32) then
    -- low res
    --lg.print(fmt('%.5d',score),-60+4,15+60+15)
    end
    lg.setFont(lcdfont)
    --if plrbonus>0 then lg.print(plrbonus,-60+4+20+20,15+60+15+15+260) end
    lg.pop()

    local rpz_allowed=love.update==rp_zoom and vc_scale and vc_scale>0.9

    lg.setFont(lcdfont)
    local cn=lg.getCanvas()
    lg.setCanvas(canvas3)
    fg(1,1,1,1)
    if (not virtual_canvas or rpz_allowed) and (love.update~=gameover and love.update~=show_unlocks) or ((love.update==gameover or love.update==show_unlocks) and w.t%64<32) then
    lg.print(fmt('%.5d',w.score),-60+4+100+100+16+2,15+60+15+100-100+2-1)
    end
    if (not virtual_canvas or rpz_allowed) then
    lg.setFont(smolfont)
    lg.print(fmt('Hi score %.5d',_G['hiscore_'..string.lower(w.mode)]),-60+4+100+100+16+2,15+60+15+100-100+2-1-32+6)
    lg.setFont(lcdfont)
    if w.plrbonus>0 then lg.print(w.plrbonus,-60+4+20+20+100+100+16+2,15+60+15+15+260+100-100+2-1) end
    end
    lg.setCanvas(cn)
    
    if (love.update==replay and not virtual_canvas) or rpz_allowed then
    if w.t%64<32 then
    local r,g,b,a=lg.getColor()
    fg(0xb0/255,0x20/255,0x40/255,1)
    lg.push()
    lg.rotate(pi/4)
    -- low res
    --lg.print('REPLAY',60+80+10+1,-60-80+20-12+2+2)
    lg.pop()
    local cn=lg.getCanvas()
    lg.push()
    lg.setCanvas(canvas3)
    lg.rotate(pi/2)
    lg.setFont(lcdfont)
    lg.print('REPLAY',200-40-10+3-1,-300-40-10+3)
    lg.pop()
    lg.setCanvas(cn)
    fg(r,g,b,a)
    end
    end
    
    if rpz_allowed then
    local r,g,b,a=lg.getColor()
    fg(0xb0/255,0x20/255,0x40/255,1)
    local cn=lg.getCanvas()
    lg.push()
    lg.setCanvas(canvas3)
    lg.rotate(pi/2)
    lg.setFont(smolfont)
    local msg=fmt('Frame %d/%d',w.t,#w.rp)
    lg.print(msg,200-40-10+3-1+30+30+8-smolfont:getWidth(msg)/2,-300-40-10+3+250+8)
    msg='Left and right to'
    lg.print(msg,200-40-10+3-1+30+30+8-smolfont:getWidth(msg)/2,-300-40-10+3+250+12+8)
    msg='rewind/fast forward.'
    lg.print(msg,200-40-10+3-1+30+30+8-smolfont:getWidth(msg)/2,-300-40-10+3+250+12+8+8)
    lg.pop()
    lg.setCanvas(cn)
    fg(r,g,b,a)
    end

    if love.update==gameover or love.update==show_unlocks then
    lg.setFont(smolfont)
    local tx=309/2-smolfont:getWidth('GAME OVER')/2
    for c=1,#('GAME OVER') do
        local r,g,b,a=HSL(((w.t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('GAME OVER',c,c),tx,309/2-40+2+sin(c*0.8+w.t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('GAME OVER',c,c))
    end
    tx=309/2-smolfont:getWidth('R to reset, Esc for menu')/2
    for c=1,#('R to reset, Esc for menu') do
        local r,g,b,a=HSL(((w.t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('R to reset, Esc for menu',c,c),tx,309/2+14-40+2)--+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('R to reset, Esc for menu',c,c))
    end
    if w.t-sc_t>=90 and love.update==gameover then
    tx=309/2-smolfont:getWidth('Replay in')/2
    for c=1,#('Replay in') do
        local r,g,b,a=HSL(((w.t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('Replay in',c,c),tx,309/2+14+14+14-40+2)--+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('Replay in',c,c))
    end
    local n=tostring(flr(5-(w.t-sc_t-90+1)/60))

    if n=='0' then w.rp.i=1; love.update=replay end

    tx=309/2-smolfont:getWidth(n)/2
    for c=1,#(n) do
        local r,g,b,a=HSL(((w.t+c*4)*2)%256,224,224,255)
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
            local r,g,b,a=HSL(((w.t+c*4)*2)%256,224,224,255)
            fg(r/255.0,g/255.0,b/255.0,a/255.0)
            lg.print(sub('Arrows or A/D to move',c,c),tx,309/2+14+6-40+2)--+sin(c*0.8+t*0.2)*3)
            tx=tx+smolfont:getWidth(sub('Arrows or A/D to move',c,c))
        end
        
    end

    if love.update==show_unlocks then
        local cn=lg.getCanvas()
        lg.setCanvas(canvas3)
        fg(0.4,0.4,0.4,0.7)
        rect('fill',0,0,309+200,309+200)
        --lg.setCanvas(canvas3)
        --fg(0.4,0.4,0.4,0.7)
        --rect('fill',0,0,309+200,309+200)
        --lg.setCanvas(canvas2)
        lg.setCanvas(canvas4)

        local msg=fmt('Unlocked %s!',unlocks[1])
        if unlocks[1]=='Chaotic' then msg=fmt('Unlocked %s mode!',unlocks[1]) end

        lg.setFont(smolfont)

        tx=309/2-smolfont:getWidth(msg)/2

        fg(0x3c/255,0x4c/255,0x25/255,1)
        local h=smolfont:getHeight('MOMENTUM')+8
        rect('fill',0,unlock_ty,309,h)

        for c=1,#(msg) do
            local r,g,b,a=HSL(((w.t+c*4)*2)%256,224,224,255)
            fg(r/255.0,g/255.0,b/255.0,a/255.0)
            lg.print(sub(msg,c,c),tx,unlock_ty+4)--+sin(c*0.8+t*0.2)*3)
            tx=tx+smolfont:getWidth(sub(msg,c,c))
        end
       
        unlock_ty=unlock_ty+(309/2-h/2-unlock_ty)*0.1
        if math.abs(unlock_ty-(309/2-h/2))<1 then unlock_ty=309/2-h/2 end

        lg.setCanvas(cn)
    end

    fg(1,1,1,1)
    for i=#w.particles,1,-1 do
        local p=w.particles[i]
        lg.push()
        lg.translate(p.x+2,p.y+2)
        lg.rotate((p.i+t)*0.1)
        lg.draw(p.img,0,0,0,sin((p.i+t)*0.1))
        lg.pop()
    end

    if w.ball.bonus and not virtual_canvas then 
        local r,g,b,a=HSL((w.t*6)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
    end
    --if not virtual_canvas then
    lg.draw(images.bg2a)
    lg.draw(images.bg2b,0,flr(309/2)+1)
    --end

    if w.plrbonus>0 and (not virtual_canvas or rpz_allowed) then
    local r,g,b,a=lg.getColor()
    --fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
    --circ('fill',309-60-12,309-40+12,13)
    fg(0xf0/255.0,0xa0/255.0,0xb0/255.0)
    circ('fill',309-60-12,309-40+12,12.8)
    fg(r,g,b,a)
    end

    lg.setCanvas()
    if virtual_canvas then
        lg.setCanvas(virtual_canvas)
        bg(0,0,0,0)
    end
    fg(1,1,1,1)
    local wx,wy=0,0
    if love.window.getFullscreen() and not virtual_canvas then        
        bg(0x29/255,0x23/255,0x2e/255)
        wx,wy=love.window.getMode()
        wx=wx/2;wy=wy/2
        wx=wx-(309*scale)/2; wy=wy-(309*scale)/2
        wx=flr(wx); wy=flr(wy)
        lg.setScissor(wx,wy,309*scale,309*scale)
    end
    lg.draw(canvas,wx,wy,0,scale,scale)
    lg.draw(canvas2,wx,wy,0,scale,scale)
    lg.draw(canvas3,wx+(-309/2-250-60)/3*scale,wy+(430+50-20)/3*scale,-pi/4,scale,scale)
    lg.draw(canvas4,wx,wy,0,scale,scale)
    lg.setScissor()
    
    if not nocap then
    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
    end
end
