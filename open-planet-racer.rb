###########################################################################################################
# My very first ruby program, this is a 2D platform game test.						  #
# Requires rubygems and gosu.									          #
###########################################################################################################

require 'rubygems'
require 'gosu'
require 'chipmunk'
include Gosu

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
FULLSCREEN = false

###################################
#HELPERS
###################################

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

###########################################################################################################
# GAME CLASS												  #
###########################################################################################################

class Game < Window

  attr_accessor :space

  SUBSTEPS = 10


###########################################################################################################
# Initialization											  #
###########################################################################################################

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
    @blocks = []
    150.times do
      @blocks << Block.new(self)
    end

  end

###########################################################################################################
# Updates the game state									 	  #
###########################################################################################################

  def update

   # THE SUBSTEPS ENSURE THAT THE PHYSICS DOESNT MISS A STEP
    SUBSTEPS.times do
      @space.step(@dt)
    end

    @scroll_x -= 5 if button_down? Button::KbLeft
    @scroll_x += 5 if button_down? Button::KbRight
    @scroll_y -= 5 if button_down? Button::KbUp
    @scroll_y += 5 if button_down? Button::KbDown

  end

###########################################################################################################
# Draws all the things on the screen									  #
###########################################################################################################

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
    #stars
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
    @blocks.each do |b|
      b.draw(@scroll_x,@scroll_y)
    end

  end
end

###########################################################################################################
# LEVEL CLASS										          #
###########################################################################################################

class Level

###########################################################################################################
# Initialization											  #
###########################################################################################################

  def initialize(window,length)
    @color = Color.new(255,100,100,100)
    @window = window
    @alturas = length.times.map{rand(100)-50}

    @a = CP::Vec2.new(0,0)
    @b = CP::Vec2.new(SCREEN_WIDTH - (50 * 2), 0)

    # CHIPMUNK BODY
    @body = CP::Body.new_static()
    @body.p = CP::Vec2.new(0,0)
    @body.v = CP::Vec2.new(0, 0)

    previous = 400
    @alturas.each_with_index do |altura,index|

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

###########################################################################################################
# Draws character on screen										  #
###########################################################################################################

  def draw(scroll_x,scroll_y,screen_height,color)
    previous = 400
    @alturas.each_with_index do |altura,index|
      @window.draw_quad(200*index-scroll_x,600-scroll_y,color,200*index-scroll_x,previous-scroll_y,color,200*index+200-scroll_x,previous-altura-scroll_y,color,200*index+200-scroll_x,600-scroll_y,color)
      previous = previous-altura
    end
  end

end;

########################
#BOX
#######################
# These are the falling Blocks
class Block

  attr_reader :shape

  BOX_SIZE = 10

  def initialize(window)
    @window = window
    @color = Gosu::red

    @body = CP::Body.new(10, 100)
    @body.p = CP::Vec2.new(20 + rand(640 - (20 * 2)), rand(50))
    @body.v = CP::Vec2.new(0,0)
    @body.a = (3 * Math::PI / 2.5)

    @shape_verts = [
                    CP::Vec2.new(-BOX_SIZE, BOX_SIZE),
                    CP::Vec2.new(BOX_SIZE, BOX_SIZE),
                    CP::Vec2.new(BOX_SIZE, -BOX_SIZE),
                    CP::Vec2.new(-BOX_SIZE, -BOX_SIZE),
                   ]

    @shape = CP::Shape::Poly.new(@body,
                                 @shape_verts,
                                 CP::Vec2.new(0,0))

    @shape.e = 0
    @shape.u = 1

    # WE ADD THE THE BODY AND SHAPE TO THE SPACE WHICH THEY WILL LIVE IN
    @window.space.add_body(@body)
    @window.space.add_shape(@shape)
  end

  def update
  end

  def draw(scroll_x,scroll_y)
    top_left, top_right, bottom_left, bottom_right = self.rotate
    @window.draw_quad(top_left.x-scroll_x, top_left.y-scroll_y, @color,
                      top_right.x-scroll_x, top_right.y-scroll_y, @color,
                      bottom_left.x-scroll_x, bottom_left.y-scroll_y, @color,
                      bottom_right.x-scroll_x, bottom_right.y-scroll_y, @color,
                      1)
  end

  def rotate

    half_diagonal = Math.sqrt(2) * (BOX_SIZE)
    [-45, +45, -135, +135].collect do |angle|
       CP::Vec2.new(@body.p.x + Gosu::offset_x(@body.a.radians_to_gosu + angle,
                                               half_diagonal),

    @body.p.y + Gosu::offset_y(@body.a.radians_to_gosu + angle,
                                               half_diagonal))

    end
  end

end



###########################################################################################################
# Main initialization											  #
###########################################################################################################

window = Game.new
window.show
