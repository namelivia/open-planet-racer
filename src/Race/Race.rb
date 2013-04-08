require './Race/Music.rb'
require './Race/Car.rb'
require './Race/Level.rb'

class Race

  SUBSTEPS = 10

  def initialize(window)
    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0,rand(10)+2)
    @music = Music.new(window,rand(6))
    @moon_sprite = Image.new(window,"../media/gfx/moon.png",true)
    @stars_image = Image.new(window,"../media/gfx/stars.png",true)
    @finishSFX = SoundFX.new(window,"../media/sfx/finish.ogg")
    @dt = (1.0/60.0)
    @paused = false
    @lastPause = 0 
    @scroll_x = @scroll_y = 0
    @scroll_2x = @scroll_2y = 0

    @time = 0
    @sub_time = 0

    floorColor = Color.new(255,rand(155)+100,rand(155)+100,rand(155)+100)
    @level = Level.new(window,@space,100,200,floorColor)

    initialPosition = CP::Vec2.new(300,200)
    @car = Car.new(window,@space,initialPosition)
    @finished = false
    @font = Gosu::Font.new(window, "Arial", 18)
    @noticeFont = Gosu::Font.new(window,"Arial",60)
    @initialTime = Time.now
  end

  def update(window)

    if @lastPause < 10 then
      @lastPause +=1
    end

    if window.button_down? Gosu::Button::KbEscape then
     if @lastPause == 10 then
       @paused = !@paused
       if @paused then
         @pauseTime = Time.now
         puts @pauseTime
       else
         @currentTime -= Time.now - @pauseTime
         puts Time.now-@pauseTime
       end
       @car.pause(@paused)
       @lastPause = 0
     end
    end

    if not @paused

    SUBSTEPS.times do
      @space.step(@dt)
    end

    if not @finished and not @car.destroyed then
       @currentTime = Time.now - @initialTime
    end
    @car.update(window)
    if not @finished then
      @scroll_x = @car.position.x-SCREEN_WIDTH/2
      @scroll_y = @car.position.y-SCREEN_HEIGHT/2
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

    bg_width = @stars_image.width
    bg_height = @stars_image.height

    bg_tile_x = 0
    bg_tile_y = 0

    while bg_tile_y<SCREEN_HEIGHT*3 do

         while bg_tile_x<SCREEN_WIDTH*5 do
           @stars_image.draw(bg_tile_x-@scroll_x/10,bg_tile_y-2*SCREEN_HEIGHT-@scroll_y/10,0)
           bg_tile_x = bg_tile_x+bg_width
         end

         bg_tile_y = bg_tile_y+bg_height
         bg_tile_x = 0

    end
    @moon_sprite.draw(500-@scroll_x/5,100-@scroll_y/5,0)
    @level.draw(window,@scroll_x,@scroll_y,SCREEN_HEIGHT,color3)
    @car.draw(window,@scroll_x,@scroll_y)

    @font.draw("Afterburner", 10, 10, 1.0, 1.0, 1.0)
    @font.draw("Time: <c=ffff00>#{@currentTime}</c>",10,52,1.0,1.0,1.0)
    @font.draw("Song: <c=ffff00>#{@music.title}</c>",10,64,1.0,1.0,1.0)
    @font.draw("Life: <c=ffff00>#{@car.life}</c>",10,78,1.0,1.0,1.0)

    if @car.destroyed then
      @noticeFont.draw("Destroyed!",SCREEN_WIDTH/2-100,SCREEN_HEIGHT/2,1.0,1.0,1.0)
    end
    if @car.position.x < 0 and not @car.destroyed then
       @car.destroy(@space)
    end
    if @finished then
      @noticeFont.draw("Finished!",SCREEN_WIDTH/2-100,SCREEN_HEIGHT/2,1.0,1.0,1.0)
    end

    if @car.position.x > @level.levelLength and not @finished then
      @finished = true
      @finishTime = @currentTime
      @finishSFX.play(false)
      @car.finish()
    end
    if @paused then
      pausecolor = Color.new(100,0,0,0)
      window.draw_quad(0,0,pausecolor,0,SCREEN_HEIGHT,pausecolor,SCREEN_WIDTH,0,pausecolor,SCREEN_WIDTH,SCREEN_HEIGHT,pausecolor )
    end
  end
end

