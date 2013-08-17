class TextItem

  attr_accessor :text
  attr_accessor :value

  def initialize(text,order,value)
    @text = text.to_s
    @order = order
    @value = value
  end

  def draw(window,x,y,font,maxLength,selectedOption)
      if selectedOption+1 == @order then 
        color = Color.new(255,0,0,100)
      else
        color = Color.new(255,0,0,255)
      end
        window.draw_quad(x,y+(@order*font.height),color,
                         x+maxLength*font.height,y+(@order*font.height),color,
                         x,y+((@order+1)*font.height),color,
                         x+maxLength*font.height,y+((@order+1)*font.height),color) 
      if selectedOption+1 == @order then
        if @value == -1 then
          font.draw("<c=ffff00>#{@text}</c>",x,y+(@order*font.height), 1.0, 1.0, 1.0)
        else
          font.draw("<c=ffff00>#{@text}: #{@value}</c>",x,y+(@order*font.height), 1.0, 1.0, 1.0)
        end
      else
        if @value == -1 then
          font.draw(@text,x,y+(@order*font.height), 1.0, 1.0, 1.0)
        else
          font.draw("#{@text}: #{@value}",x,y+(@order*font.height), 1.0, 1.0, 1.0)
        end
      end
  end
end
