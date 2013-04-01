class Afterburner
   def initialize(image, body)
       @image = image
       @body = body
   end
   def draw(scroll_x,scroll_y)
       @image.draw_rot(@body.p.x-60-scroll_x, @body.p.y-5-scroll_y, ZOrder::Box, @body.a.radians_to_gosu)
   end
end
