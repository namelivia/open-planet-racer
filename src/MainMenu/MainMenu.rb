require './MainMenu/Menu.rb'

class MainMenu

  attr_accessor :finished

  def initialize(window)
    @finished = false
    @menu = Menu.new(window,200,100)
    @timeout = 0
  end

  def update(window)
    if @timeout > 0 then 
      @timeout -= 1
    else
    if window.button_down? Gosu::Button::KbUp then
      @menu.prevOption()
      @timeout = 20
    elsif window.button_down? Gosu::Button::KbDown then
      @menu.nextOption()
      @timeout = 20
    end
    end
    if window.button_down? Gosu::Button::KbSpace then
      case @menu.selectedOption
      when 0
        @finished = true
      when 1
      when 2
        exit
      end
    end
  end

  def draw(window)
      color = Color.new(0,0,0,255)
      window.draw_quad(0,0,color,0,SCREEN_HEIGHT,color,SCREEN_WIDTH,0,color,SCREEN_WIDTH,SCREEN_HEIGHT,color)
      @menu.draw(window)
  end
end

