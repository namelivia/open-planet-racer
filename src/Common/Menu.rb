require './Common/TextItem.rb'

class Menu

  attr_accessor :selectedOption

  def initialize(window,x,y,title,fontSize,soundOptions)
    @x = x
    @y = y
    @title = title
    @items = []
    @font = Gosu::Font.new(window, "../media/fonts/press-start-2p.ttf",fontSize)
    @Smallfont = Gosu::Font.new(window, "../media/fonts/press-start-2p.ttf",fontSize/2)
    @selectedOption = 0
    @mainPadding = 10
    @timeOut = 0
    @soundFX = SoundFX.new(window,"../media/sfx/cursorMove.ogg",soundOptions.soundFXVolume)
  end

  def addItem(name,value)
    if (value == -1)  then
      newItem = TextItem.new(name,@items.length+1,value)
    else
      newItem = TextItem.new(name,@items.length+1,value)
    end 
    @items.push(newItem)
    @maxLength = @items.map(&:text).group_by(&:size).max.last.first.length
  end

  def update()
    if @timeOut < IDLE_TIME then
      @timeOut += 1
    end
  end
 
  def incValue()
    if @timeOut == IDLE_TIME then
      @items[@selectedOption].value += 1
      @timeOut = 0
      @soundFX.play(false)
    end
  end

  def decValue()
    if @timeOut == IDLE_TIME then
      @items[@selectedOption].value -= 1
      @timeOut = 0
      @soundFX.play(false)
    end
  end
  
  def nextOption()
    if @timeOut == IDLE_TIME then
    @selectedOption += 1
    @timeOut = 0
    @soundFX.play(false)
      if @selectedOption>@items.length-1 then
        @selectedOption = 0
      end
    end
  end

  def prevOption()
    if @timeOut == IDLE_TIME then
    @selectedOption -= 1
    @timeOut = 0
    @soundFX.play(false)
      if @selectedOption<0 then
        @selectedOption = @items.length-1
      end
    end
  end

  def draw(window)
      selectedColor = Color.new(255,0,0,100)
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
