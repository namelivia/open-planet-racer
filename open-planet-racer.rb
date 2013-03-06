require 'rubygems'
require 'gosu'
require 'chipmunk'
require 'RMagick'

include Gosu

module ZOrder
   Background, Box = *0..1
end


SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
FULLSCREEN = false

class Numeric
  def gosu_to_radians
    (self - 90) * Math::PI / 180.0
  end
  
  def radians_to_gosu
    self * 180.0 / Math::PI + 90
  end
  
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

class Game < Window

  attr_accessor :space

  SUBSTEPS = 10

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Planet Racer"
    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0, 10)
    @moon_sprite = Image.new(self,"moon.png",true)
    @stars_image = Image.new(self,"stars.png",true)
    @dt = (1.0/60.0)


    @scroll_x = @scroll_y = 0
    @scroll_2x = @scroll_2y = 0

    @time = 0
    @sub_time = 0

    @level = Level.new(self,10)
    initialPosition = CP::Vec2.new(300,200)
    @chasis = create_chasis(initialPosition)
    @wheel = create_wheel(initialPosition)
    @bigWheel = create_bigWheel(initialPosition)
    @music = Gosu::Song.new(self, "song.ogg")
    @music.play
    print("======= OPEN PLANET RACER =======\n")
    print("Song Space by MattIceMan - https://soundcloud.com/matticeman/space\n")
  end

  def update

    SUBSTEPS.times do
      @space.step(@dt)
    end

    @chasis.update
    @wheel.update
    @scroll_x = @chasis.position.x-SCREEN_WIDTH/2
    @scroll_y = @chasis.position.y-SCREEN_HEIGHT/2

  end

  def draw

    limit = 0
    size = 9
    color = Color.new(255,0,0,0)
    color3 = Color.new(255,200,200,200)
    
    while limit+size<SCREEN_HEIGHT+20 do

    	self.draw_quad(0,limit,color,0,limit+size,color,SCREEN_WIDTH,limit+size,color,SCREEN_WIDTH,limit,color)
    	color.red +=1
    	color.blue +=1
	limit += size
        size = size

    end
    
    bg_width = @stars_image.width
    bg_height = @stars_image.height

    bg_tile_x = 0
    bg_tile_y = 0

    while bg_tile_y<SCREEN_HEIGHT do

         while bg_tile_x<SCREEN_WIDTH do
           @stars_image.draw(bg_tile_x-@scroll_x/10,bg_tile_y-@scroll_y/10,0)
           bg_tile_x = bg_tile_x+bg_width
         end

         bg_tile_y = bg_tile_y+bg_height
         bg_tile_x = 0

    end
    @moon_sprite.draw(500-@scroll_x/5,100-@scroll_y/5,0)    
    @level.draw(@scroll_x,@scroll_y,SCREEN_HEIGHT,color3)
    @chasis.draw(@scroll_x,@scroll_y)
    @wheel.draw(@scroll_x,@scroll_y)
    @bigWheel.draw(@scroll_x,@scroll_y)

  end

  def create_chasis(initialPosition)
      chasis_vertices = [
                    CP::Vec2.new(-22, -22),
                    CP::Vec2.new(-25, -21),
                    CP::Vec2.new(-31, -15),
                    CP::Vec2.new(-30, 0),
                    CP::Vec2.new(-20, 18),
                    CP::Vec2.new(-13, 23),
                    CP::Vec2.new(21, 23),
                    CP::Vec2.new(21, -9),
                    CP::Vec2.new(12, -18),
                    CP::Vec2.new(0,-22)]
       chasis_image = Image.new(self,"car.png",true)
       body = CP::Body.new(1, CP::moment_for_poly(40.0, chasis_vertices, CP::Vec2.new(0, 0))) # mass, moment of inertia
       body.p = initialPosition
       shape = CP::Shape::Poly.new(body, chasis_vertices, CP::Vec2.new(0, 0))
       shape.e = 0.2
       shape.u = 0.4
       chasis = Chasis.new(chasis_image, body)
       @space.add_body(body)
       @space.add_shape(shape)
       return chasis
  end

  def create_wheel(initialPosition)
       wheel_image = Image.new(self,"wheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(10.0,0.0,16,CP::Vec2.new(0, 0))) # mass, moment of inertia
       body.p = initialPosition + CP::Vec2.new(50,40)
       shape = CP::Shape::Circle.new(body,16, CP::Vec2.new(0, 0))
       shape.e = 0.9
       shape.u = 0.4
       wheel = Wheel.new(wheel_image, body)
       @space.add_body(body)
       @space.add_shape(shape)
       return wheel
  end

  def create_bigWheel(initialPosition)
       bigWheel_image = Image.new(self,"bigWheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(13.0,0.0,25,CP::Vec2.new(0, 0))) # mass, moment of inertia
       body.p = initialPosition + CP::Vec2.new(-30,40)
       shape = CP::Shape::Circle.new(body,25, CP::Vec2.new(0, 0))
       shape.e = 0.9
       shape.u = 0.4
       bigWheel = Wheel.new(bigWheel_image, body)
       @space.add_body(body)
       @space.add_shape(shape)
       return bigWheel
  end

end

class Level

  def initialize(window,length)
    @color = Color.new(255,100,100,100)
    @window = window
    @heights = length.times.map{rand(100)-50}

    @a = CP::Vec2.new(0,0)
    @b = CP::Vec2.new(SCREEN_WIDTH - (50 * 2), 0)

    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(0,0)
    @body.v = CP::Vec2.new(0, 0)

    previous = 400
    @heights.each_with_index do |altura,index|

        @shape_verts = [
                    CP::Vec2.new(200*index,600),
                    CP::Vec2.new(200*index+200, 600),
                    CP::Vec2.new(200*index+200,previous-altura),
                    CP::Vec2.new(200*index,previous)
                       ]

        @shape = CP::Shape::Poly.new(@body,@shape_verts,CP::Vec2.new(0,0))
        @shape.e = 0.7
        @shape.u = 0.5
        @window.space.add_static_shape(@shape)
        previous = previous-altura
    end
  end

  def draw(scroll_x,scroll_y,screen_height,color)
    previous = 400
    @heights.each_with_index do |altura,index|
      @window.draw_quad(200*index-scroll_x,2000-scroll_y,color,200*index-scroll_x,previous-scroll_y,color,200*index+200-scroll_x,previous-altura-scroll_y,color,200*index+200-scroll_x,2000-scroll_y,color)
      previous = previous-altura
    end
  end

end;

class Chasis

   attr_accessor :position

   def initialize(image, body)
       @image = image
       @body = body
   end

   def draw(scroll_x,scroll_y)
       @image.draw_rot(@body.p.x-scroll_x, @body.p.y-scroll_y, ZOrder::Box, @body.a.radians_to_gosu)
   end

   def update
       @position=@body.p
   end

end

class Wheel

   def initialize(image, body)
       @image = image
       @body = body
   end

   def draw(scroll_x,scroll_y)
       @image.draw_rot(@body.p.x-scroll_x, @body.p.y-scroll_y, ZOrder::Box, @body.a.radians_to_gosu)
   end

   def update
   end

end
window = Game.new
window.show
