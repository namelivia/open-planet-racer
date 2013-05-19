class SoundFX

def initialize(window,path,optionsVolume)
      @sound = Gosu::Sample.new(window,path)
      @optionsVolume = optionsVolume
end
def play(looping)
    @playing = @sound.play(@optionsVolume,1,looping)
end
def stop()
  @playing.stop()
end
def setVolume(volume)
  @playing.volume = volume*@optionsVolume
end

def pause()
  @playing.pause()
end

def resume()
  @playing.resume()
end

end

