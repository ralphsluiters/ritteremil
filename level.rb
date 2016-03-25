require 'gosu'
require_relative 'items'
require 'json'

class Level
  attr_reader :area
  attr_reader :hero_start_position
  attr_reader :nummer
  attr_reader :name

  def initialize(nummer,items)
    @nummer = nummer
    @items = items
    @sound_stein = Gosu::Sample.new("media/stone.mp3")
    @music = Gosu::Sample.new("media/music.mp3")
    @music.play(0.5,1,true)
    @last_moved_items = 0
    @last_moved_enemy = 0
    @scroll_x = 2; @scroll_y = 0
    load_level(nummer)
    set_start_position
  end

  def load_level(id)
    data = JSON.parse(File.read("levels/level%03d.json" % id))
    @name = data['name']
    @area = data["karte"]
    @area.each {|row| row.each_index { |i| row[i] = row[i].to_sym if row[i]}}
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
        @items.draw(@area[y][x],x,y,@scroll_x, @scroll_y)
      end
    end
    player.draw(@scroll_x, @scroll_y)
  end

  def scroll_to(x,y) #13 10
    @scroll_x +=1 if x-@scroll_x > 20
    @scroll_x -=1 if x-@scroll_x < 4
    @scroll_y +=1 if y-@scroll_y > 17
    @scroll_y -=1 if y-@scroll_y < 2
    @scroll_x = [[@scroll_x,breite-25].min,0].max
    @scroll_y = [[@scroll_y,hoehe-20].min,0].max
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
    return :mauer if x<0 || y<0 || x>=breite || y>=hoehe
    @area[y][x]
  end


private

  def breite
    @area.first.size
  end

  def hoehe
    @area.size
  end

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



