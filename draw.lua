-- draw setup
    lg.setDefaultFilter('nearest')
    
canvas=lg.newCanvas(309,309)
canvas2=lg.newCanvas(309,309)
-- rotated text layer
canvas3=lg.newCanvas(309+200,309+200)
-- for UI elements
canvas4=lg.newCanvas(309,309)
-- for gallery rendering
vcanvas=lg.newCanvas(309*scale,309*scale)
        
function gamedraw(nocap,virtual_canvas)
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

    if love.update~=gameover and love.update~=show_unlocks then
    if ball.bonus then
        local r,g,b,a=HSL((t*6)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
    else
        fg(1,1,1,1)
    end
    lg.draw(ball.img,flr(ball.x),flr(ball.y))
    end
    -- to stop color bleeding messing with transparency
    if virtual_canvas then fg(1,1,1,1) end

    lg.setFont(smolfont)
    for i=#shouts,1,-1 do
        local s=shouts[i]
        lg.print(s.msg,s.x,s.y)
    end

    if plrbonus>0 and not virtual_canvas then
    local r,g,b,a=lg.getColor()
    --fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
    --circ('fill',309-60-12,309-40+12,13)
    fg(0xf0/255.0,0xa0/255.0,0xb0/255.0)
    circ('fill',309-60-12,309-40+12,12.8)
    fg(r,g,b,a)
    lg.setFont(smolfont)
    lg.push()
    local cn=lg.getCanvas()
    lg.setCanvas(canvas3)
    --lg.rotate(-pi/4)
    lg.print('Shift to use.',309-100-40+4+4,309-100-10+150+40-4)
    lg.setCanvas(cn)
    lg.pop()
    end

    lg.setFont(lcdfont)
    lg.push()
    lg.rotate(-pi/4)
    if (love.update~=gameover and love.update~=show_unlocks) or ((love.update==gameover or love.update==show_unlocks) and t%64<32) then
    -- low res
    --lg.print(fmt('%.5d',score),-60+4,15+60+15)
    end
    lg.setFont(lcdfont)
    --if plrbonus>0 then lg.print(plrbonus,-60+4+20+20,15+60+15+15+260) end
    lg.pop()

    lg.setFont(lcdfont)
    local cn=lg.getCanvas()
    lg.setCanvas(canvas3)
    if not virtual_canvas and (love.update~=gameover and love.update~=show_unlocks) or ((love.update==gameover or love.update==show_unlocks) and t%64<32) then
    lg.print(fmt('%.5d',score),-60+4+100+100+16+2,15+60+15+100-100+2-1)
    end
    if not virtual_canvas then
    lg.setFont(smolfont)
    lg.print(fmt('Hi score %.5d',_G['hiscore_'..string.lower(mode)]),-60+4+100+100+16+2,15+60+15+100-100+2-1-32+6)
    lg.setFont(lcdfont)
    if plrbonus>0 then lg.print(plrbonus,-60+4+20+20+100+100+16+2,15+60+15+15+260+100-100+2-1) end
    end
    lg.setCanvas(cn)
    
    if love.update==replay and not virtual_canvas then
    if t%64<32 then
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
    lg.print('REPLAY',200-40-10+3-1,-300-40-10+3)
    lg.pop()
    lg.setCanvas(cn)
    fg(r,g,b,a)
    end
    end

    if love.update==gameover or love.update==show_unlocks then
    lg.setFont(smolfont)
    local tx=309/2-smolfont:getWidth('GAME OVER')/2
    for c=1,#('GAME OVER') do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('GAME OVER',c,c),tx,309/2-40+2+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('GAME OVER',c,c))
    end
    tx=309/2-smolfont:getWidth('R to reset, Esc for menu')/2
    for c=1,#('R to reset, Esc for menu') do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
        lg.print(sub('R to reset, Esc for menu',c,c),tx,309/2+14-40+2)--+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub('R to reset, Esc for menu',c,c))
    end
    if t-sc_t>=90 and love.update==gameover then
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
            local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
            fg(r/255.0,g/255.0,b/255.0,a/255.0)
            lg.print(sub(msg,c,c),tx,unlock_ty+4)--+sin(c*0.8+t*0.2)*3)
            tx=tx+smolfont:getWidth(sub(msg,c,c))
        end
       
        unlock_ty=unlock_ty+(309/2-h/2-unlock_ty)*0.1
        if math.abs(unlock_ty-(309/2-h/2))<1 then unlock_ty=309/2-h/2 end

        lg.setCanvas(cn)
    end

    fg(1,1,1,1)
    for i=#particles,1,-1 do
        local p=particles[i]
        lg.push()
        lg.translate(p.x+2,p.y+2)
        lg.rotate((p.i+t)*0.1)
        lg.draw(p.img,0,0,0,sin((p.i+t)*0.1))
        lg.pop()
    end

    if ball.bonus and not virtual_canvas then 
        local r,g,b,a=HSL((t*6)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,a/255.0)
    end
    --if not virtual_canvas then
    lg.draw(images.bg2a)
    lg.draw(images.bg2b,0,flr(309/2)+1)
    --end

    lg.setCanvas()
    if virtual_canvas then
        lg.setCanvas(vcanvas)
        bg(0,0,0,0)
    end
    fg(1,1,1,1)
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas2,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)
    lg.draw(canvas4,0,0,0,scale,scale)
    
    if not nocap then
    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
    end
