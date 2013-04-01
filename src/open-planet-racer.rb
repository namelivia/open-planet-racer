require 'rubygems'
require 'gosu'
require 'chipmunk'
require './Race.rb'

include Gosu

module ZOrder
   Background, Box = *0..1
end

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

class Game < Window

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Planet Racer"
    @race = Race.new(self)
  end

  def update
    @race.update(self)
  end

  def draw
    @race.draw(self)
  end
end

window = Game.new
window.show
exit!
