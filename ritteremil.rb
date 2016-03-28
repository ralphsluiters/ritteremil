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
  def initialize(level_nummer)
    super 32*25, 32*20+20
    self.caption = "Ritter Emil"
    @level_nummer = level_nummer.to_i>0 ? level_nummer.to_i : 1

    @background_image = Gosu::Image.new("media/boden.jpg", :tileable => true)
    @start_image = Gosu::Image.new("media/startbildschirm.jpg")
    @items = Items.new
    @level = Level.new(@level_nummer,@items)
    @player = Player.new(@level,@items)
    @statusleiste = Statusbar.new(@player,@items, @level)
    @font = Gosu::Font.new(20)
    @dialog = Dialog.new(self)
    @state_machine = :spiel_start
  end

  def update
    if @wait_end
      if Gosu::milliseconds > @wait_end || Gosu::button_down?(Gosu::KbSpace)
        @state_machine = @next_state
        @wait_end = nil
      end
    else
      case @state_machine
      when :spiel_start
        @state_machine = :level_start if Gosu::button_down? Gosu::KbSpace
      when :level_start
        @level = Level.new(@level_nummer,@items)
        @player = Player.new(@level,@items)
        @statusleiste = Statusbar.new(@player,@items, @level)
        wait_time(2,:spielen)
      when :spielen
        @state_machine = :gewonnen if @player.gewonnen
        @state_machine = :verloren if @player.verloren
        direction = nil
        if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
          direction = :left
          sleep 0.2
        end
        if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
          direction = :right
          sleep 0.2
        end
        if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpUp then
          direction = :up
          sleep 0.2
        end
        if Gosu::button_down? Gosu::KbDown or Gosu::button_down? Gosu::GpDown then
          direction = :down
          sleep 0.2
        end
        @player.try_move(direction)
        @level.move_items(@player)
        @level.move_enemies(@player)
        @level.move_animations
      when :gewonnen
        @level_nummer += 1
        wait_time(2,:level_start)
      when :verloren
        wait_time(2,:level_start)
      end
    end
  end

  def draw
    case @state_machine
    when :spiel_start
      Gosu::draw_rect(0, 0, width, height, 0x8f_ffffff, ZOrder::UI, :additive)
      @start_image.draw(0, 50, ZOrder::UI,0.6,0.6)
    when :level_start
      @dialog.show("Level: #{@level_nummer}")

    when :spielen
      @background_image.draw(0, 0, ZOrder::Background)
      @level.draw(@player)
      @statusleiste.draw
    when :gewonnen
      @dialog.show("Gewonnen!")
    when :verloren
      @dialog.show("Leider verloren!")
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

private
  def wait_time(seconds,next_state)
    @wait_end = Gosu::milliseconds + seconds*1000
    @next_state = next_state
  end

end

window = GameWindow.new(ARGV[0])
window.show
