class ScrollingText

  def initialize(window,x,text,fontSize)
    @x = x
    @text = text
    @fontSize = fontSize
    @font = Gosu::Font.new(window, "Arial", @fontSize)
  end

  def reset()
    @y = 700
  end

  def update()
    @y -= 1
  end

  def draw(window)
    File.readlines(@text).each_with_index do |line,i|
      @font.draw(line.chomp, @x, @y+@fontSize*i, 1.0, 1.0, 1.0)
    end
  end
end
