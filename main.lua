-- file linking.
    require 'load'
    require 'alias'
    require 'utility'
    require 'file-io'
    require 'deep'
    require 'input'
    require 'collide'
    require 'shifters'
    require 'bonuses'
    require 'particles'
    require 'worlds'
    require 'game-update'
    require 'game-draw'
    require 'menu-update'
    require 'menu-draw'
    require 'gallery-update'
    require 'gallery-draw'

love.update = menu
love.draw = menudraw

loadprogress()

t = 0
-- runtime.
    print(fmt('made by verysoftwares with LOVE %d.%d', love.getVersion()))