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

  def draw(key, x, y)
    if key
      image = @images[key]
      image = image[Gosu::milliseconds / 100 % image.size] if image.class == Array
      image.draw(x*32, y*32, 1)
    end
  end


end