class Minimap

   def initialize(window)
       @background = Image.new(window,'../media/gfx/minimap.png')
       @arrow = Image.new(window,'../media/gfx/arrow.png')
       @point = Image.new(window,'../media/gfx/point.png')
       @arrowOffX = 50
       @arrowOffY = -10
       @finished = false
       @rArrowOffX = 50
       @rArrowOffY = -10
       @rFinished = false
   end

   def draw(x,y)
       @background.draw(x,y,0)
       if not @finished then
          @arrow.draw_rot(x+50+@arrowOffX,y+@arrowOffY,0,0)
       else
          @point.draw_rot(x+50,y+110,0,0)
       end
       if not @rFinished then
          @arrow.draw_rot(x+50-@rArrowOffX,y+@rArrowOffY,0,0)
       else
          @point.draw_rot(x+50,y+110,0,0)
       end
   end

   def update(percent,rival)
      if percent < 0 then
        percent = 0
      end
      if percent > 180 then
        @finished = true
      end

      angle = percent * Math::PI / 180
      @arrowOffX = Math.sin(angle)*60
      @arrowOffY = 50-(Math.cos(angle)*60)
      
      if rival < 0 then
        rival = 0
      end
      if rival > 180 then
        @rFinished = true
      end

      rAngle = rival * Math::PI / 180
      @rArrowOffX = Math.sin(rAngle)*60
      @rArrowOffY = 50-(Math.cos(rAngle)*60)
   end
end
