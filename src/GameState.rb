#0 - Intro
#1 - MainMenu
#2 - Credits
#3 - Options
#4 - Race

class GameState
   attr_accessor :stage
   def initialize()
       @stage = 0
   end
end
