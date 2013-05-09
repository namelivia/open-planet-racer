class Level

  attr_accessor :levelLength

def initialize(window,space,length,randomness,floorColor)
    @floorColor = floorColor
    @levelLength = (length+10)*200
    @heights = length.times.map{rand(randomness)-50}
    @heights = [0,0,0,0,0,0,0].push(*@heights).push(*[0,0,0,0,0,0,0])

    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(0,0)
    @body.v = CP::Vec2.new(0, 0)

    previous = 400

    #invisible wall

    @shape_verts = [
               CP::Vec2.new(-5,600),
               CP::Vec2.new(0, 600),
               CP::Vec2.new(0,-2000),
               CP::Vec2.new(-5,-2000)
                   ]
    @shape = CP::Shape::Poly.new(@body,@shape_verts,CP::Vec2.new(0,0))
    @shape.e = 0
    @shape.u = 1
    @shape.collision_type = :floor
    space.add_static_shape(@shape)

    #rival runway
    @shape_verts = [
               CP::Vec2.new(-200,600),
               CP::Vec2.new(0, 600),
               CP::Vec2.new(0,400),
               CP::Vec2.new(-200,400)
                   ]

    @shape = CP::Shape::Poly.new(@body,@shape_verts,CP::Vec2.new(0,0))
    @shape.e = 0
    @shape.u = 1
    @shape.collision_type = :floor
    space.add_static_shape(@shape)

    @heights.each_with_index do |altura,index|

        @shape_verts = [
                    CP::Vec2.new(200*index,600),
                    CP::Vec2.new(200*index+200, 600),
                    CP::Vec2.new(200*index+200,previous-altura),
                    CP::Vec2.new(200*index,previous)
                       ]

        @shape = CP::Shape::Poly.new(@body,@shape_verts,CP::Vec2.new(0,0))
        @shape.e = 0
        @shape.u = 1
        @shape.collision_type = :floor
        space.add_static_shape(@shape)
        previous = previous-altura
    end
  end

  def draw(window,scroll_x,scroll_y,screen_height,color)
      
    window.draw_quad(-500-scroll_x,800-scroll_y,@floorColor,-500-scroll_x,400-scroll_y,@floorColor,0-scroll_x,400-scroll_y,@floorColor,0-scroll_x,800-scroll_y,@floorColor)
    
previous = 400
    @heights.each_with_index do |altura,index|
      window.draw_quad(200*index-scroll_x,2000-scroll_y,@floorColor,200*index-scroll_x,previous-scroll_y,@floorColor,200*index+200-scroll_x,previous-altura-scroll_y,@floorColor,200*index+200-scroll_x,2000-scroll_y,@floorColor)
      previous = previous-altura
    end

    color2 = Color.new(255,255,10,10)
    window.draw_quad(@levelLength-scroll_x,previous-scroll_y,color2,@levelLength-scroll_x,previous+100-scroll_y,color2,@levelLength+20-scroll_x,previous-scroll_y,color2,@levelLength+20-scroll_x,previous+100-scroll_y,color2)
  end

end;
