function input()
    local press=false
    if ((love.keyboard.isDown('a') or love.keyboard.isDown('left')) and love.update~=replay) or (love.update==replay and find(rp[rp.i],'a')) then
        press=true
        if ball.dx > -1 then
            ball.dx = ball.dx-math.abs((ball.dx-(-1))/2.0)
        end
        ball.dx=ball.dx-xspeed
        if love.update~=replay then ins(rp[#rp],'a') end
    end
    if ((love.keyboard.isDown('d') or love.keyboard.isDown('right')) and love.update~=replay) or (love.update==replay and find(rp[rp.i],'d')) then
        press=true
        if ball.dx < 1 then
            ball.dx = ball.dx+math.abs((ball.dx-1)/2.0)
        end
        ball.dx=ball.dx+xspeed
        if love.update~=replay then ins(rp[#rp],'d') end
    end
    if (plrbonus>0 and ((tapped('lshift') or tapped('rshift')) and love.update~=replay) and not ball.bonus) or (love.update==replay and find(rp[rp.i],'shift')) then
        ball.bonus=65
        plrbonus=plrbonus-1
        audio.powerup:stop()
        audio.powerup:play()
        --print('bonus')
        if love.update~=replay then ins(rp[#rp],'shift') end
    end
    if not press then
        ball.dx=ball.dx*0.98
    end
end