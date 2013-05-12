class SoundFX

def initialize(window,path)
      @sound = Gosu::Sample.new(window,path)
end
def play(looping)
    @playing = @sound.play(1.0,1,looping)
end
def stop()
  @playing.stop()
end
def setVolume(volume)
  @playing.volume = volume
end

def pause()
  @playing.pause()
end

def resume()
  @playing.resume()
end

end

