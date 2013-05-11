require './Race/CarPart.rb'
require './Race/Afterburner.rb'
require './Race/SoundFX.rb'
require './Race/PowerBar.rb'

class Car

   attr_accessor :position
   attr_accessor :afterburner
   attr_accessor :destroyed
   attr_accessor :life

def initialize(window,space,initialPosition,direction)

  @direction = direction
  @maxSpeed = 3.0
  @maxSpeedBackwards = 1.2
  @maxTorque = 1000
  @afterburner = 1000
  @destroyed = false
  @finished = false
  @life = 9
  @accelerating = false
  @turning = false
  @afterburnerOn = false 
  @engineVolume = 0
  @engineSFX = SoundFX.new(window,"../media/sfx/engine.ogg")
  @engineSFX.play(true)
  @engineSFX.setVolume(0)
  @explosionSFX = SoundFX.new(window,"../media/sfx/explosion.ogg")
  @rocketSFX = SoundFX.new(window,"../media/sfx/rocket.ogg")
  @rocketSFX.play(true)
  @rocketSFX.setVolume(0)
  @chasis = create_chasis(window,space,initialPosition,@direction)
  @wheel = create_wheel(window,space,initialPosition,@direction)
  @bigWheel = create_bigWheel(window,space,initialPosition,@direction)
  image = *Image.load_tiles(window,"../media/gfx/afterburner.png",19,42,true)
  @afterburnerObject = Afterburner.new(image, @chasis.body)
  if direction then 
    @groove1  = CP::Constraint::GrooveJoint.new(@chasis.body,@wheel.body,CP::Vec2.new(50,40),CP::Vec2::ZERO,CP::Vec2::ZERO)
    space.add_constraint(@groove1)
    @groove2  = CP::Constraint::GrooveJoint.new(@chasis.body,@bigWheel.body,CP::Vec2.new(-50,40),CP::Vec2::ZERO,CP::Vec2::ZERO)
    space.add_constraint(@groove2)
    @spring1 = CP::Constraint::DampedSpring.new(@chasis.body,@wheel.body,
                                                  CP::Vec2.new(50, 40),
                                                  CP::Vec2::ZERO,0.1,1.1,0.1)
    space.add_constraint(@spring1)
    @spring2 = CP::Constraint::DampedSpring.new(@chasis.body,@bigWheel.body,
                                                  CP::Vec2.new( -50, 40.0),
                                                  CP::Vec2::ZERO,0.1,1.1,0.1)
    space.add_constraint(@spring2)
  else
    @groove1  = CP::Constraint::GrooveJoint.new(@chasis.body,@wheel.body,CP::Vec2.new(-50,40),CP::Vec2::ZERO,CP::Vec2::ZERO)
    space.add_constraint(@groove1)
    @groove2  = CP::Constraint::GrooveJoint.new(@chasis.body,@bigWheel.body,CP::Vec2.new(50,40),CP::Vec2::ZERO,CP::Vec2::ZERO)
    space.add_constraint(@groove2)
    @spring1 = CP::Constraint::DampedSpring.new(@chasis.body,@wheel.body,
                                                  CP::Vec2.new(-50, 40),
                                                  CP::Vec2::ZERO,0.1,1.1,0.1)
    space.add_constraint(@spring1)
    @spring2 = CP::Constraint::DampedSpring.new(@chasis.body,@bigWheel.body,
                                                  CP::Vec2.new( 50, 40.0),
                                                  CP::Vec2::ZERO,0.1,1.1,0.1)
    space.add_constraint(@spring2)
  end
  @motor = CP::Constraint::SimpleMotor.new(@chasis.body, @bigWheel.body,0)
  space.add_constraint(@motor)
end

def draw(window,scroll_x,scroll_y)
    if not @destroyed then
      drawSuspension(window,scroll_x,scroll_y,@wheel.body.p.x,@wheel.body.p.y,@chasis.body.p.x,@chasis.body.p.y)
      drawSuspension(window,scroll_x,scroll_y,@bigWheel.body.p.x,@bigWheel.body.p.y,@chasis.body.p.x,@chasis.body.p.y)
   end
    if @afterburnerOn then
      @afterburnerObject.draw(scroll_x,scroll_y)
    end
    @chasis.draw(scroll_x,scroll_y,@direction)
    @wheel.draw(scroll_x,scroll_y,@direction)
    @bigWheel.draw(scroll_x,scroll_y,@direction)
    @afterburnerOn = false
end

def pause(pause)
 if pause then
  @engineSFX.pause()
  @rocketSFX.pause()
 else
  @engineSFX.resume()
  @rocketSFX.resume()
 end
end

def drawSuspension(window,scroll_x,scroll_y,point1X,point1Y,point2X,point2Y)
    color = Color.new(255,100,100,100)
    thickness = 6
    vX = point2X-point1X
    vY = point2Y-point1Y
    pX = -vY
    pY = vX
    length = Math.sqrt(pX*pX+pY*pY)
    nX = pX/length;
    nY = pY/length;
    p1x = point1X+nX*thickness/2-scroll_x
    p1y = point1Y+nY*thickness/2-scroll_y
    p2x = point1X-nX*thickness/2-scroll_x
    p2y = point1Y-nY*thickness/2-scroll_y
    p3x = point2X+nX*thickness/2-scroll_x
    p3y = point2Y+nY*thickness/2-scroll_y
    p4x = point2X-nX*thickness/2-scroll_x
    p4y = point2Y-nY*thickness/2-scroll_y
    window.draw_quad(p1x,p1y,color,p2x,p2y,color,p3x,p3y,color,p4x,p4y,color)
