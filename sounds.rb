class Sounds

  def initialize(settings)
    @settings = settings
    @music = Gosu::Song.new("media/music.ogg")
    @sounds = {
      stein: Gosu::Sample.new("media/stone.ogg"),
      dig: Gosu::Sample.new("media/dig.ogg"),
      wall: Gosu::Sample.new("media/wall.ogg"),
      ziel: Gosu::Sample.new("media/ziel.ogg"),
      schatz: Gosu::Sample.new("media/treasure.ogg")
    }
  end

  def play_sound(sound)
    @sounds[sound].play if @settings[:sound_on]
  end

  def play_music
    if @settings[:music_on]
      @music.play(true)
    else
      @music.stop
    end
  end

end