-- powerup movement, colliding 
-- similarly to the player ball.
function bonus_mvmt(w)
    for i=#w.bonuses,1,-1 do
        local bn=w.bonuses[i]
        bn.t=bn.t or 0
        bn.lethalt=bn.lethalt or 0

        local args={_sc={},c=0,spd=speed(bn),i=i}
        if bn.t>=8 then
            collide(bn,args,w)
            if args.removed then goto removed end
        end
        
        bn.dy=bn.dy+grav

        bn.x=bn.x+bn.dx
        bn.y=bn.y+bn.dy
        --bn.dx=bn.dx*0.98

        pixelperfect(bn,bn.imgdata,w.ball,w.ball.imgdata,function(args)
            w.plrbonus=w.plrbonus+1
            playsnd(audio.get)
            rem(w.bonuses,args.i)
            return true
        end,args)

        bn.t=bn.t+1
        ::removed::
    end
end