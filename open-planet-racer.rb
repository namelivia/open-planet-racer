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
    @music = Music.new(self,rand(6))
    
    @moon_sprite = Image.new(self,"moon.png",true)
    @stars_image = Image.new(self,"stars.png",true)
    @dt = (1.0/60.0)

    @scroll_x = @scroll_y = 0
    @scroll_2x = @scroll_2y = 0

    @time = 0
    @sub_time = 0

    floorColor = Color.new(255,rand(155)+100,rand(155)+100,rand(155)+100)
    @level = Level.new(self,100,200,floorColor)
    
    initialPosition = CP::Vec2.new(300,200)
    @car = Car.new(self,initialPosition)
 
    @finished = false
    @font = Gosu::Font.new(self, "Arial", 18)
    @noticeFont = Gosu::Font.new(self,"Arial",60)
    @initialTime = Time.now
  end

  def update

    SUBSTEPS.times do
      @space.step(@dt)
    end

    if not @finished and not @car.destroyed then
       @currentTime = Time.now - @initialTime
    end
    @car.update(self)
    if not @finished then
      @scroll_x = @car.position.x-SCREEN_WIDTH/2
      @scroll_y = @car.position.y-SCREEN_HEIGHT/2
    end
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
    @level.draw(self,@scroll_x,@scroll_y,SCREEN_HEIGHT,color3)
    @car.draw(self,@scroll_x,@scroll_y)

    @font.draw("Afterburner: <c=ffff00>#{@car.afterburner}</c>", 10, 10, 1.0, 1.0, 1.0)
    @font.draw("Time: <c=ffff00>#{@currentTime}</c>",10,22,1.0,1.0,1.0)
    @font.draw("Song: <c=ffff00>#{@music.title}</c>",10,34,1.0,1.0,1.0)
    @font.draw("Life: <c=ffff00>#{@car.life}</c>",10,45,1.0,1.0,1.0)

    if @car.destroyed then
      @noticeFont.draw("Destroyed!",SCREEN_WIDTH/2-100,SCREEN_HEIGHT/2,1.0,1.0,1.0)
    end
    if @car.position.x < 0 and not @car.destroyed then
       @car.destroy(self)
    end 
    if @finished then
      @noticeFont.draw("Finished!",SCREEN_WIDTH/2-100,SCREEN_HEIGHT/2,1.0,1.0,1.0)
    end

    if @car.position.x > @level.levelLength and not @finished then
      @finished = true
      @finishTime = @currentTime
    end
 
  end
end

class Level

  attr_accessor :levelLength
  
def initialize(window,length,randomness,floorColor)
    @floorColor = floorColor
    @levelLength = (length+10)*200
    @window = window
    @heights = length.times.map{rand(randomness)-50}
    @heights = [0,0,0,0,0,0,0].push(*@heights).push(*[0,0,0,0,0,0,0])

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
        @shape.e = 0
        @shape.u = 1
        @window.space.add_static_shape(@shape)
        previous = previous-altura
    end
  end

  def draw(window,scroll_x,scroll_y,screen_height,color)
    previous = 400
    @heights.each_with_index do |altura,index|
      window.draw_quad(200*index-scroll_x,2000-scroll_y,@floorColor,200*index-scroll_x,previous-scroll_y,@floorColor,200*index+200-scroll_x,previous-altura-scroll_y,@floorColor,200*index+200-scroll_x,2000-scroll_y,@floorColor)
      previous = previous-altura
    end

    color2 = Color.new(255,255,10,10)
    window.draw_quad(@levelLength-scroll_x,previous-scroll_y,color2,@levelLength-scroll_x,previous+100-scroll_y,color2,@levelLength+20-scroll_x,previous-scroll_y,color2,@levelLength+20-scroll_x,previous+100-scroll_y,color2)
  end

end;

class Car

   attr_accessor :position
   attr_accessor :afterburner
   attr_accessor :destroyed
   attr_accessor :life

def initialize(window,initialPosition)
 
  @maxSpeed = -3.0
  @maxSpeedBackwards = 1.2
  @maxTorque = 1000
  @afterburner = 1000  
  @destroyed = false
  @life = 5000

  @chasis = create_chasis(window,initialPosition)
  @wheel = create_wheel(window,initialPosition)
  @bigWheel = create_bigWheel(window,initialPosition)
  @joint1  = CP::Constraint::PinJoint.new(@chasis.body,@wheel.body,CP::Vec2::ZERO,CP::Vec2::ZERO)
  window.space.add_constraint(@joint1)
  @joint2  = CP::Constraint::PinJoint.new(@chasis.body,@bigWheel.body,CP::Vec2::ZERO,CP::Vec2::ZERO)
  window.space.add_constraint(@joint2)
  @spring1 = CP::Constraint::DampedSpring.new(@chasis.body,@wheel.body,
                                                  CP::Vec2.new(5.0, 5.0),
                                                  CP::Vec2::ZERO,10.0,400.0,1.5)
  window.space.add_constraint(@spring1)    
  @spring2 = CP::Constraint::DampedSpring.new(@chasis.body,@bigWheel.body,
                                                  CP::Vec2.new( -5.0, 5.0),
                                                  CP::Vec2::ZERO,10.0,400.0,1.5)
  window.space.add_constraint(@spring2)
  @motor = CP::Constraint::SimpleMotor.new(@chasis.body, @bigWheel.body,0)
  window.space.add_constraint(@motor)
