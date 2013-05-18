class Credits

  attr_accessor :finished

  def initialize(window)
    @finished = 0
    @space = CP::Space.new
    floorColor = Color.new(255,rand(155)+100,rand(155)+100,rand(155)+100)
    @level = Level.new(window,@space,100,200,floorColor)
    @idleTime = 50
  end

  def update(window)
    if @idleTime > 0
       @idleTime -= 1
    end
    if window.button_down? Gosu::Button::KbSpace and @idleTime == 0 then
        @finished = 1
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
  end
end
