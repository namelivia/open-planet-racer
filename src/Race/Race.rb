require './Race/Car.rb'
require './Race/Level.rb'
require './Race/CollisionHandler.rb'
require './Race/UI.rb'
require './Common/Menu.rb'
require './Common/RandomName.rb'

class Race

  attr_accessor :finished
  SUBSTEPS = 10

  def initialize(window,resource_manager)

    #General
    @state = 0
    @finished = 0
    @deltaTime = (1.0/60.0)
    @paused = false
    @lastPause = 0 
    @counter = 0
    @time = 0

    #Sound
    @acceptFX = resource_manager.cursor_select
    @backFX = resource_manager.cursor_back
    @finishSFX = resource_manager.finish
    @music = resource_manager.music.sample
		@music.play

    #Level
    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0,(rand(100)+20)/10)
    floorColor = Color.new(255,rand(155)+50,rand(155)+50,rand(155)+50)
    skyColor = Color.new(255,rand(100),rand(50),rand(100))
    @level = Level.new(window,@space,100,200,floorColor,skyColor)
    @scroll_x = @scroll_y = 0
    
    #Cars
    initialPosition = CP::Vec2.new(80,200)
    @car = Car.new(window,
									 @space,
									 initialPosition,
									 true,
									 resource_manager.engine_sound,
									 resource_manager.exploding_sound,
									 resource_manager.rocket_sound,
									 resource_manager.cars.sample)
    rivalInitialPosition = CP::Vec2.new(-80,200)
    @rival = Car.new(window,
										 @space,
										 rivalInitialPosition,
										 false,
										 resource_manager.engine_sound,
										 resource_manager.exploding_sound,
										 resource_manager.rocket_sound,
									   resource_manager.cars.sample)
    @rivalTeleported = false
    @rivalTime = 20+rand(20)
    @rivalName = RandomName.random_name
		@planetName = RandomName.random_name
    @rivalPortrait = resource_manager.rival_portraits.sample
  	@temperature = 50-rand(100)
    #User Interface 
    @font = Gosu::Font.new(window, "../media/fonts/press-start-2p.ttf", 18)
    @userInterface = UI.new(window,@car.afterburner)

    #Collsion Handlers
    @space.add_collision_handler(:chasis,
																 :floor,
																 CollisionHandler.new(window,@car,0,resource_manager.crash_sound)) 
    @space.add_collision_handler(:wheel,
																 :floor,
																 CollisionHandler.new(window,@car,1,resource_manager.front_wheel_sound)) 
    @space.add_collision_handler(:bigWheel,
																 :floor,
																 CollisionHandler.new(window,@car,2,resource_manager.back_wheel_sound)) 
   
    #Pause Menu 
    @pauseMenu = Menu.new(window,100,200,'Paused',resource_manager.font,resource_manager.cursor_sound)   
    @pauseMenu.add_item('Resume',nil){}
    @pauseMenu.add_item('Exit',nil){}

		#Rival sentences
		sentences = [
				'Despicable lifeform, you can\'t beat me!',
				'Your space rubish!',
				'Prepare to lose!',
				'There is no way you can win!',
				'I\'m faster than light',
				'You are slower than a space snail'
		]
		@sentence = sentences.sample
  end

  def update(window)

  ##############################
  # RACE INFO
  ##############################
  case @state
    when 0
    @counter += 1
    if @counter > 350 then
      @state = 1
      @counter = 0
    end
  
  ##############################
  # RACE
  ##############################
    when 1

      if @lastPause < IDLE_TIME then
        @lastPause +=1
      end

      #Handle controls
      if window.button_down? Gosu::Button::KbEscape then
        if @lastPause == IDLE_TIME then
          @acceptFX.play(false)
          @paused = !@paused
        end
        if @paused then
          @pauseTime = Time.now
        end
        @car.pause(@paused)
        @rival.pause(@paused)
        @lastPause = 0
      end
      if not @paused then
    	if window.button_down? Gosu::Button::KbUp then
      	  @car.accelerate(true)
    	elsif window.button_down? Gosu::Button::KbDown then
      	  @car.accelerate(false)
    	end
    	if window.button_down? Gosu::Button::KbLeft then
      	  @car.turn(true)
    	elsif window.button_down? Gosu::Button::KbRight then
      	  @car.turn(false)
    	end
    	if window.button_down? Gosu::Button::KbSpace then
      	  @car.FireAfterburner()
    	end

    	@car.update(window)
    	@rival.update(window)
        SUBSTEPS.times do
          @space.step(@deltaTime)
        end
        @scroll_x = @car.position.x-SCREEN_WIDTH/2
        @scroll_y = @car.position.y-SCREEN_HEIGHT/2
        completed = ((@car.position.x-300)/(@level.levelLength-230))*180
        rival = (@time/@rivalTime)*180
        @userInterface.update(completed,rival)
        @time += 0.017
    
        #Rival AI: This pretty much sucks
        #if @time<5 then
        #   @rival.accelerate(true)
        #end
        #if @time>@rivalTime and not @rivalTeleported then
        #newPosition = CP::Vec2.new(@level.levelLength+600,@level.finishHeight-200)
        #@rival = Car.new(window,@space,newPosition,false,@soundOptions.soundFXVolume)
        #@rivalTeleported = true
        #end 
        #if @rivalTeleported then
        #  @rival.accelerate(true)
        #end
        #

        # State transitions
	if @car.position.x > @level.levelLength and @state == 1 then
          @finishSFX.play(false)
          @car.finish()
          @state = 2
	open('../data/times', 'a') { |f|
  	f.puts @time
	}
        end
        if not @car.destroyed and @state == 1 and @car.life < 0 then
          @car.destroy(@space)
          @state = 2
        end
      else
        @pauseMenu.update()
        if window.button_down? Gosu::Button::KbUp then
          @pauseMenu.prev
        elsif window.button_down? Gosu::Button::KbDown then
          @pauseMenu.next
        end
        if window.button_down? Gosu::Button::KbSpace then
          case @pauseMenu.selected
            when 0
              @acceptFX.play(false)
              @paused = !@paused
            when 1
              @backFX.play(false)
              @finished = 1
            end
        end
      end
    when 2
      @counter += 1
      @car.update(window)
      @rival.update(window)
        SUBSTEPS.times do
          @space.step(@deltaTime)
        end
      if @counter == 400
        @finished = 1
      end
    end
  end

  def draw(window)

    color3 = Color.new(255,200,200,200)
    @level.draw(window,@scroll_x,@scroll_y,SCREEN_HEIGHT,color3)
    
    if @state == 0 then
      color = Color.new(200,0,0,0)
      window.draw_quad(0,0,color,0,SCREEN_HEIGHT,color,SCREEN_WIDTH,0,color,SCREEN_WIDTH,SCREEN_HEIGHT,color)
      @rivalPortrait.draw(12,12,0)
      @font.draw("Planet: #{@planetName}", 280, 12, 1.0, 1.0, 1.0)
      @font.draw("Gravity: #{@space.gravity.y} m/s²", 280, 42, 1.0, 1.0, 1.0)
      @font.draw("Temperature: #{@temperature} º", 280, 73, 1.0, 1.0, 1.0)
      @font.draw("Rival: #{@rivalName}", 280, 103, 1.0, 1.0, 1.0)
      @font.draw("Time: #{@rivalTime} s", 280, 133, 1.0, 1.0, 1.0)
      @font.draw(@sentence, 12, 273, 1.0, 1.0, 1.0)
    else

    @car.draw(window,@scroll_x,@scroll_y)
    @rival.draw(window,@scroll_x,@scroll_y)

    if @paused then
      pausecolor = Color.new(100,0,0,0)
      window.draw_quad(0,0,pausecolor,
		       0,SCREEN_HEIGHT,pausecolor,
                       SCREEN_WIDTH,0,pausecolor,
                       SCREEN_WIDTH,SCREEN_HEIGHT,pausecolor)
      @pauseMenu.draw(window)
    end

     @userInterface.draw(@car.afterburner,@time,@car.destroyed,@state) 
    end
  end

  def finalize
    @car.finalize
    @rival.finalize
    #@music.stop
  end

end

