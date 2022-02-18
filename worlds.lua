function new_world()
    local w={}
    w.score=0

    w.spawn_t=2000
    w.spawn_dt=1000

    w.ball={x=309/2-12, y=96, dx=0, dy=0}
    set_ball_image(w)
    
    w.ball.lethalt=0

    w.bonuses={}
    w.plrbonus=0
    if debug then w.plrbonus=10 end

    w.shifters={}
    w.spawners={}
    for i=1,5 do
        local sx,sy=grid*i+1,309/2-grid+grid*i+1
        ins(w.shifters,{x=sx,y=sy})
        ins(w.shifters,{x=309-sx-43,y=sy})
    end
    
    w.shouts={}
    w.particles={}

    w.rp={i=1}

    w.t=0

    return w
end

function reset(w,noresettime)
    w=w or main_wld
    w.score=0
    w.ball.x=309/2-12; w.ball.y=96; w.ball.dx=0; w.ball.dy=0; w.ball.bonus=nil
    w.plrbonus=0
    if debug then w.plrbonus=10 end
    w.bonuses={}

    w.spawn_t=2000
    w.spawn_dt=1000
    
    w.shifters={}
    w.spawners={}
    for i=1,5 do
        local sx,sy=grid*i+1,309/2-grid+grid*i+1
        ins(w.shifters,{x=sx,y=sy})
        --prep_spec(w.shifters[#w.shifters],w)
        ins(w.shifters,{x=309-sx-43,y=sy})
        --prep_spec(w.shifters[#w.shifters],w)
    end
    if w.mode=='Chaotic' then
        ins(w.shifters,{x=grid*0+1,y=309/2-grid+grid*0+1})
        prep_spec(w.shifters[#w.shifters],w)

        ins(w.shifters,{x=309-grid*0+1-43-1-1,y=309/2-grid+grid*0+1+1-1})
        prep_spec(w.shifters[#w.shifters],w)
    end
    
    w.shouts={}
    w.particles={}

    if love.update~=replay and love.update~=rp_gallery and love.update~=rp_zoom then 
        w.rp={i=1} 
        love.update=update
    end

    if not noresettime then
    w.t=0
    end
end

function set_ball_image(w)
    w.ball.img=lg.newCanvas(26,26)
    lg.setCanvas(w.ball.img)
    fg(0xa0/255.0,0xa0/255.0,0xa0/255.0)
    circ('fill',13,13,13)
    fg(0xf0/255.0,0xf0/255.0,0xf0/255.0)
    circ('fill',13,13,12.8)
    lg.setCanvas()
    w.ball.imgdata=w.ball.img:newImageData()
end