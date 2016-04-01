require 'gosu'
require_relative 'items'
require 'json'
require 'fileutils'

class Level
  attr_reader :area
  attr_reader :hero_start_position
  attr_reader :nummer
  attr_reader :name
  attr_reader :scroll_x,:scroll_y

  TIPPS = ["Handschuhe schützen vor Feuer und Lava.",
           "Schilde schützen, wenn Feinde angreifen.",
           "Mit Äxten kann man Feinde angreifen.",
           "Äxte schützen nicht vor Feinden.",
           "Ein Helm hilft bei fallenden Steinen.",
           "Steine versinken in Lava.",
           "Man kann schneller rennen als die Feinde.",
           "Feuer breitet sich aus.",
           "Orks wissen nie, wo sie hinlaufen.",
           "Skelette laufen immer zum Held.",
           "Die Burg ist das Ziel."]


  def initialize(nummer,items,editmode = false)
    @editmode = editmode
    @nummer = nummer
    @items = items

    @last_moved_items = 0
    @last_moved_enemy = 0
    @scroll_x = 0; @scroll_y = 0
    @animations = []
    unless @editmode
      @tipp_nummer = Gosu.random(1,TIPPS.size)-1
      load_level
      set_start_position
    end
  end

  def change_number(rel)
    return unless @editmode
    @nummer = [@nummer+rel,1].max
  end

  def new_level(breite,hoehe)
    @name = ""
    @area = Array.new(hoehe) {Array.new(breite) }
  end

  def load_level
    data = JSON.parse(File.read("levels/level%03d.json" % @nummer))
    @name = data['name']
    @area = data["karte"]
    @area.each {|row| row.each_index { |i| row[i] = row[i].to_sym if row[i]}}
  end

  def save_level(id=@nummer)
    file_name = "levels/level%03d.json" % id
    file_name_bak = "levels/level%03d_#{Time.now.strftime("%Y%m%d%H%M%S")}.bak" % id

    FileUtils.mv file_name, file_name_bak, :force => true
    data = {name: @name.to_s, karte: @area}
    File.open(file_name,"w") do |f|
      f.write(data.to_json)
    end
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
    @animations.each{|a| a.draw}
  end

  def add_animation(key,x,y,sammeln = true)
    @animations.push(Animation.new(key,(x-@scroll_x)*32,(y-@scroll_y)*32+20,@items,sammeln))
  end

  def move_animations
    @animations.reject! {|a| a.move}

  end

  def scroll_to(x,y) #13 10
    @scroll_x +=1 if x-@scroll_x > 17
    @scroll_x -=1 if x-@scroll_x < 7
    @scroll_y +=1 if y-@scroll_y > 13
    @scroll_y -=1 if y-@scroll_y < 6
    @scroll_x = [[@scroll_x,breite-25].min,0].max
    @scroll_y = [[@scroll_y,hoehe-20].min,0].max
  end


  def move_items(player)
    return if @last_moved_items > Gosu::milliseconds - 300
    @last_moved_items = Gosu::milliseconds
    area_new = Marshal.load(Marshal.dump(@area))
    feuer_gefunden = false
    @area.each_index do |y|
      @area[y].each_index do |x|
        if @area[y][x] == :feuer && (!feuer_gefunden) && Gosu.random(0,20)<1
          if !@area[y-1][x]
            area_new[y-1][x] = :feuer
            feuer_gefunden = true
          elsif !@area[y+1][x]
            area_new[y+1][x] = :feuer
            feuer_gefunden = true
          elsif !@area[y][x-1]
            area_new[y][x-1] = :feuer
            feuer_gefunden = true
          elsif !@area[y][x+1]
            area_new[y][x+1] = :feuer
            feuer_gefunden = true
          end
        elsif @area[y][x] == :explosion_bald
          area_new[y][x] = :explosion
          explosion(x,y,player,area_new)
        elsif @area[y][x] == :explosion
          area_new[y][x] = nil
        elsif @area[y][x] == :blut
          area_new[y][x] = nil
        elsif @area[y][x] == :fass
          if !@area[y+1][x] && (!player.on_position?(x,y+1))
            area_new[y][x] = nil
            area_new[y+1][x] = :fass_fallend
          end
        elsif @area[y][x] == :fass_fallend
          if @area[y+1][x] == nil && (!player.on_position?(x,y+1))
            area_new[y][x] = nil
            area_new[y+1][x] = :fass_fallend
          else
            explosion(x,y,player,area_new)
          end
        elsif @area[y][x] == :stein
          if @area[y+1][x] == nil && (!player.on_position?(x,y+1))
            player.die!(:stein) if player.on_position?(x,y+2) && !player.helm
            area_new[y+2][x] = :fass_fallend if @area[y+2][x] == :fass
            area_new[y+2][x] = :blut if @area[y+2][x]== :ork && y<hoehe-1
            area_new[y+2][x] = nil if @area[y+2][x]== :skelett && y<hoehe-1
            @items.play_sound(:stein)
            area_new[y][x] = nil
            area_new[y+1][x] = :stein
          elsif @area[y+1][x] == :lava
            @items.play_sound(:stein)
            area_new[y][x] = nil
          elsif @area[y+1][x] == :stein && !@area[y][x-1] && (!player.on_position?(x-1,y)) && !@area[y+1][x-1] && (!player.on_position?(x-1,y+1))
            player.die!(:stein) if player.on_position?(x-1,y+2) && !player.helm
            @items.play_sound(:stein)
            area_new[y][x] = nil
            area_new[y+1][x-1] = :stein
          elsif @area[y+1][x] == :stein && !@area[y][x+1] && (!player.on_position?(x+1,y)) && !@area[y+1][x+1] && (!player.on_position?(x+1,y+1))
            player.die!(:stein) if player.on_position?(x+1,y+2) && !player.helm
            @items.play_sound(:stein)
            area_new[y][x] = nil
            area_new[y+1][x+1] = :stein
          end
        end
      end
    end
    @area = area_new
  end

  def move_enemies(player)
    return if @last_moved_enemy > Gosu::milliseconds - 700
    @last_moved_enemy = Gosu::milliseconds
    @area.each_index do |y|
      @area[y].each_index do |x|
        if @area[y][x] == :ork
          case Gosu.random(0,3).round
          when 0#up
            move_enemies_to(x,y,x,y-1,:ork, player)
          when 1#down
            move_enemies_to(x,y,x,y+1,:ork_bewegt, player)
          when 2#left
            move_enemies_to(x,y,x-1,y,:ork, player)
          when 3#right
            move_enemies_to(x,y,x+1,y,:ork_bewegt, player)
          end
        elsif @area[y][x] == :skelett
          moved = false
          if player.x < x
            moved = true if move_enemies_to(x,y,x-1,y,:skelett, player)
          elsif player.x > x
            moved = true if move_enemies_to(x,y,x+1,y,:skelett_bewegt, player)
          end
          unless moved
            if player.y < y
              move_enemies_to(x,y,x,y-1,:skelett, player)
            elsif player.y > y
              move_enemies_to(x,y,x,y+1,:skelett_bewegt, player)
            end
          end
        elsif @area[y][x] == :ork_bewegt
          @area[y][x] = :ork
        elsif @area[y][x] == :skelett_bewegt
          @area[y][x] = :skelett
        end
      end
    end
  end

  def explosion(x,y,player,area_new)
    ([y-1,0].max..[y+1,hoehe-1].min).each do |ii|
      ([x-1,0].max..[x+1,breite-1].min).each do |i|
        player.die!(:explosion) if player.on_position?(i,ii)
        if ![:lava,:mauer, :explosion_bald].include?(@area[ii][i])
          area_new[ii][i] = if [:fass,:fass_fallend].include?(@area[ii][i]) && !(y==ii && x==i)
            :explosion_bald
          else
            :explosion
          end
        end
      end
    end
  end

  def tipp
    "Tipp: #{TIPPS[@tipp_nummer]}"
  end

  def clean_position(x,y)
    @area[y][x] = nil
  end

  def set_position!(x,y,key) #only for level edit
    return if x>=breite || y>=hoehe
    @area[y][x] = key
  end


  def value(x,y)
    return :levelende if x<0 || y<0 || x>=breite || y>=hoehe
    @area[y][x]
  end

  def breite
    @area && @area.first ? @area.first.size : 0
  end

  def hoehe
    @area ? @area.size : 0
  end


private

  def move_enemies_to(x,y,target_x,target_y, key, player)
    if !@area[target_y][target_x]
      if player.on_position?(target_x,target_y)
        player.attacked(key)
      else
        @area[y][x] = nil
        @area[target_y][target_x] = key
      end
      return true
    else
      return false
    end
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



