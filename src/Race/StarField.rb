class StarField


   def initialize(screen_width,screen_height)
     @starCount = Array.new(100) { Array.new(4) }
     @starCount.each do |star|
       star[0] = rand(screen_width)
       star[1] = rand(screen_height)
       star[2] = rand(3)+10
       star[3] = rand(40)+215
     end 
   end

   def draw(window,scroll_x,scroll_y)
       @starCount.each do |star|
         if star[3]%2 == 0
	    starColor = Color.new(255,star[3],255,255)
         else
	    starColor = Color.new(255,255,255,star[3])
         end
         window.draw_line((star[0]-scroll_x/star[2])%SCREEN_WIDTH,(star[1]-scroll_y/star[2])%SCREEN_HEIGHT,starColor,(star[0]-scroll_x/star[2])%SCREEN_WIDTH+1,(star[1]-scroll_y/star[2])%SCREEN_HEIGHT,starColor)
       end
   end

   def update
   end

end
