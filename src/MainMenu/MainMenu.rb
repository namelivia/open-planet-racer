require './Common/Menu.rb'
require './Common/ScrollingText.rb'
require './Race/StarField.rb'

class MainMenu

  attr_accessor :finished

  def initialize(window,resource_manager,sound_options)
    @finished = 0
    @current_state = 0
		@states = []
    @title_image = resource_manager.title_image
		resource_manager.music.sample.play
    @idle = IDLE_TIME
    @credits =
			ScrollingText.new(window,
												100,
												resource_manager.credits,
												resource_manager.font,
												resource_manager.cursor_back
											 ) { @current_state = 0 }
    @menu = Menu.new(window,220,50,'Main Menu',resource_manager.font,resource_manager.cursor_sound)
    @menu.add_item('Quick Race',nil,resource_manager.cursor_select) { @finished = 2 }
    @menu.add_item('Story Mode',nil,resource_manager.cursor_select) { @finished = 3 }  
    @menu.add_item('Options',nil,resource_manager.cursor_select) { @current_state = 1 }
    @menu.add_item('Credits',nil,resource_manager.cursor_select) { @credits.reset; @current_state = 2 }
    @menu.add_item('Exit',nil,resource_manager.cursor_back) { @finished = -1 }
    @options_menu = Menu.new(window,100,100,'Options',resource_manager.font,resource_manager.cursor_sound)
    @options_menu.add_item('Music Volume',sound_options.music_volume*100,nil)
    @options_menu.add_item('Sound FX Volume',sound_options.fx_volume*100,nil)
    @options_menu.add_item('Back',nil,resource_manager.cursor_back) { @current_state = 0 }
		@states.push(@menu)
		@states.push(@options_menu)
		@states.push(@credits)
  end

  def update(window)
    @idle -= 1 if @idle > 0 
		@states[@current_state].update

		input = {'left' => window.button_down?(Gosu::Button::KbLeft),
					 	 'right' => window.button_down?(Gosu::Button::KbRight),
						 'up' => window.button_down?(Gosu::Button::KbUp),
						 'down' => window.button_down?(Gosu::Button::KbDown),
						 'action' => window.button_down?(Gosu::Button::KbSpace)}

			@states[@current_state].decrement_value if input["left"]
			@states[@current_state].increment_value if input["right"]
			@states[@current_state].prev if input["up"]
			@states[@current_state].next if input["down"]
			if input["action"] and @idle == 0 then
				@idle = IDLE_TIME
				@states[@current_state].select
			end
	end

  def draw(window)
      @title_image.draw(0,0,0)
      color = Color.new(200,0,0,0)
      window.draw_quad(0,0,color,0,SCREEN_HEIGHT,color,SCREEN_WIDTH,0,color,SCREEN_WIDTH,SCREEN_HEIGHT,color)
			@states[@current_state].draw(window)
  end
end

