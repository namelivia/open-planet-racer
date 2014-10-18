require './Common/Menu.rb'
require './Common/ScrollingText.rb'
require './Race/StarField.rb'

#States:
# 0 - Quick Race
# 1 - Story Mode
# 2 - Options
# 3 - Credits

class MainMenu

  attr_accessor :finished

  def initialize(window,resource_manager,sound_options)
    @finished = 0
    @state = 0
    @titleImage = resource_manager.title_image
    @menu = Menu.new(window,220,50,'Main Menu',resource_manager.font,resource_manager.cursor_sound)
    @menu.add_item('Quick Race',nil)   
    @menu.add_item('Story Mode',nil)   
    @menu.add_item('Options',nil)   
    @menu.add_item('Credits',nil)   
    @menu.add_item('Exit',nil)   

    @optionsMenu = Menu.new(window,100,100,'Options',resource_manager.font,resource_manager.cursor_sound)
    @optionsMenu.add_item('Music Volume',sound_options.music_volume*100)
    @optionsMenu.add_item('Sound FX Volume',sound_options.fx_volume*100)
    @optionsMenu.add_item('Back',nil)

    @credits = ScrollingText.new(window,100,'../Credits',20)
    
    @idleTime = IDLE_TIME
		resource_manager.music.sample.play
    @acceptFX = resource_manager.cursor_select
    @backFX = resource_manager.cursor_back

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
          @menu.prev
        when 2
          @optionsMenu.prev
        end
    elsif window.button_down? Gosu::Button::KbDown then
      case @state
        when 0
          @menu.next
        when 2
          @optionsMenu.next
        end
    end
    if window.button_down? Gosu::Button::KbSpace and @idleTime == 0 then
    case @state
      when 0
      case @menu.selected
        when 0
    	  @acceptFX.play(false)
          @finished = 2
        when 1
    	  @acceptFX.play(false)
          @finished = 2
        when 2
    	  @acceptFX.play(false)
          @idleTime = IDLE_TIME
          @state = 2
        when 3
    	  @acceptFX.play(false)
          @idleTime = IDLE_TIME
          @credits.reset()
          @state = 3
        when 4
    	  @acceptFX.play(false)
          @finished = -1
        end
      when 2
      case @optionsMenu.selected
        when 2
    	  @backFX.play(false)
          @idleTime = IDLE_TIME
          @state = 0
        end
      when 3
    	@backFX.play(false)
        @idleTime = IDLE_TIME
        @state = 0
      end
      end
  end

  def draw(window)
      @titleImage.draw(0,0,0)
      color = Color.new(200,0,0,0)
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

