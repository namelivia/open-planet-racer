class Intro

  attr_accessor :finished

  def initialize(window,soundOptions)
    @counter = 0
    @font = Gosu::Font.new(window, "../media/fonts/press-start-2p.ttf", 20)
    @titleImage = Image.new(window,"../media/gfx/title.png",true)
    @namelivia = Image.new(window,"../media/gfx/namelivia.png",true)
    @finished = 0;
    @idleTime = 0;
    @music = Music.new(window,7,soundOptions.musicVolume)
  end

  def update(window)
      @counter += 1
      if @idleTime < IDLE_TIME then
        @idleTime += 1
      end 
      if window.button_down? Gosu::Button::KbSpace and @idleTime == IDLE_TIME then
         @counter  += 500
         @idleTime = 0
         @fadingCounter = 1;
      if @counter > 1000
         @finished = 1
      end
    end
  end

  def draw(window)
    if @counter < 500
      @font.draw("By:", 150, 90, 1.0, 1.0, 1.0)
      @font.draw("http://www.github.com/namelivia", 40, 470, 1.0, 1.0, 1.0)
      @font.draw("This is just a work in progress demo!", 40, 500, 1.0, 1.0, 1.0)
      @namelivia.draw(230,130,0)
    else
      @titleImage.draw(0,0,0)
    end
  end
end

