require 'gosu'
require_relative 'items'

class Level

  TEST_LEVEL = [[ :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer, :mauer ],
[ :mauer, :hero,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  :erde,  nil,    :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :mauer, :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  :erde,  :stein,   nil,  :erde,  :erde,  :stein, :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :lava,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :mauer, :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
[ :mauer, :stein, :erde,  :erde,  :stein, :stein, :stein, :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :stein, :erde,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,   nil ,  :mauer, :ork,   :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  nil  ,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,   nil ,   nil ,   nil ,  :erde,  :erde,  :stein, :erde,  :erde,  :erde,  :lava,  nil  ,  :erde,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :mauer, :mauer, :mauer, :mauer, :mauer, :erde,  :erde,   nil ,  :erde,  :ork,   :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :lava,  :burg,  :lava,  :mauer ],
[ :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,   nil ,   nil ,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :lava,  :erde,  :lava,  :mauer ],
[ :mauer, :erde,  :stein, :stein, :erde,  :erde,  :erde,  :erde,  :erde,  :lava,  :erde,  :erde,   nil ,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :lava,  :mauer ],
[ :mauer, :lava,  :lava,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :lava,  :lava,  :lava,  :mauer ],
[ :mauer, :schatz,:lava,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer, :erde,  :erde,  :erde,  :erde,  :erde,  :erde,  :mauer ],
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
    @sound_stein = Gosu::Sample.new("media/stone.mp3")
    @music = Gosu::Sample.new("media/music.mp3")
    @music.play(0.5,1,true)
    @last_moved_items = 0
    @last_moved_enemy = 0

    set_start_position
  end

  def try_push(x,y,direction, item)
    if direction == :left && !@area[y][x-1]
      @area[y][x-1]= item
      @area[y][x] = nil
      return true
    elsif direction == :right && !@area[y][x+1]
      @area[y][x+1]= item
      @area[y][x] = nil
      return true
    end
    false
  end

  def draw(player)
    @area.each_index do |y|
      @area[y].each_index do |x|
        item = @area[y][x]
        @items.draw(item,x,y)
      end
    end
    player.draw
  end

  def move_items(player)
    return if @last_moved_items > Gosu::milliseconds - 300
    @last_moved_items = Gosu::milliseconds
    @area.each_index do |y|
      @area[y].each_index do |x|
        if @area[y][x] == :blut
          @area[y][x] = nil
        elsif @area[y][x] == :blut_neu
          @area[y][x] = :blut
        elsif @area[y][x] == :stein
          if @area[y+1][x] == nil && (!player.on_position?(x,y+1))
            player.die! if player.on_position?(x,y+2)
            @area[y+2][x] = :blut_neu if @area[y+2][x]== :ork
            @sound_stein.play
            @area[y][x] = nil
            @area[y+1][x] = :stein_gefallen
          elsif @area[y+1][x] == :lava
            @sound_stein.play
            @area[y][x] = nil
          elsif @area[y+1][x] == :stein && !@area[y][x-1] && (!player.on_position?(x-1,y)) && !@area[y+1][x-1] && (!player.on_position?(x-1,y+1))
            player.die! if player.on_position?(x-1,y+2)
            @sound_stein.play
            @area[y][x] = nil
            @area[y+1][x-1] = :stein_gefallen
          elsif @area[y+1][x] == :stein && !@area[y][x+1] && (!player.on_position?(x+1,y)) && !@area[y+1][x+1] && (!player.on_position?(x+1,y+1))
            player.die! if player.on_position?(x+1,y+2)
            @sound_stein.play
            @area[y][x] = nil
            @area[y+1][x+1] = :stein_gefallen
          end
        elsif @area[y][x] == :stein_gefallen
          @area[y][x] = :stein
        end
      end
    end
  end

  def move_enemies(player)
    return if @last_moved_enemy > Gosu::milliseconds - 700
    @last_moved_enemy = Gosu::milliseconds
    @area.each_index do |y|
      @area[y].each_index do |x|
        if @area[y][x] == :ork
          case Gosu.random(0,3).round
          when 0#up
            if !@area[y-1][x]
              @area[y][x] = nil
              @area[y-1][x] = :ork
              player.die! if player.on_position?(x,y-1)
            end
          when 1#down
            if !@area[y+1][x]
              @area[y][x] = nil
              @area[y+1][x] = :ork_bewegt
              player.die! if player.on_position?(x,y+1)
            end
          when 2#left
            if !@area[y][x-1]
              @area[y][x] = nil
              @area[y][x-1] = :ork
              player.die! if player.on_position?(x-1,y)
            end
          when 3#right
            if !@area[y][x+1]
              @area[y][x] = nil
              @area[y][x+1] = :ork_bewegt
              player.die! if player.on_position?(x+1,y)
            end
          end
        elsif @area[y][x] == :ork_bewegt
          @area[y][x] = :ork
        end
      end
    end
  end



  def clean_position(x,y)
    @area[y][x] = nil
  end

  def value(x,y)
    @area[y][x]
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



