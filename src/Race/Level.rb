require './Race/StarField.rb'

class Level

  attr_accessor :levelLength
  attr_accessor :finishHeight

def initialize(window,space,length,randomness,floorColor,skyColor)
    @floorColor = floorColor
    @skyColor = skyColor
    @levelLength = (length+10)*200
    @heights = length.times.map{rand(randomness)-50}
    @finishHeight = @heights[length-1]
    @heights = [0,0,0,0,0,0,0].push(*@heights).push(*[0,0,0,0,0,0,0])

    @starField = StarField.new(window,SCREEN_WIDTH,SCREEN_HEIGHT,@levelLength,@finishHeight)

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
               CP::Vec2.new(-600,600),
               CP::Vec2.new(0, 600),
               CP::Vec2.new(0,400),
               CP::Vec2.new(-600,400)
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
    @finishHeight = previous
  end

  def draw(window,scroll_x,scroll_y,screen_height,color)
    #gradient background
        limit = 0
    size = 9
    color = Color.new(255,0,0,0)
    color3 = Color.new(255,200,200,200)

    while limit+size<SCREEN_HEIGHT+20 do

        window.draw_quad(0,limit,color,0,limit+size,color,SCREEN_WIDTH,limit+size,color,SCREEN_WIDTH,limit,color)
        if color.red < @skyColor.red then
          color.red += 1 
        end
        if color.blue < @skyColor.blue then
          color.blue += 1  
        end
        if color.green < @skyColor.green then
          color.green += 1  
        end
        limit += size
        size = size

    end

    @starField.draw(window,scroll_x,scroll_y) 
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
