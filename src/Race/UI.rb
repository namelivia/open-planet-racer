require './Race/Minimap.rb'
require './Race/PowerBar.rb'

class UI
  def initialize(window,afterburner)
    @minimap = Minimap.new(window)
    @powerbar = PowerBar.new(window,5,5,afterburner)
    @font = Gosu::Font.new(window, "Arial", 18)
    @noticeFont = Gosu::Font.new(window,"Arial",60)
  end

  def update(completed,rival)
    @minimap.update(completed,rival)
  end

  def draw(afterburner,time,destroyed,finished)
    @powerbar.draw(afterburner)
    @font.draw("<c=ffff00>#{'%.2f' % time}</c>",50,100,1.0,1.0,1.0)
    @minimap.draw(20,52)
    if finished then
      @noticeFont.draw("Finished!",SCREEN_WIDTH/2-100,SCREEN_HEIGHT/2,1.0,1.0,1.0)
    elsif  destroyed then
      @noticeFont.draw("Destroyed!",SCREEN_WIDTH/2-100,SCREEN_HEIGHT/2,1.0,1.0,1.0)
    end
  end

end

