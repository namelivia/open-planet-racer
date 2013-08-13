require './Race/Car.rb'
require './Race/Music.rb'
require './Race/Level.rb'
require './Race/CollisionHandler.rb'
require './Race/UI.rb'
require './Common/Menu.rb'

class Race

  attr_accessor :finished
  SUBSTEPS = 10

  def initialize(window,soundOptions)

    #General
    @state = 0
    @finished = 0
    @deltaTime = (1.0/60.0)
    @paused = false
    @lastPause = 0 
    @counter = 0
    @time = 0

    #Sound
    @soundOptions = soundOptions
    @finishSFX = SoundFX.new(window,"../media/sfx/finish.ogg",soundOptions.soundFXVolume)
    @music = Music.new(window,rand(6),soundOptions.musicVolume)

    #Level
    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0,(rand(100)+20)/10)
    floorColor = Color.new(255,rand(155)+100,rand(155)+100,rand(155)+100)
    @level = Level.new(window,@space,100,200,floorColor)
    @temperature = 50-rand(100)
    @planetName = (0...3).map{(65+rand(26)).chr}.join
    @scroll_x = @scroll_y = 0
    
    #Cars
    initialPosition = CP::Vec2.new(80,200)
    @car = Car.new(window,@space,initialPosition,true,soundOptions.soundFXVolume)
    rivalInitialPosition = CP::Vec2.new(-80,200)
    @rival = Car.new(window,@space,rivalInitialPosition,false,soundOptions.soundFXVolume)
    @rivalTeleported = false
    @rivalTime = 20+rand(20)
    @rivalName = (0...8).map{(65+rand(26)).chr}.join
    
    #User Interface 
    @font = Gosu::Font.new(window, "Arial", 25)
    @userInterface = UI.new(window,@car.afterburner)

    #Collsion Handlers
    @space.add_collision_handler(:chasis,:floor,CollisionHandler.new(window,@car,0,soundOptions.soundFXVolume)) 
    @space.add_collision_handler(:wheel,:floor,CollisionHandler.new(window,@car,1,soundOptions.soundFXVolume)) 
    @space.add_collision_handler(:bigWheel,:floor,CollisionHandler.new(window,@car,2,soundOptions.soundFXVolume)) 
   
    #Pause Menu 
    @pauseMenu = Menu.new(window,100,200,'Paused',38)   
    @pauseMenu.addItem('Resume',-1)
    @pauseMenu.addItem('Exit',-1)

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
        end
        if not @car.destroyed and @state == 1 and @car.life < 0 then
          @car.destroy(@space)
          @state = 2
        end
      else
        @pauseMenu.update()
        if window.button_down? Gosu::Button::KbUp then
          @pauseMenu.prevOption()
        elsif window.button_down? Gosu::Button::KbDown then
          @pauseMenu.nextOption()
        end
        if window.button_down? Gosu::Button::KbSpace then
          case @pauseMenu.selectedOption
            when 0
              @paused = !@paused
            when 1
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
    @level.draw(window,@scroll_x,@scroll_y,SCREEN_HEIGHT,color3)
    
    if @state == 0 then
      @font.draw("Planet: #{@planetName}", 300, 200, 1.0, 1.0, 1.0)
      @font.draw("Gravity: #{@space.gravity.y} m/s²", 300, 230, 1.0, 1.0, 1.0)
      @font.draw("Temperature: #{@temperature} º", 300, 260, 1.0, 1.0, 1.0)
      @font.draw("Rival: #{@rivalName}", 300, 290, 1.0, 1.0, 1.0)
      @font.draw("Time: #{@rivalTime} s", 300, 320, 1.0, 1.0, 1.0)
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

  def finalize()
    @car.finalize()
    @rival.finalize()
    @music.stop()
  end

end

