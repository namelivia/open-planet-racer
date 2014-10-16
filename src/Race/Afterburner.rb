class Afterburner
   def initialize(image, body)
       @image = image
       @body = body
       @currentFrame = 0
       @counter = 0
   end
   def draw(scroll_x,scroll_y)
       @image[@currentFrame].draw_rot(@body.p.x-(63*Math::cos(@body.a))-scroll_x, @body.p.y-(63*Math::sin(@body.a))-scroll_y, 0, @body.a.radians_to_gosu)
   end
   def update()
       @counter += 1
       if @counter == 4
       @currentFrame = (@currentFrame+1)%3
       @counter = 0
       end
   end
end
