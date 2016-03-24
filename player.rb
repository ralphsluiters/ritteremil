class Player
  attr_accessor :score
  attr_reader :gewonnen
  attr_reader :verloren



  def initialize(level)
    @sound_dig = Gosu::Sample.new("media/dig.mp3")
    @sound_wall = Gosu::Sample.new("media/wall.mp3")
    @sound_ziel = Gosu::Sample.new("media/ziel.mp3")
    @sound_schatz = Gosu::Sample.new("media/treasure.mp3")

    @image = Gosu::Image.new("media/items/knight.png")
    @x, @y = level.hero_start_position
    @score = 0
    @level = level
    @gewonnen = @verloren = false
  end


  def try_move(direction)
    x = @x ; y = @y
    case direction
    when :up
      y-= 1
    when :down
      y+= 1
    when :left
      x-= 1
    when :right
      x+= 1
    end

    case @level.value(x,y)
    when :mauer
      @sound_wall.play
    when :burg
      @sound_ziel.play
      @gewonnen = true
    when :stein
      if @level.try_push(x,y,direction, :stein)
        @x=x;@y=y
        @level.clean_position(x,y)
      end
    when :ork
      die!
    when :lava
      die!
    when :schatz
      @sound_schatz.play
      @score +=100
      @x=x;@y=y
      @level.clean_position(x,y)
    when :erde
      @sound_dig.play
      @x=x;@y=y
      @level.clean_position(x,y)
    else
      @x=x;@y=y
      @level.clean_position(x,y)
    end
  end

  def on_position?(x,y)
    x==@x && y==@y
  end

  def die!
    @verloren = true
  end

  def draw
    @image.draw(@x*32, @y*32, 1)
  end


end