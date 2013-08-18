require './Common/Menu.rb'
require './Common/ScrollingText.rb'
require './Race/Level.rb'

#States:
# 0 - Quick Race
# 1 - Story Mode
# 2 - Options
# 3 - Credits

class MainMenu

  attr_accessor :finished

  def initialize(window,soundOptions)
    @finished = 0
    @state = 0 
    @menu = Menu.new(window,220,50,'Main Menu',80)
    @menu.addItem('Quick Race',-1)   
    @menu.addItem('Story Mode',-1)   
    @menu.addItem('Options',-1)   
    @menu.addItem('Credits',-1)   
    @menu.addItem('Exit',-1)   

    @optionsMenu = Menu.new(window,100,100,'Options',50)
    @optionsMenu.addItem('Music Volume',soundOptions.musicVolume*100)
    @optionsMenu.addItem('Sound FX Volume',soundOptions.soundFXVolume*100)
    @optionsMenu.addItem('Back',-1)

    @credits = ScrollingText.new(window,100,'../Credits',50)
    
    @idleTime = IDLE_TIME
    @music = Music.new(window,rand(6)+1,soundOptions.musicVolume)

  end

  def update(window)
    if @idleTime > 0 
       @idleTime -= 1
    end
    case @state
      when 0
        @menu.update()
      when 2
        @optionsMenu.update()
      when 3
        @credits.update()
      end

    if window.button_down? Gosu::Button::KbLeft and @state == 2 then
      @optionsMenu.decValue()
    else
    if window.button_down? Gosu::Button::KbRight and @state == 2 then
      @optionsMenu.incValue()
    end
    end

    if window.button_down? Gosu::Button::KbUp then
      case @state
        when 0
          @menu.prevOption()
        when 2
          @optionsMenu.prevOption()
        end
    elsif window.button_down? Gosu::Button::KbDown then
      case @state
        when 0
          @menu.nextOption()
        when 2
          @optionsMenu.nextOption()
        end
    end
    if window.button_down? Gosu::Button::KbSpace and @idleTime == 0 then
    case @state
      when 0
      case @menu.selectedOption
        when 0
          @finished = 2
        when 1
          @finished = 2
        when 2
          @idleTime = IDLE_TIME
          @state = 2
        when 3
          @idleTime = IDLE_TIME
          @credits.reset()
          @state = 3
        when 4
          exit
        end
      when 2
      case @optionsMenu.selectedOption
        when 2
          @idleTime = IDLE_TIME
          @state = 0
        end
      when 3
        @idleTime = IDLE_TIME
        @state = 0
      end
      end
  end

  def draw(window)

    limit = 0
    size = 9
    color = Color.new(255,0,0,0)
    color3 = Color.new(255,200,200,200)

    while limit+size<SCREEN_HEIGHT+20 do

        window.draw_quad(0,limit,color,0,limit+size,color,SCREEN_WIDTH,limit+size,color,SCREEN_WIDTH,limit,color)
        color.red += 1
        color.blue += 1
        limit += size
        size = size

    end

      color = Color.new(0,0,0,255)
      window.draw_quad(0,0,color,0,SCREEN_HEIGHT,color,SCREEN_WIDTH,0,color,SCREEN_WIDTH,SCREEN_HEIGHT,color)
      case @state
      when 0
        @menu.draw(window)
      when 2
        @optionsMenu.draw(window)
      when 3
        @credits.draw(window)
      end
  end
end

