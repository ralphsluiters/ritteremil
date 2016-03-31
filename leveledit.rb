require 'gosu'

module ZOrder
  Background, Game, UI = *0..2
end

require_relative 'items'
require_relative 'level'
require_relative 'dialog'




class GameWindow < Gosu::Window
  def initialize(level_nummer)
    super(32*25+20, 32*20+20+20+32+20)#, fullscreen: true )
    self.caption = "Ritter Emil - Leveleditor"
    @level_nummer = level_nummer.to_i>0 ? level_nummer.to_i : 1

    @background_image = Gosu::Image.new("media/boden.jpg", :tileable => true)
    @items = Items.new(nil)
    @level = Level.new(@level_nummer,@items,true)
    @level.scroll_to(0,0)
    @dialog = Dialog.new(self)
    @position = Position.new(@items, @level)
    @font_small = Gosu::Font.new(20)
  end

  def update
    if Gosu::button_down? Gosu::KbLeft
      @position.move(@position.x-1,@position.y)
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbRight
      @position.move(@position.x+1,@position.y)
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbUp
      @position.move(@position.x,@position.y-1)
      sleep 0.2
    end
    if Gosu::button_down?(Gosu::KbDown)
      @position.move(@position.x,@position.y+1)
      sleep 0.2
    end

    if Gosu::button_down?(Gosu::KbN)
      @position.move_key(@position.key_pos-1)
      sleep 0.2
    end
    if Gosu::button_down?(Gosu::KbM)
      @position.move_key(@position.key_pos+1)
      sleep 0.2
    end
    if Gosu::button_down?(Gosu::KbSpace)
      @level.set_position!(@position.x,@position.y,@position.key)
      sleep 0.2
    end
    if Gosu::button_down?(Gosu::KbS)
      @level.save_level
      sleep 1
    end


  end

  def draw
      @background_image.draw(0, 0, ZOrder::Background)
      @level.draw(@position)
      draw_items
      @font_small.draw("N / M zum wechseln der Items, S zum Speichern | Level: #{@level.nummer}  | Größe: #{@level.breite}x#{@level.hoehe}", 10, 0, ZOrder::UI,1,1,0xff_000000)
      @font_small.draw(@position.key || "Leer", 10, 20*32+20+20+32, ZOrder::UI,1,1,0xff_000000)
      (0..[19,@level.hoehe].min).each {|y| @font_small.draw(y+@level.scroll_y+1,25*32+1, 20+6+y*32, ZOrder::UI,1,1,0xff_000000)}
      (0..[24,@level.breite].min).each {|x| @font_small.draw(x+@level.scroll_x+1,6+x*32, 20*32+22, ZOrder::UI,1,1,0xff_000000)}
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def draw_items
    x = 0
    Items.drawable_items.each do |key|
      @items.draw_on_position(key,x,20*32+40,ZOrder::Game) if key
      x+=32
    end
  end
end

class Position
  attr_reader :x,:y
  attr_reader :key_pos
  def initialize(items, level)
    @x = @y = 0
    @items = items
    @level = level
    @key_pos = 0
  end
  def move(x,y)
    if @level.value(x,y) != :levelende
      @x=x; @y=y
      @level.scroll_to(x,y)
    end
  end
  def move_key(x)
    @key_pos = x
    @key_pos = Items.drawable_items.size-1 if x<0
    @key_pos = 0 if x >= Items.drawable_items.size
  end

  def key
    Items.drawable_items[@key_pos]
  end

  def draw(scroll_x,scroll_y)
    @items.draw(:selection,@x,@y,scroll_x,scroll_y)
    @items.draw_on_position(:selection,@key_pos*32,20*32+40,ZOrder::UI)
  end

end

# print "Bitte Levelnummer eingeben:"
# level_nummer = gets.to_i
# unless File.exist?("levels/level%03d.json" % level_nummer)
# end

window = GameWindow.new(ARGV[0])
window.show
