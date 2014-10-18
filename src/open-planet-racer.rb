require 'rubygems'
require 'gosu'
require 'chipmunk'
require './Race/Race.rb'
require './Intro/Intro.rb'
require './SoundOptions.rb'
require './ResourceManager.rb'
require './MainMenu/MainMenu.rb'

include Gosu

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
IDLE_TIME = 30
FADE_SPEED = 8

class Game < Window

	def initialize
		super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
		self.caption = "Planet Racer"
		@sound_options = SoundOptions.new
		@resource_manager = ResourceManager.new(self,20,@sound_options.fx_volume,@sound_options.music_volume)
		@stage = 0
		@intro = Intro.new(self,@resource_manager)
		@fading = 255
	end

	def transition(current_stage)
		@stage = current_stage.finished
		current_stage = nil
		case @stage
		when -1
			exit!
		when 0
			@intro = Intro.new(self,@resource_manager)
		when 1
			@main_menu= MainMenu.new(self,@resource_manager,@sound_options)
		when 2
			@race = Race.new(self,@resource_manager)
		end
	end

	def update
		case @stage
		when 0
			if @intro.finished == 0 then
				if @fading > 0 then
					@fading -= FADE_SPEED
				else
					@intro.update(self)
				end
			else
				if @fading > 255 then
					transition(@intro)
				else
					@fading += FADE_SPEED
				end
			end
		when 1
			if @main_menu.finished == 0 then
				if @fading > 0 then
					@fading -= FADE_SPEED
				else
					@main_menu.update(self)
				end
			else
				if @fading > 255 then
					transition(@main_menu)
				else
					@fading += FADE_SPEED
				end
			end
		when 2
			if @race.finished == 0 then
				if @fading > 0 then
					@fading -= FADE_SPEED
				else
					@race.update(self)
				end
			else
				if @fading > 255 then
					transition(@race)
				else
					@fading += FADE_SPEED
				end
			end
		end
	end

	def draw
		case @stage
		when 0
			@intro.draw(self)
		when 1
			@main_menu.draw(self)
		when 2
			@race.draw(self)
		end
		fadecolor = Color.new(@fading,0,0,0)
		draw_quad(0,
							0,
							fadecolor,
							0,
							SCREEN_HEIGHT,
							fadecolor,
							SCREEN_WIDTH,
							0,
							fadecolor,
							SCREEN_WIDTH,
							SCREEN_HEIGHT,
							fadecolor,
							1)
	end

end

window = Game.new
window.show
exit!