end

def mute()
  @engineSFX.pause()
  @rocketSFX.pause()
end

def accelerate(direction)
 @accelerating = true
 if @direction then
  if direction then
    if @motor.rate>-@maxSpeed then
      @motor.rate -= 0.1
    end
  else
    if @motor.rate<@maxSpeedBackwards then
      @motor.rate += 0.1
    end
  end
  else
  if direction then
    if @motor.rate<@maxSpeed then
      @motor.rate += 0.1
    end
  else
    if @motor.rate>-@maxSpeedBackwards then
      @motor.rate -= 0.1
    end
  end
 end
end

def turn(direction)
  @turning = true
  if direction then
    if @chasis.body.t > -@maxTorque then
      @chasis.body.t -=50
    end
  else
    if @chasis.body.t < @maxTorque then
      @chasis.body.t +=50
    end
  end
end

def FireAfterburner()
  if  @afterburner > 0 then
    @chasis.body.apply_impulse(CP::Vec2.new(Math::cos(@chasis.body.a),Math::sin(@chasis.body.a))*5,CP::Vec2::ZERO)
    @afterburner -=5
    @afterburnerOn = true
    @afterburnerObject.update()
    @rocketSFX.setVolume(1)
  end
end


def update(window)
  @engineVolume = @motor.rate/@maxSpeed
  @engineSFX.setVolume(@engineVolume.abs)
  
  if not @accelerating then
    if @motor.rate > 0 then
      @motor.rate -= 0.01
    else 
      @motor.rate += 0.01
    end
  end
  if not @turning then
    @chasis.body.t = 0
  end
  if not @afterburnerOn then
    @rocketSFX.setVolume(0)
  end
  
  @accelerating = false
  @turning = false
  @position = @chasis.body.p
end

def create_chasis(window,space,initialPosition,direction)
      if direction then
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
       chasis_image = Image.new(window,"../media/gfx/car.png",true)
       else
       chasis_vertices = [
                    CP::Vec2.new(0,-22),
                    CP::Vec2.new(-12, -18),
                    CP::Vec2.new(-21, -9),
                    CP::Vec2.new(-21, 23),
                    CP::Vec2.new(13, 23),
                    CP::Vec2.new(20, 18),
                    CP::Vec2.new(30, 0),
                    CP::Vec2.new(31, -15),
                    CP::Vec2.new(25, -21),
                    CP::Vec2.new(22, -22)]
       chasis_image = Image.new(window,"../media/gfx/RivalCar.png",true)
       end
       body = CP::Body.new(1, CP::moment_for_poly(10.0, chasis_vertices, CP::Vec2.new(0, 0)))
       body.p = initialPosition
       shape = CP::Shape::Poly.new(body, chasis_vertices, CP::Vec2.new(0, 0))
       shape.e = 0.5
       shape.u = 0.4
       shape.collision_type = :chasis
       chasis = CarPart.new(chasis_image, body)
       space.add_body(body)
       space.add_shape(shape)
       return chasis
  end
  def destroy(space)
      space.remove_constraint(@groove1)
      space.remove_constraint(@groove2)
      space.remove_constraint(@joint1)
      space.remove_constraint(@joint2)
      space.remove_constraint(@spring1)
      space.remove_constraint(@spring2)
      space.remove_constraint(@motor)
      @explosionSFX.play(false)
      @destroyed = true
  end

  def create_wheel(window,space,initialPosition,direction)
       wheel_image = Image.new(window,"../media/gfx/wheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(2.0,0.0,16,CP::Vec2.new(0, 0)))
       if direction then
         body.p = initialPosition + CP::Vec2.new(50,40)
       else
         body.p = initialPosition + CP::Vec2.new(-50,40)
       end
       shape = CP::Shape::Circle.new(body,16, CP::Vec2.new(0, 0))
       shape.e = 0.4
       shape.u = 1
       shape.collision_type = :wheel
       wheel = CarPart.new(wheel_image, body)
       space.add_body(body)
       space.add_shape(shape)
       return wheel
  end
  def finish()
      @finished = true
  end

  def create_bigWheel(window,space,initialPosition,direction)
       bigWheel_image = Image.new(window,"../media/gfx/bigWheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(3.0,0.0,25,CP::Vec2.new(0, 0)))
       if direction then 
         body.p = initialPosition + CP::Vec2.new(-50,40)
       else
         body.p = initialPosition + CP::Vec2.new(50,40)
       end
       shape = CP::Shape::Circle.new(body,25, CP::Vec2.new(0, 0))
       shape.e = 0.4
       shape.u = 1
       shape.collision_type = :bigWheel
       bigWheel = CarPart.new(bigWheel_image, body)
       space.add_body(body)
       space.add_shape(shape)
       return bigWheel
  end
end
