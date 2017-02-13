require 'gosu'

class Items
  TYPES = {
    erde: {file: 'mud.jpeg' },
#    erde: {file: 'earth.jpeg' },
    mauer: {file: 'wall.png' },
    mauerk: {file: 'brickwall.jpg' },
    stein: {file: 'rock.png' },
    fass: {file: 'pulverfass.gif'},
    lava: {file: 'lava_tiles.png', animated: 30},
    feuer: {file: 'feuer.png'},
    ork: {file: 'ork.png'},
    skelett: {file: 'skeleton.png'},
    drache: {file: 'dragon.gif'},
    btuer: {file: 'door_blue.png'},
    bkey: {file: 'key_blue.png'},
    schatz: {file: 'treasure.png'},
    axt: {file: 'axe.png'},
    schild: {file: 'shield.gif'},
    glove: {file: 'glove.png'},
    helm: {file: 'helmet.gif'},
    hero: {file: 'knight.png'},
    burg: {file: 'castle.png' },
    fass_fallend: {file: 'pulverfass.gif', drawable: false},
    explosion: {file: 'explosion.png', animated: 10, drawable: false},
    explosion_bald: {file: 'explosion.png', animated: 10, drawable: false},
    music: {file: 'music.png', drawable: false},
    sound: {file: 'sound.png', drawable: false},
    kein: {file: 'no.png', drawable: false},
    selection: {file: 'selection_mask.png', drawable: false, animated: 3}, # for leveledit
    blut: {file: 'blut.png', drawable: false}
  }
  #animated gifs:  http://gif2sprite.com/

  def initialize(sounds)
    @sounds = sounds
    @images = {}
    TYPES.each do |key,value|
      @images[key] = if value[:animated]
          Gosu::Image::load_tiles("media/items/#{value[:file]}", 32, 32)
        else
          Gosu::Image.new("media/items/#{value[:file]}", :tileable => true)
        end
    end
  end

  def play_sound(key)
    @sounds.play_sound(key)
  end


  def draw(key, x, y, scroll_x, scroll_y)
    if key
      if (x-scroll_x >= 0) && (x-scroll_x < 25) && (y-scroll_y >= 0) && (y-scroll_y < 20)
        rotation=if [:lava,:erde,:bkey,:axt,:glove,:explosion].include?(key)
                 ((x+y) % 4)*90 
                 else 
                  0
                 end
        draw_on_position(key, (x-scroll_x)*32, (y-scroll_y)*32+20,ZOrder::Game,1,rotation)
      end
    end
  end

  def draw_statusbar(key,x)
    if key
      image = @images[key]
      image = image[Gosu::milliseconds / 100 % image.size] if image.class == Array
      image.draw(x, 2, 2,0.5,0.5)
    end
  end

  def draw_on_position(key,x,y, z = ZOrder::Game, scale = 1, rotation = 0)
    image = @images[key]
    image = image[Gosu::milliseconds / 100 % image.size] if image.class == Array
    
    if rotation == 0
      image.draw(x, y, z,scale,scale)
    else
      image.draw_rot(x+16, y+16, z, rotation, 0.5, 0.5, scale, scale)
    end
  end

  def self.drawable_items
    [nil] + TYPES.select{|k,v| v[:drawable] != false}.keys
  end
end

class Animation
  def initialize(key, x,y, items, sammeln = true)
    @items = items
    @x = x ; @y = y
    @start_y = y
    @key = key
    @last=0
    @scale = 1
    @sammeln = sammeln
  end

  def draw
    @items.draw_on_position(@key,@x,@sammeln ? @y : @start_y, ZOrder::UI, @scale)
  end

  def move
    if @y > 10
      @scale = ((@start_y/2.0)/@y)
      @y -=10
      false
    else
      true
    end
  end

end