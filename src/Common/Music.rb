class Music
 attr_accessor :title

def initialize(window,track,optionsVolume)
   @optionsVolume = optionsVolume
   case track
    when 1 then
      @music = Gosu::Song.new(window, "../media/music/song2.ogg")
      @title = "Ambient Electronic by MaximusPryme274"
    when 2 then
      @music = Gosu::Song.new(window, "../media/music/song3.ogg")
      @title = "Spoil & Cut (Electronic Ambient) by Matthew Azega"
    when 3 then
      @music = Gosu::Song.new(window, "../media/music/song4.ogg")
      @title = "Ambient Seven by brockatkinson"
    when 4 then
      @music = Gosu::Song.new(window, "../media/music/song5.ogg")
      @title = "Ambient Work #6 by Intek systems"
    when 5 then
      @music = Gosu::Song.new(window, "../media/music/song6.ogg")
      @title = "Ambient Test 2 by VALN8R"
    when 6 then
      @music = Gosu::Song.new(window, "../media/music/song7.ogg")
      @title = "THNS by Paskine"
    when 7 then
      @music = Gosu::Song.new(window, "../media/music/song8.ogg")
      @title = "Space theme by Alexandr Zhelanov"
    end
    @music.play
    @music.volume = optionsVolume
 end

 def stop()
   @music.stop()
 end

end

