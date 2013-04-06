class PowerBar

   def initialize(window,x,y,afterburner)
       @background = Image.new(window,"../media/gfx/PowerBar.png",true)  
       @cell = Image.new(window,"../media/gfx/PowerCell.png",true)
       @x = x
       @y = y
       @maxAfterburner = afterburner
   end

   def draw(afterburner)
       @background.draw(@x,@y,0)
       (0..(afterburner*148)/@maxAfterburner-1).each do |i|
         @cell.draw(@x+i+1,@y+1,0)
       end
   end

end
