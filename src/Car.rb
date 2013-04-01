require './CarPart.rb'
<<<<<<< HEAD
require './Afterburner.rb'
=======
>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff

class Car

   attr_accessor :position
   attr_accessor :afterburner
   attr_accessor :destroyed
   attr_accessor :life

def initialize(window,space,initialPosition)

  @maxSpeed = -3.0
  @maxSpeedBackwards = 1.2
  @maxTorque = 1000
  @afterburner = 1000
  @destroyed = false
  @life = 5000
<<<<<<< HEAD
  @afterburnerOn = false; 
=======
>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff

  @chasis = create_chasis(window,space,initialPosition)
  @wheel = create_wheel(window,space,initialPosition)
  @bigWheel = create_bigWheel(window,space,initialPosition)
<<<<<<< HEAD
  afterburner_image = Image.new(window,"../media/gfx/afterburner.png",true)
  @afterburnerObject = Afterburner.new(afterburner_image, @chasis.body)
  @groove1  = CP::Constraint::GrooveJoint.new(@chasis.body,@wheel.body,CP::Vec2.new(50,40),CP::Vec2::ZERO,CP::Vec2::ZERO)
  space.add_constraint(@groove1)
  @groove2  = CP::Constraint::GrooveJoint.new(@chasis.body,@bigWheel.body,CP::Vec2.new(-50,40),CP::Vec2::ZERO,CP::Vec2::ZERO)
  space.add_constraint(@groove2)
  @spring1 = CP::Constraint::DampedSpring.new(@chasis.body,@wheel.body,
                                                  CP::Vec2.new(50, 40),
                                                  CP::Vec2::ZERO,20.0,4.0,10.5)
  space.add_constraint(@spring1)
  @spring2 = CP::Constraint::DampedSpring.new(@chasis.body,@bigWheel.body,
                                                  CP::Vec2.new( -50, 40.0),
                                                  CP::Vec2::ZERO,20.0,4.0,10.5)
=======
  @joint1  = CP::Constraint::PinJoint.new(@chasis.body,@wheel.body,CP::Vec2::ZERO,CP::Vec2::ZERO)
  space.add_constraint(@joint1)
  @joint2  = CP::Constraint::PinJoint.new(@chasis.body,@bigWheel.body,CP::Vec2::ZERO,CP::Vec2::ZERO)
  space.add_constraint(@joint2)
  @spring1 = CP::Constraint::DampedSpring.new(@chasis.body,@wheel.body,
                                                  CP::Vec2.new(5.0, 5.0),
                                                  CP::Vec2::ZERO,10.0,400.0,1.5)
  space.add_constraint(@spring1)
  @spring2 = CP::Constraint::DampedSpring.new(@chasis.body,@bigWheel.body,
                                                  CP::Vec2.new( -5.0, 5.0),
                                                  CP::Vec2::ZERO,10.0,400.0,1.5)
>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff
  space.add_constraint(@spring2)
  @motor = CP::Constraint::SimpleMotor.new(@chasis.body, @bigWheel.body,0)
  space.add_constraint(@motor)
end

def draw(window,scroll_x,scroll_y)
    @chasis.draw(scroll_x,scroll_y)
    @wheel.draw(scroll_x,scroll_y)
    @bigWheel.draw(scroll_x,scroll_y)
<<<<<<< HEAD
    if @afterburnerOn then
      @afterburnerObject.draw(scroll_x,scroll_y)
    end
=======
>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff
    if not @destroyed then
    color = Color.new(255,100,100,100)
    window.draw_line(@wheel.body.p.x-scroll_x, @wheel.body.p.y-scroll_y, color, @chasis.body.p.x-scroll_x,
@chasis.body.p.y-scroll_y, color)
    window.draw_line(@bigWheel.body.p.x-scroll_x, @bigWheel.body.p.y-scroll_y, color, @chasis.body.p.x-scroll_x,
@chasis.body.p.y-scroll_y, color)
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
<<<<<<< HEAD
     @chasis.body.apply_impulse(CP::Vec2.new(Math::cos(@chasis.body.a),Math::sin(@chasis.body.a))*5,CP::Vec2::ZERO) 
     @afterburner -=5
     @afterburnerOn = true;
  else
     @afterburnerOn = false;
=======
     @chasis.body.v = @chasis.body.v*1.01
     @afterburner -=5
>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff
  end
end

  if @life <= 0 then
   destroy(window)
  end
  @position = @chasis.body.p
end


  def create_chasis(window,space,initialPosition)
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
       body = CP::Body.new(1, CP::moment_for_poly(10.0, chasis_vertices, CP::Vec2.new(0, 0)))
       body.p = initialPosition
       shape = CP::Shape::Poly.new(body, chasis_vertices, CP::Vec2.new(0, 0))
       shape.e = 0.2
       shape.u = 0.1
       chasis = CarPart.new(chasis_image, body)
       space.add_body(body)
       space.add_shape(shape)
       return chasis
  end

  def destroy(space)
<<<<<<< HEAD
      space.remove_constraint(@groove1)
      space.remove_constraint(@groove2)
=======
      space.remove_constraint(@joint1)
      space.remove_constraint(@joint2)
>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff
      space.remove_constraint(@spring1)
      space.remove_constraint(@spring2)
      space.remove_constraint(@motor)
      @destroyed = true
  end

  def create_wheel(window,space,initialPosition)
       wheel_image = Image.new(window,"../media/gfx/wheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(2.0,0.0,16,CP::Vec2.new(0, 0)))
       body.p = initialPosition + CP::Vec2.new(50,40)
       shape = CP::Shape::Circle.new(body,16, CP::Vec2.new(0, 0))
       shape.e = 0.4
       shape.u = 1
       wheel = CarPart.new(wheel_image, body)
       space.add_body(body)
       space.add_shape(shape)
       return wheel
  end

  def create_bigWheel(window,space,initialPosition)
       bigWheel_image = Image.new(window,"../media/gfx/bigWheel.png",true)
       body = CP::Body.new(1, CP::moment_for_circle(3.0,0.0,25,CP::Vec2.new(0, 0)))
       body.p = initialPosition + CP::Vec2.new(-50,40)
       shape = CP::Shape::Circle.new(body,25, CP::Vec2.new(0, 0))
       shape.e = 0.4
       shape.u = 1
       bigWheel = CarPart.new(bigWheel_image, body)
       space.add_body(body)
       space.add_shape(shape)
       return bigWheel
  end
<<<<<<< HEAD
=======

>>>>>>> b9e1bbe6e11c139a1345c763a03f778833ddd3ff
end
