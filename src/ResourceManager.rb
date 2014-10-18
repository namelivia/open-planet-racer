class ResourceManager

	attr_accessor :font
	attr_accessor :cursor_sound
	attr_accessor :cursor_select
	attr_accessor :cursor_back
	attr_accessor :title_image
	attr_accessor :finish
	attr_accessor :namelivia
	attr_accessor :music
	attr_accessor :rival_portraits
	attr_accessor :exploding_sound
	attr_accessor :engine_sound
	attr_accessor :rocket_sound
	attr_accessor :crash_sound
	attr_accessor :front_wheel_sound
	attr_accessor :back_wheel_sound

	def initialize(window,font_size,fx_volume,music_volume)
		@font = Gosu::Font.new(window,"../media/fonts/press-start-2p.ttf",font_size)
		@cursor_sound = SoundFX.new(window,"../media/sfx/cursorMove.ogg",fx_volume)
		@cursor_select = SoundFX.new(window,"../media/sfx/accept.ogg",fx_volume)
		@cursor_back = SoundFX.new(window,"../media/sfx/back.ogg",fx_volume)
		@title_image = Image.new(window,"../media/gfx/title.png",true)
		@namelivia = Image.new(window,"../media/gfx/namelivia.png",true)
    @finish = SoundFX.new(window,"../media/sfx/finish.ogg",fx_volume)
		@rival_portraits = [
			Image.new(window,'../media/gfx/alienPortrait.png',true),
			Image.new(window,'../media/gfx/alienPortrait2.png',true),
		]
		@music = [
      #"Ambient Electronic by MaximusPryme274"
      Gosu::Song.new(window, "../media/music/song2.ogg"),
      #"Spoil & Cut (Electronic Ambient) by Matthew Azega"
      Gosu::Song.new(window, "../media/music/song3.ogg"),
      #"Ambient Seven by brockatkinson"
      Gosu::Song.new(window, "../media/music/song4.ogg"),
      #"Ambient Work #6 by Intek systems"
      Gosu::Song.new(window, "../media/music/song5.ogg"),
      #"Ambient Test 2 by VALN8R"
      Gosu::Song.new(window, "../media/music/song6.ogg"),
      #"THNS by Paskine"
      Gosu::Song.new(window, "../media/music/song7.ogg"),
      #"Space theme by Alexandr Zhelanov"
      Gosu::Song.new(window, "../media/music/song8.ogg"),
		]
		@music.map{ |music| music.volume = music_volume }
		@engine_sound = SoundFX.new(window,"../media/sfx/engine.ogg",fx_volume)
		@exploding_sound = SoundFX.new(window,"../media/sfx/explosion.ogg",fx_volume)
		@rocket_sound = SoundFX.new(window,"../media/sfx/rocket.ogg",fx_volume)
		@crash_sound = SoundFX.new(window,"../media/sfx/crash.ogg",fx_volume)
		@front_wheel_sound = SoundFX.new(window,"../media/sfx/stomp1.ogg",fx_volume)
		@back_wheel_sound = SoundFX.new(window,"../media/sfx/stomp2.ogg",fx_volume)
	end
end
