require './Common/Menu.rb'
require './Race/Level.rb'


#States:
# 0 - Main Menu
# 1 - Options
# 2 - Credits

class MainMenu

  attr_accessor :finished

  def initialize(window,soundOptions)
    @finished = 0
    @state = 0 
    @menu = Menu.new(window,220,100,'Main Menu',80)
    @menu.addItem('New Race',-1)   
    @menu.addItem('Options',-1)   
    @menu.addItem('Credits',-1)   
    @menu.addItem('Exit',-1)   

    @optionsMenu = Menu.new(window,100,100,'Options',80)
    @optionsMenu.addItem('Music Volume',soundOptions.musicVolume)
    @optionsMenu.addItem('Sound FX Volume',soundOptions.soundFXVolume)
    @optionsMenu.addItem('Back',-1)

    @credits = Menu.new(window,100,100,'Credits',80)
    @credits.addItem('Back',-1)
    
    @space = CP::Space.new
    floorColor = Color.new(255,rand(155)+100,rand(155)+100,rand(155)+100)
    @level = Level.new(window,@space,100,200,floorColor)
    @idleTime = 50
  end

  def update(window)
    if @idleTime > 0 
       @idleTime -= 1
    end
    case @state
      when 0
        @menu.update()
      when 1
        @optionsMenu.update()
      when 2
      end
    if window.button_down? Gosu::Button::KbUp then
      case @state
        when 0
          @menu.prevOption()
        when 1
          @optionsMenu.prevOption()
        end
    elsif window.button_down? Gosu::Button::KbDown then
      case @state
        when 0
          @menu.nextOption()
        when 1
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
          @idleTime = 50
          @state = 1
        when 2
          @idleTime = 50
          @state = 2
        when 3
          exit
        end
      when 1
      case @optionsMenu.selectedOption
        when 0
        when 1
        when 2
        when 3
        when 4
          @idleTime = 50
          @state = 0
        end
      when 2
        @idleTime = 50
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

      @level.draw(window,500,0,SCREEN_HEIGHT,color3)
      color = Color.new(0,0,0,255)
      window.draw_quad(0,0,color,0,SCREEN_HEIGHT,color,SCREEN_WIDTH,0,color,SCREEN_WIDTH,SCREEN_HEIGHT,color)
      case @state
      when 0
        @menu.draw(window)
      when 1
        @optionsMenu.draw(window)
      when 2
        @credits.draw(window)
      end
  end
end

