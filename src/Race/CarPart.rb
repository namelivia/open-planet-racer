class CarPart

   attr_accessor :body

   def initialize(image, body)
       @image = image
       @body = body
   end

   def draw(scroll_x,scroll_y,direction)
       if direction then
         @image.draw_rot(@body.p.x-scroll_x, @body.p.y-scroll_y,0, @body.a.radians_to_gosu)
       else
         @image.draw_rot(@body.p.x-scroll_x, @body.p.y-scroll_y,0, @body.a.radians_to_gosu,0.5,0.5,1,-1)
       end
   end

   def update
   end

end
