class CollisionHandler
 def initialize(window,car,type)
   @type = type
   if @type == 0 then
     @sound = SoundFX.new(window,"../media/sfx/crash.ogg")
     @car = car
   elsif @type == 1 then
     @sound = SoundFX.new(window,"../media/sfx/stomp1.ogg")
   else
     @sound = SoundFX.new(window,"../media/sfx/stomp2.ogg")
   end
 end
 def begin(a, b, arbiter)
   true
 end
 
 def pre_solve(a, b)
   true
 end
 
 def post_solve(arbiter)
  if arbiter.impulse.x+arbiter.impulse.y > 20 then
    if @type == 0 then
      @sound.play(false)
      @car.life -=1
      true
    else
      @sound.play(false)
      true
    end
  else
    true
  end
 end
end
