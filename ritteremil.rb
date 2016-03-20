require 'gosu'
require_relative 'items'
require_relative 'level'

module ZOrder
  Background, Game, UI = *0..2
end


class Player
  attr_reader :score

  def initialize(level)
    @image = Gosu::Image.new("media/items/knight.png")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x = @y = 1
    @score = 0
    @level = level
  end

  def warp(x, y)
    @x, @y = x, y
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
    result = @level.status(x,y)
   # puts "x: #{@x}, y: #{@y}  versuch x: #{x}, y: #{y}, result: #{result}"
    if result == :frei
      @x=x;@y=y
      @level.clean_position(x,y)
    end
  end

  def on_position?(x,y)
    x==@x && y==@y
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw(@x*32, @y*32, 1)
  end

    def score
    @score
  end

end





class GameWindow < Gosu::Window
  def initialize
    super 32*25, 32*20
    self.caption = "Ritter Emil"

    @background_image = Gosu::Image.new("media/boden.jpg", :tileable => true)
    @items = Items.new
    @level = Level.new(1,@items)

    @player = Player.new(@level)
    @player.warp(1, 1)



    @font = Gosu::Font.new(20)
  end

  def update
    direction = nil
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
      direction = :left
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
      direction = :right
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp then
      direction = :up
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbDown or Gosu::button_down? Gosu::GpDown then
      direction = :down
      sleep 0.2
    end
    @player.try_move(direction)
    @level.move_items(@player)
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @level.draw
    @player.draw
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
