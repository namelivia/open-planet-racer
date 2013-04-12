class CollisionHandler
 def initialize(window,car)
   @crashSFX = SoundFX.new(window,"../media/sfx/crash.ogg")
   @car = car
 end
 def begin(a, b, arbiter)
  @crashSFX.play(false)
  @car.life -=1
  true
 end
 
 def pre_solve(a, b)
  true
 end
 
 def post_solve(arbiter)
  true
 end
end
