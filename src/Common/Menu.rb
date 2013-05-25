require './Common/Slider.rb'

class Menu

  attr_accessor :selectedOption

  def initialize(window,x,y,title,fontSize)
    @x = x
    @y = y
    @title = title
    @options = []
    @values = []
    @fontSize = fontSize
    @font = Gosu::Font.new(window, "Arial", @fontSize)
    @selectedOption = 0
    @mainPadding = 10
    @timeOut = 0
    @slider = Slider.new(50)
  end

  def addItem(name,value)
    @options.push(name)
    if (value != -1)
      @options.push(value)
    end
    @maxLength = @options.group_by(&:size).max.last.first.length/2
  end

  def update()
    if @timeOut < 20 then
      @timeOut += 1
    end
  end

  def nextOption()
    if @timeOut == 20 then
    @selectedOption += 1
    @timeOut = 0
    if @selectedOption>@options.length-1 then
      @selectedOption = 0
    end
    end
  end

  def prevOption()
    if @timeOut == 20 then
    @selectedOption -= 1
    @timeOut = 0
    if @selectedOption<0 then
      @selectedOption = @options.length-1
    end
    end
  end

  def draw(window)
      selectedColor = Color.new(255,0,0,100)
      unselectedColor = Color.new(255,0,0,255)
      backgroundColor = Color.new(255,80,80,80)
      window.draw_quad(@x-@mainPadding,@y-@mainPadding,backgroundColor,
		       @x+@mainPadding+@maxLength*@fontSize,@y-@mainPadding,backgroundColor,
                       @x-@mainPadding,(@y+(@options.length+1)*@fontSize)+@mainPadding,backgroundColor,
                       @x+@mainPadding+@maxLength*@fontSize,@y+((@options.length+1)*@fontSize)+@mainPadding,backgroundColor)
      color = Color.new(0,0,0,255)
      @font.draw(@title, @x, @y, 1.0, 1.0, 1.0)
      @options.each_with_index do |option,i|
        if i==@selectedOption then
      	  window.draw_quad(@x,@y+((i+1)*@fontSize),unselectedColor,
                           @x+@maxLength*@fontSize,@y+((i+1)*@fontSize),unselectedColor,
                           @x,@y+((i+2)*@fontSize),unselectedColor,
			   @x+@maxLength*@fontSize,@y+((i+2)*@fontSize),unselectedColor)
      	else
      	  window.draw_quad(@x,@y+((i+1)*@fontSize),selectedColor,
			   @x+@maxLength*@fontSize,@y+((i+1)*@fontSize),selectedColor,
                           @x,@y+((i+2)*@fontSize),selectedColor,
                           @x+@maxLength*@fontSize,@y+((i+2)*@fontSize),selectedColor)
        end
        if i==@selectedOption then
	  @font.draw("<c=ffff00>#{option}</c>",@x,@y+((i+1)*@fontSize), 1.0, 1.0, 1.0)
        else
	  @font.draw(option,@x,@y+((i+1)*@fontSize), 1.0, 1.0, 1.0)
        end
        @slider.draw(window,@x,@y+((i+1)*@fontSize),@maxLength*@fontSize,@fontSize)
      end
  end

end
