function bonus_mvmt()
    for i=#bonuses,1,-1 do
        local bn=bonuses[i]
        bn.t=bn.t or 0
        bn.lethalt=bn.lethalt or 0
        local args={_sc={},c=0,spd=speed(bn),bn=bn}
        if bn.t>=8 then
            collide(bn,args)
            if args.removed then goto removed end
        end
        bn.t=bn.t+1

        bn.dy=bn.dy+grav

        bn.x=bn.x+bn.dx
        bn.y=bn.y+bn.dy
        --bn.dx=bn.dx*0.98

        pixelperfect(bn,bn.imgdata,ball,ball.imgdata,function(args)
            plrbonus=plrbonus+1
            playsnd(audio.get)
            rem(bonuses,find(bonuses,args.bn))
            return true
        end,args)
        ::removed::
    end
end