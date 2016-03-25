require 'gosu'

class Items
  TYPES = {
    erde: {file: 'mud.jpeg' },
    mauer: {file: 'wall.png' },
    stein: {file: 'rock.png' },
    burg: {file: 'castle.png' },
    schatz: {file: 'treasure.png'},
    lava: {file: 'lava_tiles.png', animated: 30},
    ork: {file: 'ork.png'},
    axt: {file: 'axe.png'},
    btuer: {file: 'door_blue.png'},
    bkey: {file: 'key_blue.png'},
    ritter: {file: 'knight.png'},
    blut: {file: 'blut.png'}
  }
  #animated gifs:  http://gif2sprite.com/

  def initialize
    @images = {}
    TYPES.each do |key,value|
      @images[key] = if value[:animated]
          Gosu::Image::load_tiles("media/items/#{value[:file]}", 32, 32)
        else
          Gosu::Image.new("media/items/#{value[:file]}", :tileable => true)
        end
    end
  end

  def draw(key, x, y, scroll_x, scroll_y)
    if key
      if (x-scroll_x >= 0) && (x-scroll_x < 25) && (y-scroll_y >= 0) && (y-scroll_y < 20)
        image = @images[key]
        image = image[Gosu::milliseconds / 100 % image.size] if image.class == Array
        image.draw((x-scroll_x)*32, (y-scroll_y)*32+20, 1)
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

end