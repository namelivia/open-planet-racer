require 'rubygems'
require 'gosu'
require 'chipmunk'
require './Race/Race.rb'
require './Intro/Intro.rb'
require './MainMenu/MainMenu.rb'
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
     case @gameState.stage
     when 0
        @intro.update(self)
     when 1
        @mainMenu.update(self)
     when 2
        @race.update(self)
     end
  end

  def draw
     case @gameState.stage
     when 0
        @intro.draw(self)
        if @intro.finished
          @intro = nil
          @gameState.stage += 1
          @mainMenu = MainMenu.new(self)
        end
     when 1
        @mainMenu.draw(self)
        if @mainMenu.finished
          @mainMenu = nil
          @gameState.stage += 1
          @race = Race.new(self)
        end
     when 2
        @race.draw(self)
        if @race.finished
          @race.finalize()
          @race = nil
          @gameState.stage -= 1
          @mainMenu = MainMenu.new(self)
        end
     end
  end
end

window = Game.new
window.show
exit!
