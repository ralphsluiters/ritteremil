require 'gosu'

class Items
  TYPES = {
    erde: {file: 'mud.jpeg' },
    mauer: {file: 'wall.png' },
    stein: {file: 'rock.png' },
    burg: {file: 'castle.png' },
    schatz: {file: 'treasure.png'}
  }

  def initialize
    @images = {}
    TYPES.each do |key,value|
      @images[key] = Gosu::Image.new("media/items/#{value[:file]}", :tileable => true)
    end
  end

  def draw(key, x, y)
    @images[key].draw(x*32, y*32, 1) if key
  end


end