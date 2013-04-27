class Intro

  attr_accessor :finished

  def initialize(window)
    @counter = 0
    @font = Gosu::Font.new(window, "Arial", 18)
    @finished = false;
  end

  def update(window)
    if window.button_down? Gosu::Button::KbEscape then
       @counter = 500
    else
       @counter += 1
    end
    if @counter == 500
       @finished = true
    end
  end

  def draw(window)
    color = Color.new(0,0,0,255)
    window.draw_quad(0,0,color,0,SCREEN_HEIGHT,color,SCREEN_WIDTH,0,color,SCREEN_WIDTH,SCREEN_HEIGHT,color)
    @font.draw("Open Planet Racer", 10, 10, 1.0, 1.0, 1.0)
    @font.draw("By Namelivia", 10, 30, 1.0, 1.0, 1.0)
    @font.draw("http://www.github.com/namelivia", 10, 50, 1.0, 1.0, 1.0)
    @font.draw("This is just a work in progress demo!", 10, 70, 1.0, 1.0, 1.0)
  end
end

