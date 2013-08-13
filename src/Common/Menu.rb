require './Common/TextItem.rb'

class Menu

  attr_accessor :selectedOption

  def initialize(window,x,y,title,fontSize)
    @x = x
    @y = y
    @title = title
    @items = []
    @font = Gosu::Font.new(window, "Arial",fontSize)
    @Smallfont = Gosu::Font.new(window, "Arial",fontSize/2)
    @selectedOption = 0
    @mainPadding = 10
    @timeOut = 0
  end

  def addItem(name,value)
    if (value == -1)  then
      newItem = TextItem.new(name,@items.length+1)
    else
      newItem = TextItem.new(name+" : "+value.to_s,@items.length+1)
    end 
    @items.push(newItem)
    @maxLength = @items.map(&:text).group_by(&:size).max.last.first.length/2
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
    if @selectedOption>@items.length-1 then
      @selectedOption = 0
    end
    end
  end

  def prevOption()
    if @timeOut == 20 then
    @selectedOption -= 1
    @timeOut = 0
    if @selectedOption<0 then
      @selectedOption = @items.length-1
    end
    end
  end

  def draw(window)
      selectedColor = Color.new(255,0,0,100)
      unselectedColor = Color.new(255,0,0,255)
      backgroundColor = Color.new(255,80,80,80)
      window.draw_quad(@x-@mainPadding,@y-@mainPadding,backgroundColor,
		       @x+@mainPadding+@maxLength*@font.height,@y-@mainPadding,backgroundColor,
                       @x-@mainPadding,(@y+(@items.length+1)*@font.height)+@mainPadding,backgroundColor,
                       @x+@mainPadding+@maxLength*@font.height,@y+((@items.length+1)*@font.height)+@mainPadding,backgroundColor)
      color = Color.new(0,0,0,255)
      @font.draw(@title, @x, @y, 1.0, 1.0, 1.0)
      @items.each_with_index do |item,i|
        item.draw(window,@x,@y,@font,@maxLength,@selectedOption)
      end
  end

end
