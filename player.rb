class Player
  attr_accessor :score
  attr_reader :gewonnen
  attr_reader :verloren



  def initialize(level)
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
    result = @level.status(x,y,self)
   # puts "x: #{@x}, y: #{@y}  versuch x: #{x}, y: #{y}, result: #{result}"
    if result == :frei
      @x=x;@y=y
      @level.clean_position(x,y)
    end
    if result == :gewonnen
      @gewonnen = true
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