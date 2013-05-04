require 'rubygems'
require 'gosu'
require 'chipmunk'
require './Race/Race.rb'
require './Intro/Intro.rb'
require './GameState.rb'

include Gosu

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

class Game < Window

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Planet Racer"
    @gameState = GameState.new()
    @intro = Intro.new(self)
  end

  def update
     if @gameState.stage == 0
        @intro.update(self)
     else
        @race.update(self)
     end
  end

  def draw
     if @gameState.stage == 0
        @intro.draw(self)
        if @intro.finished
          @intro = nil
          @gameState.stage += 1
          @race = Race.new(self)
        end
     else
        @race.draw(self)
        if @race.finished
          @race = nil
          @gameState.stage -= 1
          @intro = Intro.new(self)
        end
     end
  end
end

window = Game.new
window.show
exit!
