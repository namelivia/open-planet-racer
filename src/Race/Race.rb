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
    @soundOptions = soundOptions
    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0,rand(10)+2)
    floorColor = Color.new(255,rand(155)+100,rand(155)+100,rand(155)+100)
    @level = Level.new(window,@space,100,200,floorColor)
    initialPosition = CP::Vec2.new(80,200)
    @car = Car.new(window,@space,initialPosition,true,soundOptions.soundFXVolume)
    rivalInitialPosition = CP::Vec2.new(-80,200)
    @rival = Car.new(window,@space,rivalInitialPosition,false,soundOptions.soundFXVolume)
    @space.add_collision_handler(:chasis,:floor,CollisionHandler.new(window,@car,0,soundOptions.soundFXVolume)) 
    @space.add_collision_handler(:wheel,:floor,CollisionHandler.new(window,@car,1,soundOptions.soundFXVolume)) 
    @space.add_collision_handler(:bigWheel,:floor,CollisionHandler.new(window,@car,2,soundOptions.soundFXVolume)) 
    
    @userInterface = UI.new(window,@car.afterburner)
    @music = Music.new(window,rand(6),soundOptions.musicVolume)
    @finishSFX = SoundFX.new(window,"../media/sfx/finish.ogg",soundOptions.soundFXVolume)
    @pauseMenu = Menu.new(window,100,200,'Paused',38)   
    @pauseMenu.addItem('Resume',-1)
    @pauseMenu.addItem('Exit',-1)

    @dt = (1.0/60.0)
    @paused = false
    @lastPause = 0 
    @scroll_x = @scroll_y = 0
    @counter = 0
    @time = 0
    @rivalTime = 20+rand(20)
    @rivalTeleported = false
    @finishedText = false
    @finished = 0
  end

  def update(window)

    if @lastPause < 10 then
      @lastPause +=1
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
    if window.button_down? Gosu::Button::KbEscape then
     if @lastPause == 10 then
       @paused = !@paused
       if @paused then
         @pauseTime = Time.now
       end
       @car.pause(@paused)
       @rival.pause(@paused)
       @lastPause = 0
     end
    end

    @car.update(window)
    @rival.update(window)
    
    if not @paused
    SUBSTEPS.times do
      @space.step(@dt)
    end
    if not @finishedText and not @car.destroyed then
       @time += 0.017
    else
      @counter += 1
    end
    if not @finishedText then
      @scroll_x = @car.position.x-SCREEN_WIDTH/2
      @scroll_y = @car.position.y-SCREEN_HEIGHT/2
    end
    end
    if @counter == 400
      @finished = 1
    end

    completed = ((@car.position.x-300)/(@level.levelLength-230))*180
    rival = (@time/@rivalTime)*180
    @userInterface.update(completed,rival)
    #Rival AI
    if @time<5 then
       @rival.accelerate(true)
    end
    if @time>@rivalTime and not @rivalTeleported then
    newPosition = CP::Vec2.new(@level.levelLength+600,@level.finishHeight-200)
    @rival = Car.new(window,@space,newPosition,false,@soundOptions.soundFXVolume)
    @rivalTeleported = true
    end 
    if @rivalTeleported then
      @rival.accelerate(true)
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
    @car.draw(window,@scroll_x,@scroll_y)
    @rival.draw(window,@scroll_x,@scroll_y)
    if @car.life < 0 and not @car.destroyed then
       @car.destroy(@space)
    end

    if @car.position.x > @level.levelLength and not @finishedText then
      @finishedText = true
      @finishSFX.play(false)
      @car.finish()
    end
    
    if @paused then
      pausecolor = Color.new(100,0,0,0)
      window.draw_quad(0,0,pausecolor,
		       0,SCREEN_HEIGHT,pausecolor,
                       SCREEN_WIDTH,0,pausecolor,
                       SCREEN_WIDTH,SCREEN_HEIGHT,pausecolor)
      @pauseMenu.draw(window)
    end
     @userInterface.draw(@car.afterburner,@time,@car.destroyed,@finishedText) 
  end

  def finalize()
    @car.finalize()
    @rival.finalize()
    @music.stop()
  end

end

