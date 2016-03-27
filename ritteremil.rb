require 'gosu'

module ZOrder
  Background, Game, UI = *0..2
end

require_relative 'items'
require_relative 'level'
require_relative 'player'
require_relative 'statusbar'
require_relative 'dialog'




class GameWindow < Gosu::Window
  def initialize
    super 32*25, 32*20+20
    self.caption = "Ritter Emil"

    @background_image = Gosu::Image.new("media/boden.jpg", :tileable => true)
    @start_image = Gosu::Image.new("media/startbildschirm.jpg")
    @items = Items.new
    @level = Level.new(2,@items)

    @player = Player.new(@level,@items)
    @statusleiste = Statusbar.new(@player,@items, @level)
    @font = Gosu::Font.new(20)
    @dialog = Dialog.new(self)
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
      @level.move_animations
    end
  end

  def draw
    if @start
      Gosu::draw_rect(0, 0, width, height, 0x8f_ffffff, ZOrder::UI, :additive)
      @start_image.draw(0, 50, ZOrder::UI,0.6,0.6)
    end
    @background_image.draw(0, 0, ZOrder::Background)
    @level.draw(@player)
    @statusleiste.draw
    if @player.gewonnen
      @dialog.show("Gewonnen!")
    end
    if @player.verloren
      @dialog.show("Leider verloren!")
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
