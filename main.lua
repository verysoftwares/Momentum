-- file linking.
    require 'load'
    require 'alias'
    require 'utility'
    require 'input'
    require 'collide'
    require 'shifters'
    require 'bonuses'
    require 'particles'
    require 'menu'
    require 'update'
    require 'draw'

love.update = menu
love.draw = menudraw
if debug then
love.update = tutor
love.draw = gamedraw
mode='Standard'
end

t = 0
-- runtime.
    print(fmt('made by verysoftwares with LOVE %d.%d', love.getVersion()))