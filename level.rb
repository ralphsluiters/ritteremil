require 'gosu'
require_relative 'items'

class Level

  TEST_LEVEL = [[ :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer ],
[ :mauer,  nil ,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  :erde,  nil,    :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :mauer, :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein,   nil,  :erde,  :erde,  :stein, :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :mauer, :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :stein, :erde,  :erde,  :stein, :stein, :stein, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  nil  ,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  nil  ,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :mauer, :mauer, :mauer, :mauer, :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :burg,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :stein, :stein, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer ]]


  attr_reader :level
  attr_reader :area

  def initialize(level,items)
    @level = level
    @area = TEST_LEVEL
    @items = items
  end


  def draw
    @area.each_index do |y|
      @area[y].each_index do |x|
        item = @area[y][x]
        @items.draw(item,x,y)
      end
    end
  end

  def move_items(player)
    @area.each_index do |y|
      @area[y].each_index do |x|
        if @area[y][x] == :stein
          if @area[y+1][x] == nil && (!player.on_position?(x,y+1))
            @area[y][x] = nil
            @area[y+1][x] = :stein_gefallen
          end
        end
        if @area[y][x] == :stein_gefallen
          @area[y][x] = :stein
        end
      end
    end
  end

  def clean_position(x,y)
    @area[y][x] = nil
  end

  def status(x,y)
    case @area[y][x]
      when :mauer
        return :blockiert
      when :burg
        return :gewonnen
      when :stein
        return :blockiert
      else
        return :frei
    end
  end

end



