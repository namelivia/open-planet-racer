class CollisionHandler
 def initialize(window,car,type,optionsVolume)
   @type = type
   if @type == 0 then
     @sound = SoundFX.new(window,"../media/sfx/crash.ogg",optionsVolume)
     @car = car
   elsif @type == 1 then
     @sound = SoundFX.new(window,"../media/sfx/stomp1.ogg",optionsVolume)
   else
     @sound = SoundFX.new(window,"../media/sfx/stomp2.ogg",optionsVolume)
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