end

def draw(window,scroll_x,scroll_y)
    @chasis.draw(scroll_x,scroll_y)
    @wheel.draw(scroll_x,scroll_y)
    @bigWheel.draw(scroll_x,scroll_y)
    if not @destroyed then
    color = Color.new(255,100,100,100)
    window.draw_line(@wheel.body.p.x-scroll_x, @wheel.body.p.y-scroll_y, color, @chasis.body.p.x-scroll_x, @chasis.body.p.y-scroll_y, color)
    window.draw_line(@bigWheel.body.p.x-scroll_x, @bigWheel.body.p.y-scroll_y, color, @chasis.body.p.x-scroll_x, @chasis.body.p.y-scroll_y, color)
   end
end

def update(window)
if not @destroyed then
  if window.button_down? Gosu::Button::KbUp and @motor.rate>@maxSpeed then 
     @motor.rate -= 0.1
  else
    if window.button_down? Gosu::Button::KbDown and @motor.rate<@maxSpeedBackwards then
       @motor.rate += 0.1
    else
      if @motor.rate > 0 then
         @motor.rate -= 0.01
      else @motor.rate += 0.01 
      end
    end
  end

  if window.button_down? Gosu::Button::KbLeft and @chasis.body.t > -@maxTorque then
    @chasis.body.t -=50
  else
    if window.button_down? Gosu::Button::KbRight and @chasis.body.t < @maxTorque then
      @chasis.body.t +=50
    else
      @chasis.body.t = 0
    end
  end
 
  if window.button_down? Gosu::Button::KbSpace and @afterburner > 0 then
     @chasis.body.v = @chasis.body.v*1.01
     @afterburner -=5
  end
end
  
  if @life <= 0 then
   destroy(window)
  end
  @position = @chasis.body.p
end


  def create_chasis(window,initialPosition)
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
       chasis_image = Image.new(window,"car.png",true)
       body = CP::Body.new(1, CP::moment_for_poly(10.0, chasis_vertices, CP::Vec2.new(0, 0)))
       body.p = initialPosition
       shape = CP::Shape::Poly.new(body, chasis_vertices, CP::Vec2.new(0, 0))
       shape.e = 0.2
       shape.u = 0.1
       chasis = CarPart.new(chasis_image, body)
       window.space.add_body(body)
       window.space.add_shape(shape)
       return chasis
  end

  def destroy(window)
      window.space.remove_constraint(@joint1)
      window.space.remove_constraint(@joint2)
      window.space.remove_constraint(@spring1)
      window.space.remove_constraint(@spring2)
      window.space.remove_constraint(@motor)
      @destroyed = true
  end

  def create_wheel(window,initialPosition)
       wheel_image = Image.new(window,"wheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(2.0,0.0,16,CP::Vec2.new(0, 0)))
       body.p = initialPosition + CP::Vec2.new(50,40)
       shape = CP::Shape::Circle.new(body,16, CP::Vec2.new(0, 0))
       shape.e = 0.4
       shape.u = 1
       wheel = CarPart.new(wheel_image, body)
       window.space.add_body(body)
       window.space.add_shape(shape)
       return wheel
  end

  def create_bigWheel(window,initialPosition)
       bigWheel_image = Image.new(window,"bigWheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(3.0,0.0,25,CP::Vec2.new(0, 0)))
       body.p = initialPosition + CP::Vec2.new(-50,40)
       shape = CP::Shape::Circle.new(body,25, CP::Vec2.new(0, 0))
       shape.e = 0.4
       shape.u = 1
       bigWheel = CarPart.new(bigWheel_image, body)
       window.space.add_body(body)
       window.space.add_shape(shape)
       return bigWheel
  end

end

class Music
 attr_accessor :title
 
def initialize(window,track)
   case track
    when 0 then 
      @music = Gosu::Song.new(window, "song.ogg")
      @title = "Space by MattIceMan"
    when 1 then 
      @music = Gosu::Song.new(window, "song2.ogg")
      @title = "Ambient Electronic by MaximusPryme274"
    when 2 then 
      @music = Gosu::Song.new(window, "song3.ogg")
      @title = "Spoil & Cut (Electronic Ambient) by Matthew Azega"
    when 3 then 
      @music = Gosu::Song.new(window, "song4.ogg")
      @title = "Ambient Seven by brockatkinson"
    when 4 then 
      @music = Gosu::Song.new(window, "song5.ogg")
      @title = "Ambient Work #6 by Intek systems"
    when 5 then 
      @music = Gosu::Song.new(window, "song6.ogg")
      @title = "Ambient Test 2 by VALN8R"
    when 6 then 
      @music = Gosu::Song.new(window, "song7.ogg")
      @title = "THNS by Paskine"
    end
    @music.play
 end
end

class CarPart

   attr_accessor :body

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
