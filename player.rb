class Player
  attr_accessor :score
  attr_reader :gewonnen
  attr_reader :verloren
  attr_reader :waffen
  attr_reader :schilde
  attr_reader :schluessel_blau
  attr_reader :handschuhe
  attr_reader :helm
  attr_reader :x
  attr_reader :y

  VERLOREN_TEXTE = {
    lava: "Autsch! Lava ist heiss.",
    feuer: "Autsch! Finger verbrannt.",
    ork: "Hilfe! Ein Ork.",
    skelett: "Huch, ein Skelett!",
    stein: "Beule am Kopf!",
    explosion: "BOOOOOOM!"
  }


  def initialize(level,items)
    @items = items
    @x, @y = level.hero_start_position
    @score = 0
    @level = level
    @waffen = @schilde = 0
    @handschuhe = 0
    @schluessel_blau = 0
    @gewonnen = @verloren = false
    @helm = false
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
      @items.play_sound(:wall)
    when :burg
      @items.play_sound(:ziel)
      @gewonnen = true
    when :stein
      move(x,y) if @level.try_push(x,y,direction, :stein)
    when :fass
      move(x,y) if @level.try_push(x,y,direction, :fass)
    when :ork
      if @waffen > 0
        move(x,y)
        @level.add_animation(:axt,x,y, false)
        @waffen -=1
      else
        die!(:ork)
      end
    when :skelett
      if @waffen > 0
        move(x,y)
        @level.add_animation(:axt,x,y, false)
        @waffen -=1
      else
        die!(:skelett)
      end
    when :btuer
      if @schluessel_blau > 0
        move(x,y)
        @level.add_animation(:bkey,x,y, false)
        @schluessel_blau -= 1
      end

    when :explosion
      if @handschuhe > 0
        @level.add_animation(:glove,x,y, false)
        @handschuhe -=1
      else
        die!(:explosion)
      end
    when :feuer
      if @handschuhe > 0
        @level.add_animation(:glove,x,y, false)
        @handschuhe -=1
      else
        die!(:feuer)
      end
    when :lava
      if @handschuhe > 0
        @level.add_animation(:glove,x,y, false)
        @handschuhe -=1
      else
        die!(:lava)
      end
    when :schatz
      @items.play_sound(:schatz)
      @level.add_animation(:schatz,x,y)
      @score +=100
      move(x,y)
    when :helm
      @items.play_sound(:schatz)
      @helm = true
      @level.add_animation(:helm,x,y)
      move(x,y)
    when :erde
      @items.play_sound(:dig)
      move(x,y)
    when :bkey
      @schluessel_blau +=1
      @level.add_animation(:bkey,x,y)
      move(x,y)
    when :axt
      @waffen +=1
      @level.add_animation(:axt,x,y)
      move(x,y)
    when :glove
      @handschuhe +=1
      @level.add_animation(:glove,x,y)
      move(x,y)
    when :schild
      @schilde +=1
      @level.add_animation(:schild,x,y)
      move(x,y)
    else
      move(x,y)
    end
  end

  def move(x,y)
    @x=x; @y=y
    @level.clean_position(x,y)
    @level.scroll_to(x,y)
  end

  def on_position?(x,y)
    x==@x && y==@y
  end

  def die!(key)
    @verloren = key
  end

  def attacked(enemy)
    if @schilde > 0
      @level.add_animation(:schild,@x,@y, false)
      @schilde -= 1
    else
      die!(enemy)
    end
  end
  def comment
    VERLOREN_TEXTE[verloren] if verloren
  end

  def draw(scroll_x,scroll_y)
    @items.draw(:ritter,@x,@y,scroll_x,scroll_y)
  end


end