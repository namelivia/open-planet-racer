require 'rubygems'
require 'gosu'
require 'chipmunk'
require './Race/Race.rb'
require './Intro/Intro.rb'
require './SoundOptions.rb'
require './MainMenu/MainMenu.rb'
require './GameState.rb'

include Gosu

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

class Game < Window

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Planet Racer"
    @soundOptions = SoundOptions.new()
    @gameState = GameState.new()
    @intro = Intro.new(self)
  end
 
  def transition(currentScreen)
    @gameState.stage = currentScreen.finished
    currentScreen = nil
    case @gameState.stage
    when 0
      @intro = Intro.new(self)
    when 1
      @mainMenu = MainMenu.new(self,@soundOptions)
    when 2
      @race = Race.new(self,@soundOptions)
    end
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
        if @intro.finished != 0
          transition(@intro)
        end
     when 1
        @mainMenu.draw(self)
        if @mainMenu.finished != 0
          transition(@mainMenu)
        end
     when 2
        @race.draw(self)
        if @race.finished != 0
          @race.finalize()
          transition(@race)
        end
     end
  end
end

window = Game.new
window.show
exit!
