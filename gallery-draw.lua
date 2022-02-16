-- for gallery rendering
vcanvas=lg.newCanvas(309*scale,309*scale)

function galleryfadein()
    if bar_dist==0 then playsnd(audio.shutter) end
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
    bar_xh=bar_xh or 0

    fg(1,1,1,1)
    lg.setCanvas(canvas3)
    lg.setFont(lcdfont)
    lg.print(title,309/2+60-80-10+4-1-bar_dist,24+24-1+60+60-40+20+10+2)
    lg.setCanvas(canvas)

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    for ry=-grid,309,grid do
    for rx=-grid,309,grid do
    if rx+ry<24+60+80-30-10-bar_xh or rx+ry>smolrect[2]+16+16+math.min(bar_dist,(30+309-60+60+8-3)-(309-60)-35) then
    rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    end
    end
    end
    lg.pop()
    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10-bar_xh,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20+bar_xw)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-bar_xh,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+bar_xw)
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
    rect('fill',smolrect[1],smolrect[2]+math.min(bar_dist,(30+309-60+60+8-3)-(309-60)-35),smolrect[3],smolrect[4])
    lg.pop()
    
    bar_dist=bar_dist+4; if bar_dist>280 then bar_dist=280 end
    --bar_dist_y=nil
    bar_xh=bar_xh+0.2; if bar_xh>8 then bar_xh=8 end
    bar_xw=bar_xw+2; if bar_xw>120+16 then
    bar_xw=120+16
    if bar_dist==280 then 
    audio.shutter:stop()
    audio.mewsic2:stop()
    audio.mewsic2:setVolume(1)
    love.update=rp_gallery; love.draw=gallerydraw
    worldcache={{},{},{}}
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
    if t-sc_t==0 and gallery[1] then
        reset(main_wld)
        main_wld.rp=gallery[1]
        main_wld.rp.i=1
        main_wld.mode=main_wld.rp.mode
    end

    lg.setCanvas(preview1)
    bg(0,0,0,0)
    lg.setCanvas(preview2)
    bg(0,0,0,0)

    if gallery[gallery.i-1] and love.draw==gallerydraw then
        simulate(worldprev1,preview1,true)
    end

    if gallery[gallery.i+1] and love.draw==gallerydraw then
        simulate(worldprev2,preview2,true)
    end

    lg.setCanvas(vcanvas)
    bg(0,0,0,0)

    if gallery[1] then
    simulate(main_wld,vcanvas)
    end

    lg.setCanvas(canvas)
    bg(153/255.0,152/255.0,100/255.0)

    lg.setCanvas(canvas3)
    bg(0,0,0,0)
    if love.draw==gallerydraw and vc_scale and vc_scale<0.67 then
    if gall_state==nil and #gallery>1 then
    lg.setFont(lcdfont)
    --local r,g,b,a=HSL((t*2)%256,224,224,255)
    --fg(r/255.0,g/255.0,b/255.0,1)
    fg(1,1,1,1)
    lg.print('<',309/2-30,309/2+60)
    lg.print('>',309/2+100+60-20,309/2+60)
    --lg.push()
    --lg.rotate(-pi/4)
    --lg.print('>',309/2-t,309/2+60-t)
    --lg.pop()
    end

    fg(0xb0/255,0x20/255,0x40/255,1)
    lg.setFont(smolfont)
    if gallery[gallery.i-1] then
    lg.print(gallery[gallery.i-1].score,309/2+20-100+6-6-smolfont:getWidth(gallery[gallery.i-1].score)/2,309/2+100-60-20+4-1-2-3+1)
    lg.print(gallery[gallery.i-1].mode,309/2+20-100+6-6-smolfont:getWidth(gallery[gallery.i-1].mode)/2,309/2+100-60-20+4-1+100-40+15+4-2+8-2)
    end
    if gallery[gallery.i] then
    lg.print(gallery[gallery.i].score,309/2+20+100-50-10+6+12-8-12-smolfont:getWidth(gallery[gallery.i].score)/2+3,309/2-10-10+5-8)
    lg.print(gallery[gallery.i].mode,309/2+20+100-50-10+6+12-8-12-smolfont:getWidth(gallery[gallery.i].mode)/2+3,309/2-10-10+5+200-60+8-8+12+6-4+2)
    end
    if gallery[gallery.i+1] then
    lg.print(gallery[gallery.i+1].score,309/2+20+100+100-30+10+6+3-6-smolfont:getWidth(gallery[gallery.i+1].score)/2+3,309/2+100-60-20+4-1-2-3)
    lg.print(gallery[gallery.i+1].mode,309/2+20+100+100-30+10+6+3-6-smolfont:getWidth(gallery[gallery.i+1].mode)/2,309/2+100-60-20+4-1+100-40+15+4-2+8-2)
    end

    if not gallery[1] then
        fg(0xb0/255,0x20/255,0x40/255,1)
        lg.setFont(smolfont)
        lg.print('No replays available!',309/2+20,309/2+80-30+8)
    end
    end

    lg.setCanvas(canvas)
    
    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    for ry=-grid,309,grid do
    for rx=-grid,309,grid do
    if rx+ry<24+60+80-30-10-bar_xh or rx+ry>smolrect[2]+16+16+math.min(bar_dist,(30+309-60+60+8-3)-(309-60)-35) then
    rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    end
    end
    end
    lg.pop()

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10-bar_xh,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20+bar_xw)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-bar_xh,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+bar_xw)
    lg.pop()

    lg.push()
    lg.rotate(-pi/4)
    lg.translate(-120-40+8-1-1,30-1)
    fg(0x3c/255,0x4c/255,0x25/255)
    smolrect[1]=0-60
    smolrect[2]=309-60
    smolrect[3]=309+120
    smolrect[4]=smolfont:getHeight('MOMENTUM')+8
    local sry
    sry=math.min(bar_dist,(30+309-60+60+8-3)-(309-60)-35+bar_xh-8)
    rect('fill',smolrect[1],smolrect[2]+sry,smolrect[3],smolrect[4])
    lg.pop()

    lg.setCanvas(canvas3)
    lg.setFont(smolfont)
    local tx=309/2-smolfont:getWidth(visualize(cycle2[cycle2.i]))/2
    if cycle2.x then tx=cycle2.x end
    for c=1,#(visualize(cycle2[cycle2.i])) do
        local r,g,b,a=HSL(((t+c*4)*2)%256,224,224,255)
        local bounce=sin(c*0.8+t*0.2)*3
        if gall_state~='sort' then bounce=0 end
        fg(r/255.0,g/255.0,b/255.0,1)
        lg.print(sub(visualize(cycle2[cycle2.i]),c,c),100+tx-40,30+309-60+60+8-3+bar_xh-8+bounce)
        tx=tx+smolfont:getWidth(sub(visualize(cycle2[cycle2.i]),c,c))
    end

    fg(1,1,1,1)
    --lg.setCanvas(canvas)
    
    lg.setCanvas()
    lg.draw(canvas,0,0,0,scale,scale)
    lg.setShader(graytrans)
    if preview1 and love.draw==gallerydraw then 
    lg.draw(preview1,(100-40+100-20-15+2+60-100-50-14-4-4)/3*scale,(200+100-40-20-15+2-60+100+100+100+100+50-8+14-12-4)/3*scale,0,0.3333,0.3333)
    end
    vc_x=vc_x or (100-40+100-20-15+2+60-8-16-14)/3*scale
    vc_y=vc_y or (200+100-40-20-15+2-60-20-6-8-8-8-15+8+16+14)/3*scale
    vc_scale=vc_scale or 0.6666

    if love.draw==gallerydraw then
    bar_xh=bar_xh-4; if bar_xh<8 then bar_xh=8 end
    bar_xw=bar_xw-8; if bar_xw<120+16 then
    bar_xw=120+16 end
    vc_x=vc_x+(149/3*scale-vc_x)*0.1
    vc_y=vc_y+(140/3*scale-vc_y)*0.1
    vc_scale=vc_scale+(0.6666-vc_scale)*0.1
    end

    lg.draw(vcanvas,vc_x,vc_y,0,vc_scale,vc_scale)
    if preview2 and love.draw==gallerydraw then 
    lg.draw(preview2,(100-40+100-20-15+2+60+100+100+100+100+50-14-4-4-2)/3*scale,(200+100-40-20-15+2-60-100-50-8+14-12-4-2)/3*scale,0,0.3333,0.3333)
    end
    lg.setShader()
    --if love.draw==gallerydraw then
    lg.draw(canvas3,(-309/2-250-60)/3*scale,(430+50-20)/3*scale,-pi/4,scale,scale)
    --end

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

