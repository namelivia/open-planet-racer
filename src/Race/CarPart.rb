class CarPart

   attr_accessor :body

   def initialize(image, body)
       @image = image
       @body = body
   end

   def draw(scroll_x,scroll_y)
       @image.draw_rot(@body.p.x-scroll_x, @body.p.y-scroll_y,0, @body.a.radians_to_gosu)
   end

   def update
   end

end