end

function menudraw()
    lg.setCanvas(canvas3)
    bg(0,0,0,0)

    lg.setCanvas(canvas)
    bg(153/255.0,152/255.0,100/255.0)

    title=title or ''
    titlelock=titlelock or 1
    if t%2==0 and bar_dist==0 then
    if #title<#'MOMENTUM' then
        title=title..string.char(random(33,96))
    end
    for i=titlelock,math.min(#'MOMENTUM',#title) do
        local ts=sub(title,1,i-1)
        local te=sub(title,i+1,#title)
        title = ts..string.char(random(33,96))..te
    end
    if t>32+24+32+24+16-60 and (t-12)%16==0 then
        if not onlyoncem2 then init(2); onlyoncem2=true end
        title=sub(title,1,titlelock-1)..sub('MOMENTUM',titlelock,titlelock)..sub(title,titlelock+1,#title)
        titlelock=titlelock+1
    end
    end
    if titlelock>#'MOMENTUM' then
        tl_interval=tl_interval or random(12,64)
        tl_interval=tl_interval-1
        if tl_interval<=0 and not tl_chaos then
            tl_chaos=random(12,38)
            tl_chaos_i=random(1,#'MOMENTUM')
            tl_interval=nil
        end
    end
    if tl_chaos then
        if t%2==0 then
            title = sub(title,1,tl_chaos_i-1)..string.char(random(33,96))..sub(title,tl_chaos_i+1,#title)
        end
        tl_chaos=tl_chaos-1; if tl_chaos==0 then 
            title = sub(title,1,tl_chaos_i-1)..sub('MOMENTUM',tl_chaos_i,tl_chaos_i)..sub(title,tl_chaos_i+1,#title)
            tl_chaos=nil 
        end
    end

    bar_dist=bar_dist or 412
    lg.push()
    lg.rotate(-pi/4)
    --fg(0x68/255,0x70/255,0x4b/255)
    --for ry=0,309,grid do
    --for rx=0,309,grid do
    --rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    --end
    --end
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20+bar_dist,24+60+80-30-10,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20+bar_dist,24+60+80-30,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2)
    fg(0x29/255,0x23/255,0x2e/255)
    rect('fill',309/2-1-100-90-40-20+4+2-1-bar_dist,24+8-4+2+100+12-1,lcdfont:getWidth('MOMENTUM'),lcdfont:getHeight('MOMENTUM')+24-10)
    lg.pop()
    bar_dist=bar_dist-8; if bar_dist<0 then bar_dist=0 end
    fg(153/255.0,152/255.0,100/255.0)
    lg.push()
    lg.rotate(-pi/4)
    rect('fill',0+60-80-100-30-60-20-100+10,24+60+80-30-309-10,309+200,309)
    rect('fill',-50-70-50-20,309-60+30-1,309+100,309)
    lg.pop()
    

    fg(1,1,1,1)
    lg.setCanvas(canvas3)
    lg.setFont(lcdfont)
    lg.print(title,309/2+60-80-10+4-1,24+24-1+60+60-40+20+10+2)
    lg.setCanvas(canvas)
    
    if titlelock>#'MOMENTUM' then
    lg.push()
    lg.rotate(-pi/4)
    lg.translate(-120-40+8-1-1,30-1)
    smolrect=smolrect or {309/2,309-60+(smolfont:getHeight('MOMENTUM')+8)/2,0,0}
    fg(0x3c/255,0x4c/255,0x25/255)
    rect('fill',unpack(smolrect))
    smolrect[1]=smolrect[1]+(0-60-smolrect[1])*0.14
    smolrect[2]=smolrect[2]+(309-60-smolrect[2])*0.14
    smolrect[3]=smolrect[3]+(309+120-smolrect[3])*0.14
    smolrect[4]=smolrect[4]+(smolfont:getHeight('MOMENTUM')+8-smolrect[4])*0.14
    lg.pop()
    if math.abs(smolrect[4]-(smolfont:getHeight('MOMENTUM')+8))<1 then smolrect[4]=smolfont:getHeight('MOMENTUM')+8 end

    if smolrect[4]>=smolfont:getHeight('MOMENTUM') then
    ctrl=true
    lg.setCanvas(canvas3)
    lg.setFont(smolfont)
    local tx=309/2-smolfont:getWidth(visualize(cycle[cycle.i]))/2
    if cycle.x then tx=cycle.x end
    for c=1,#(visualize(cycle[cycle.i])) do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,1)
        lg.print(sub(visualize(cycle[cycle.i]),c,c),100+tx-40,30+309-60+8-3+sin(c*0.8+t*0.2)*3)
        tx=tx+smolfont:getWidth(sub(visualize(cycle[cycle.i]),c,c))
    end

    local function rainbowprint(msg)
    local tx=309/2-smolfont:getWidth(msg)/2
    for c=1,#(msg) do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        fg(r/255.0,g/255.0,b/255.0,1)
        lg.print(sub(msg,c,c),100+tx-40,30+309-60+8-3-24+4)
        tx=tx+smolfont:getWidth(sub(msg,c,c))
    end
    end

    if not cycle.dx and cycle[cycle.i]=='Quit' then
    rainbowprint('Back to reality...')
    end
    if not cycle.dx and cycle[cycle.i]=='Standard' then
    rainbowprint('The classic Momentum experience!')
    end
    if not cycle.dx and (cycle[cycle.i]=='Options' or (cycle[cycle.i]=='Gallery' and cycle_unlocks['Gallery'])) then
    rainbowprint('Not yet implemented.')
    end
    if not cycle.dx and cycle[cycle.i]=='Chaotic' then
    local msg='10000 points in Standard mode to unlock!'
    if cycle_unlocks['Chaotic'] then msg='Play with accelerated spawners!' end
    rainbowprint(msg)
    end
    if not cycle.dx and (cycle[cycle.i]=='Gallery' and not cycle_unlocks['Gallery']) then
    rainbowprint('5000 points in Standard mode to unlock!')
    end
    end
    end

    fg(1,1,1,1)
    lg.setCanvas()
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)
    
    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
end

function menufadeout()
    audio.mewsic2:setVolume(audio.mewsic2:getVolume()-0.01)
    gamedraw(true)

    lg.setCanvas(canvas3)
    bg(0,0,0,0)

    lg.setCanvas(canvas)
    if #title>0 then
    bg(153/255.0,152/255.0,100/255.0)
    else
    bg(0,0,0,0)
    fg(153/255.0,152/255.0,100/255.0)
    lg.push()
    lg.rotate(-pi/4)
    rect('fill',0+60-80-100-30-60-20-100+10,24+60+80-30+bar_dist_y-309-10,309+200,309)
    rect('fill',-50-70-50-20,309-60+30-1-bar_dist_y,309+100,309)
    lg.pop()
    end

    if titlelock>#'MOMENTUM' then titlelock=#'MOMENTUM' end
    for i=#title,titlelock,-1 do
        local ts=sub(title,1,i-1)
        local te=sub(title,i+1,#title)
        title = ts..string.char(random(33,96))..te
    end
    if t%8==0 and titlelock>1 then
        titlelock=titlelock-1
    end
    if titlelock==1 and t%8==0 and #title>0 then
        title=sub(title,1,#title-1)
    end
   
    bar_dist_y=bar_dist_y or 0
    
    fg(1,1,1,1)
    lg.setCanvas(canvas3)
    lg.setFont(lcdfont)
    lg.print(title,309/2+60-80-10+4-1,24+24-1+60+60-40+20+10+2+bar_dist_y)
    lg.setCanvas(canvas)

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10+bar_dist_y,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30+bar_dist_y,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2)
    fg(0x29/255,0x23/255,0x2e/255)
    rect('fill',309/2-1-100-90-40-20+4+2-1,24+8-4+2+100+12-1+bar_dist_y,lcdfont:getWidth('MOMENTUM'),lcdfont:getHeight('MOMENTUM')+24-10)
    lg.pop()
    
    lg.push()
    lg.rotate(-pi/4)
    lg.translate(-120-40+8-1-1,30-1)
    fg(0x3c/255,0x4c/255,0x25/255)
    smolrect[1]=0-60
    smolrect[2]=309-60
    smolrect[3]=309+120
    smolrect[4]=smolfont:getHeight('MOMENTUM')+8
    rect('fill',smolrect[1],smolrect[2]-bar_dist_y,smolrect[3],smolrect[4])
    lg.pop()
    
    if #title>0 then
    bar_dist_y=bar_dist_y+4; if bar_dist_y>48-5 then bar_dist_y=48-5 end
    else
    bar_dist_y=bar_dist_y-4; if bar_dist_y<-185 then 
    --bar_dist_y=nil
    audio.mewsic2:stop()
    audio.mewsic2:setVolume(0.7)
    love.update=tutor; love.draw=gamedraw
    end
    end

    fg(1,1,1,1)
    lg.setCanvas()
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)

    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
end

function menufadein()
    audio.mewsic1:setVolume(audio.mewsic1:getVolume()-0.01)

    lg.setCanvas(canvas3)
    bg(0,0,0,0)
    lg.setCanvas(canvas)
    if title=='MOMENTUM' then
    bg(153/255.0,152/255.0,100/255.0,1)
    else
    bg(0,0,0,0)
    end

    -- for debug
    bar_dist = bar_dist or 0
    bar_dist_y=bar_dist_y or -185
    title = title or ''
    smolrect=smolrect or {}
    titlelock = titlelock or 1

    if t%2==0 and bar_dist_y==48-5 then
    if #title<#'MOMENTUM' then
        title=title..string.char(random(33,96))
    end
    for i=titlelock,math.min(#'MOMENTUM',#title) do
        local ts=sub(title,1,i-1)
        local te=sub(title,i+1,#title)
        title = ts..string.char(random(33,96))..te
    end
    end
    if bar_dist_y==48-5 and t%8==0 then
        title=sub(title,1,titlelock-1)..sub('MOMENTUM',titlelock,titlelock)..sub(title,titlelock+1,#title)
        titlelock=titlelock+1
    end

    fg(153/255.0,152/255.0,100/255.0)
    lg.push()
    lg.rotate(-pi/4)
    rect('fill',0+60-80-100-30-60-20-100+10,24+60+80-30+bar_dist_y-309,309+200,309)
    rect('fill',-50-70-50-20,309-60+30-1-bar_dist_y,309+100,309)
    lg.pop()

    fg(1,1,1,1)
    lg.setCanvas(canvas3)
    lg.setFont(lcdfont)
    lg.print(title,309/2+60-80-10+4-1,24+24-1+60+60-40+20+10+2+bar_dist_y)
    lg.setCanvas(canvas)

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10+bar_dist_y,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30+bar_dist_y,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2)
    fg(0x29/255,0x23/255,0x2e/255)
    rect('fill',309/2-1-100-90-40-20+4+2-1,24+8-4+2+100+12-1+bar_dist_y,lcdfont:getWidth('MOMENTUM'),lcdfont:getHeight('MOMENTUM')+24-10)
    lg.pop()
    
    lg.push()
    lg.rotate(-pi/4)
    lg.translate(-120-40+8-1-1,30-1)
    fg(0x3c/255,0x4c/255,0x25/255)
    smolrect[1]=0-60
    smolrect[2]=309-60
    smolrect[3]=309+120
    smolrect[4]=smolfont:getHeight('MOMENTUM')+8
    rect('fill',smolrect[1],smolrect[2]-bar_dist_y,smolrect[3],smolrect[4])
    lg.pop()

    if title=='MOMENTUM' then
    bar_dist_y=bar_dist_y-4; 
    if bar_dist_y<=0 then 
        bar_dist_y=0
        love.update=menu; love.draw=menudraw
        audio.mewsic1:stop()
        audio.mewsic1:setVolume(0.7)
    end
    else
    bar_dist_y=bar_dist_y+4; if bar_dist_y>48-5 then bar_dist_y=48-5 end
    end

    fg(1,1,1,1)
    lg.setCanvas()
    lg.draw(old_canvas)
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)

    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
end

function galleryfadein()
    audio.mewsic2:setVolume(audio.mewsic2:getVolume()-0.01)

    lg.setCanvas(canvas3)
    bg(0,0,0,0)

    lg.setCanvas(canvas)
    bg(153/255.0,152/255.0,100/255.0)

    if titlelock>#'MOMENTUM' then titlelock=#'MOMENTUM' end
    for i=#title,titlelock,-1 do
        local ts=sub(title,1,i-1)
        local te=sub(title,i+1,#title)
        title = ts..string.char(random(33,96))..te
    end
    if t%8==0 and titlelock>1 then
        titlelock=titlelock-1
    end
    if titlelock==1 and t%8==0 and #title>0 then
        title=sub(title,1,#title-1)
    end
   
    bar_dist=bar_dist or 0
    bar_xw=bar_xw or 0
    
    fg(1,1,1,1)
    lg.setCanvas(canvas3)
    lg.setFont(lcdfont)
    lg.print(title,309/2+60-80-10+4-1-bar_dist,24+24-1+60+60-40+20+10+2)
    lg.setCanvas(canvas)

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20+bar_xw)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+bar_xw)
    fg(0x29/255,0x23/255,0x2e/255)
    rect('fill',309/2-1-100-90-40-20+4+2-1-bar_dist,24+8-4+2+100+12-1,lcdfont:getWidth('MOMENTUM'),lcdfont:getHeight('MOMENTUM')+24-10)
    lg.pop()
    
    lg.push()
    lg.rotate(-pi/4)
    lg.translate(-120-40+8-1-1,30-1)
    fg(0x3c/255,0x4c/255,0x25/255)
    smolrect[1]=0-60
    smolrect[2]=309-60
    smolrect[3]=309+120
    smolrect[4]=smolfont:getHeight('MOMENTUM')+8
    rect('fill',smolrect[1],smolrect[2]+bar_dist,smolrect[3],smolrect[4])
    lg.pop()
    
    bar_dist=bar_dist+4; if bar_dist>280 then bar_dist=280 end
    --bar_dist_y=nil
    bar_xw=bar_xw+2; if bar_xw>120 then
    bar_xw=120
    if bar_dist==280 then 
    audio.mewsic2:stop()
    audio.mewsic2:setVolume(0.7)
    love.update=rp_gallery; love.draw=gallerydraw
    sc_t=t+1
    end
    end

    fg(1,1,1,1)
    lg.setCanvas()
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)

    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
end

function gallerydraw()
    if t-sc_t==0 then 
        if not gallery[1] then return end
        rp=gallery[1]
        rp.i=1
        mode=rp.mode
        reset(true)
    end
    
    if not rp[rp.i] then reset(true); rp.i=1 end
    love.update=replay
    update()
    love.update=rp_gallery
    love.draw=gallerydraw
    gamedraw(true,true)

    lg.setCanvas(canvas3)
    bg(0,0,0,0)

    lg.setCanvas(canvas)
    bg(153/255.0,152/255.0,100/255.0)

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20+bar_xw)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+bar_xw)
    lg.pop()

    fg(1,1,1,1)
    --lg.setCanvas(canvas)
    
    lg.setCanvas()
    lg.draw(canvas,0,0,0,scale,scale)
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)
    lg.setShader(graytrans)
    lg.draw(vcanvas,100-40+100-20-15+2+60,200+100-40-20-15+2-60,0,0.6,0.6)
    lg.setShader()

    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
end

graytrans=lg.newShader([[
vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ) {
    vec4 tc = Texel(tex, texture_coords);
    if (tc.r==0.803921568627451 && tc.g==0.803921568627451 && tc.b==0.7843137254901961) {
        return vec4(0,0,0,0);
    }
    return tc;
}
]])

love.draw= menudraw