function galleryfadeout()
    if bar_dist==280 then audio.shutter:seek(1.803); playsnd(audio.shutter) end

    audio.mewsic4:setVolume(audio.mewsic4:getVolume()-0.01)

    lg.setCanvas(canvas3)
    bg(0,0,0,0)

    lg.setCanvas(canvas)
    bg(153/255.0,152/255.0,100/255.0)
   
    if t%2==0 then
    if #title<#'MOMENTUM' then
        title=title..string.char(random(33,96))
    end
    for i=titlelock,math.min(#'MOMENTUM',#title) do
        local ts=sub(title,1,i-1)
        local te=sub(title,i+1,#title)
        title = ts..string.char(random(33,96))..te
    end
    end
    if t%8==0 then
        title=sub(title,1,titlelock-1)..sub('MOMENTUM',titlelock,titlelock)..sub(title,titlelock+1,#title)
        titlelock=titlelock+1
    end

    fg(1,1,1,1)
    lg.setCanvas(canvas3)
    lg.setFont(lcdfont)
    lg.print(title,309/2+60-80-10+4-1-bar_dist,24+24-1+60+60-40+20+10+2)
    lg.setCanvas(canvas)

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    for ry=-grid,309,grid do
    for rx=-grid,309,grid do
    if rx+ry<24+60+80-30-10-bar_xh or rx+ry>smolrect[2]+16+16+math.min(bar_dist,(30+309-60+60+8-3)-(309-60)-35) then
    rect('fill',rx-ry-t%(grid*2),rx+ry,grid,grid)
    end
    end
    end
    lg.pop()

    lg.push()
    lg.rotate(-pi/4)
    fg(0x68/255,0x70/255,0x4b/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-10-bar_xh,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+20+bar_xw)
    fg(0xcd/255,0xcd/255,0xc8/255)
    rect('fill',0+60-80-100-30-60-20,24+60+80-30-bar_xh,309+200,lcdfont:getHeight('MOMENTUM')+24+2+2+bar_xw)
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
    rect('fill',smolrect[1],smolrect[2]+math.min(bar_dist,(30+309-60+60+8-3)-(309-60)-35),smolrect[3],smolrect[4])
    lg.pop()
    
    bar_dist=bar_dist-4; if bar_dist<0 then bar_dist=0 end
    --bar_dist_y=nil
    bar_xh=bar_xh-0.2; if bar_xh<0 then bar_xh=0 end
    bar_xw=bar_xw-2; if bar_xw<0 then
    bar_xw=0
    if bar_dist==0 and title=='MOMENTUM' then 
    onlyoncem2=nil
    audio.mewsic4:stop()
    audio.mewsic4:setVolume(1)
    love.update=menu; love.draw=menudraw
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

function galleryzoom()
    bar_xh=bar_xh+4
    bar_xw=bar_xw+8
    if bar_xh>150 then bar_xh=150; bar_xw=450-30 end
    
    vc_x=vc_x+(0-vc_x)*0.1
    vc_y=vc_y+(0-vc_y)*0.1
    vc_scale=vc_scale+(1-vc_scale)*0.1
    if math.abs(vc_x-0)<1 then 
        vc_x=0;vc_y=0;vc_scale=1 
        simulate(main_wld,vcanvas)

        lg.setCanvas()
        lg.draw(vcanvas,vc_x,vc_y,0,vc_scale,vc_scale)
    else
        gallerydraw()
    end
    
    local et=love.timer.getTime()
    while deltat+et-st<1/60 do et=love.timer.getTime() end
end