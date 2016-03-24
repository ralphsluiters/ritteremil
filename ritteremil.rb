require 'gosu'
require_relative 'items'
require_relative 'level'
require_relative 'player'

module ZOrder
  Background, Game, UI = *0..2
end



class GameWindow < Gosu::Window
  def initialize
    super 32*25, 32*20
    self.caption = "Ritter Emil"

    @background_image = Gosu::Image.new("media/boden.jpg", :tileable => true)
    @start_image = Gosu::Image.new("media/startbildschirm.jpg")
    @items = Items.new
    @level = Level.new(1,@items)

    @player = Player.new(@level)

    @font = Gosu::Font.new(20)

    @start = true
  end

  def update
    unless @player.gewonnen || @player.verloren
      direction = nil
      if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
        direction = :left
        sleep 0.2
        @start=false
      end
      if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
        direction = :right
        sleep 0.2
        @start=false
      end
      if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp then
        direction = :up
        sleep 0.2
        @start=false
      end
      if Gosu::button_down? Gosu::KbDown or Gosu::button_down? Gosu::GpDown then
        direction = :down
        sleep 0.2
        @start=false
      end
      @player.try_move(direction)
      @level.move_items(@player)
      @level.move_enemies(@player)

    end
  end

  def draw
    @start_image.draw(0, 50, ZOrder::UI,0.6,0.6) if @start
    @background_image.draw(0, 0, ZOrder::Background)
    @level.draw(@player)
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    if @player.gewonnen
      @font.draw("Gewonnen!", 100, 100, ZOrder::UI, 4.0, 4.0, 0xff_ffff00)
    end
    if @player.verloren
      @font.draw("Leider verloren!", 100, 100, ZOrder::UI, 4.0, 4.0, 0xff_ff0000)
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
