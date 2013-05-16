class Menu

  attr_accessor :selectedOption

  def initialize(window,x,y)
    @x = x
    @y = y
    @title = 'Main Menu'
    @options = ['New Race','Options','Exit']
    @maxLength = @options.group_by(&:size).max.last.first.length/2
    @fontSize = 38
    @font = Gosu::Font.new(window, "Arial", @fontSize)
    @selectedOption = 0
    @mainPadding = 10
  end

  def update(window)
  end

  def nextOption()
    @selectedOption += 1
    if @selectedOption>@options.length-1 then
      @selectedOption = 0
    end
  end

  def prevOption()
    @selectedOption -= 1
    if @selectedOption<0 then
      @selectedOption = @options.length-1
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
      end
  end

end
