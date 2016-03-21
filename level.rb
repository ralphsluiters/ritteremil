require 'gosu'
require_relative 'items'

class Level

  TEST_LEVEL = [[ :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer ],
[ :mauer, :hero ,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  :erde,  nil,    :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
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
[ :mauer, :schatz,:erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :schatz,:erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer ]]


  attr_reader :level
  attr_reader :area
  attr_reader :hero_start_position

  def initialize(level,items)
    @level = level
    @area = TEST_LEVEL
    @items = items
    @sound_dig = Gosu::Sample.new("media/dig.mp3")
    @sound_wall = Gosu::Sample.new("media/wall.mp3")
    @sound_ziel = Gosu::Sample.new("media/ziel.mp3")
    @sound_schatz = Gosu::Sample.new("media/treasure.mp3")
    @sound_stein = Gosu::Sample.new("media/stone.mp3")
    @music = Gosu::Sample.new("media/music.mp3")
    @music.play(0.5,1,true)


    set_start_position
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
            player.die! if player.on_position?(x,y+2)
            @sound_stein.play
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

  def status(x,y, player)
    case @area[y][x]
      when :mauer
        @sound_wall.play
        return :blockiert
      when :burg
        @sound_ziel.play
        return :gewonnen
      when :stein
        return :blockiert
      when :schatz
        @sound_schatz.play
        player.score +=100
        return :frei
      when :erde
        @sound_dig.play
        return :frei
      else
        return :frei
    end
  end


private

  def set_start_position
    @area.each_index do |y|
      @area[y].each_index do |x|
        if @area[y][x] == :hero
          @area[y][x] = nil
          @hero_start_position = [x,y]
        end
      end
    end
  end
end



