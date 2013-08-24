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
IDLE_TIME = 30
FADE_SPEED = 8

class Game < Window

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Planet Racer"
    @soundOptions = SoundOptions.new()
    @gameState = GameState.new()
    @intro = Intro.new(self,@soundOptions)
    @fading = 255
  end
 
  def transition(currentScreen)
    @gameState.stage = currentScreen.finished
    currentScreen = nil
    case @gameState.stage
    when -1
      exit!
    when 0
      @intro = Intro.new(self,@soundOptions)
    when 1
      @mainMenu = MainMenu.new(self,@soundOptions)
    when 2
      @race = Race.new(self,@soundOptions)
    end
  end

  def update
     case @gameState.stage
     when 0
        if @intro.finished == 0 then
          if @fading > 0 then
            @fading -= FADE_SPEED
          else
            @intro.update(self)
          end
        else
          if @fading > 255 then
            transition(@intro)
          else
            @fading += FADE_SPEED
          end
        end
     when 1
        if @mainMenu.finished == 0 then
          if @fading > 0 then
            @fading -= FADE_SPEED
          else
            @mainMenu.update(self)
          end
        else
          if @fading > 255 then
            transition(@mainMenu)
          else
            @fading += FADE_SPEED
          end
        end
     when 2
        if @race.finished == 0 then
          if @fading > 0 then
            @fading -= FADE_SPEED
          else
            @race.update(self)
          end
        else
          if @fading > 255 then
            transition(@race)
          else
            @fading += FADE_SPEED
          end
        end
     end
  end

  def draw
     case @gameState.stage
     when 0
        @intro.draw(self)
     when 1
        @mainMenu.draw(self)
     when 2
        @race.draw(self)
     end
     fadecolor = Color.new(@fading,0,0,0)
     draw_quad(0,0,fadecolor,
            0,SCREEN_HEIGHT,fadecolor,
            SCREEN_WIDTH,0,fadecolor,
            SCREEN_WIDTH,SCREEN_HEIGHT,fadecolor,1)
  end
end

window = Game.new
window.show
exit!
