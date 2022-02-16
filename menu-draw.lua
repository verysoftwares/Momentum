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
    
    if t>32+24+32+24+16-60 and (t-14)%16==0 then
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
    fg(153/255.0,152/255.0,100/255.0)
    lg.push()
    lg.rotate(-pi/4)
    rect('fill',0+60-80-100-30-60-20-100+10,24+60+80-30-309-10,309+200,309)
    rect('fill',-50-70-50-20,309-60+30-1,309+100,309)
    lg.pop()
    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    for ry=-grid,309,grid do
    for rx=-grid,309,grid do
    rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    end
    end
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20+bar_dist,24+60+80-30-10,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20+bar_dist,24+60+80-30,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2)
    fg(0x29/255,0x23/255,0x2e/255)
    rect('fill',309/2-1-100-90-40-20+4+2-1-bar_dist,24+8-4+2+100+12-1,lcdfont:getWidth('MOMENTUM'),lcdfont:getHeight('MOMENTUM')+24-10)
    fg(153/255.0,152/255.0,100/255.0)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30+60-2,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+24+8+4+2)
    lg.pop()
    bar_dist=bar_dist-8; if bar_dist<0 then bar_dist=0 end

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
    if not cycle.dx and cycle[cycle.i]=='Options' then
    rainbowprint('Not yet implemented.')
    end
    if not cycle.dx and cycle[cycle.i]=='Chaotic' then
    local msg='10000 points in Standard mode to unlock!'
    if cycle_unlocks['Chaotic'] then msg='Play with accelerated spawners!' end
    rainbowprint(msg)
    end
    if not cycle.dx and cycle[cycle.i]=='Gallery' then
    local msg='5000 points in Standard mode to unlock!'
    if cycle_unlocks['Gallery'] then msg='View past replays!' end
    rainbowprint(msg)
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
    for ry=-grid,309,grid do
    for rx=-grid,309,grid do
    if rx+ry<bar_dist_y+160 or rx+ry>smolrect[2]-bar_dist_y+30 then
    rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    end
    end
    end
    lg.pop()
    lg.push()
    lg.rotate(-pi/4)
    if #title>0 then
    fg(153/255.0,152/255.0,100/255.0)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30+60-2,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+24+8+4+2-bar_dist_y)
    end
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
    if bar_dist_y==48-5 then playsnd(audio.shutter) end
    bar_dist_y=bar_dist_y-4; if bar_dist_y<-185 then 
    --bar_dist_y=nil
    audio.shutter:stop()
    audio.mewsic2:stop()
    audio.mewsic2:setVolume(1)
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
    if bar_dist_y==-185 then audio.shutter:seek(2.0); playsnd(audio.shutter) end
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
    for ry=-grid,309,grid do
    for rx=-grid,309,grid do
    if rx+ry<bar_dist_y+160 or rx+ry>smolrect[2]-bar_dist_y+30 then
    rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    end
    end
    end
    lg.pop()
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
    if bar_dist_y==48-5 then audio.shutter:seek(2.603); playsnd(audio.shutter) end
    bar_dist_y=bar_dist_y-4; 
    if bar_dist_y<=0 then 
        bar_dist_y=0
        love.update=menu; love.draw=menudraw
        audio.mewsic1:stop()
        audio.mewsic1:setVolume(1)
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
