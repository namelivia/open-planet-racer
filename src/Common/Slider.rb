class Slider

  attr_accessor :value

  def initialize(value)
    @value = value
    @maxValue = 100
    @changeRate = 3
  end

  def incValue()
    @value += @changeRate
    if @value > @maxValue then
      @value = @maxValue
    end
  end

  def decValue()
    @value -= @changeRate 
    if @value < 0 then
      @value = 0
    end
  end

  def draw(window,x,y,maxLength,height)
      selectedLineColor = Color.new(255,255,0,0)
      unselectedLineColor = Color.new(255,0,0,255)
      selectedSelectorColor = Color.new(255,255,0,0)     
      unselectedSelectorColor = Color.new(255,150,150,0)     
 
      #line
      window.draw_quad(x,y+(height/2)-(height/16),selectedLineColor,
		       x+maxLength,y+(height/2)-(height/16),selectedLineColor,
                       x,y+(height/2)+(height/16),selectedLineColor,
                       x+maxLength,y+(height/2)+(height/16),selectedLineColor)
      
      #selector
      position = x+(@value/100)*maxLength
      window.draw_quad(position,y,unselectedLineColor,
		       position+(height/4),y,unselectedLineColor,
                       position,y+height,unselectedLineColor,
                       position+(height/4),y+height,unselectedLineColor)
  end

end
