
class Statusbar

  def initialize(player, items, level)
    @font = Gosu::Font.new(20)
    @items = items
    @player = player
    @level = level
  end

  def draw
    @font.draw("Level: #{@level.nummer}", 10, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:schatz,210)
    @font.draw("#{@player.score}", 230, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:axt,300)
    @font.draw("#{@player.waffen}", 320, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:bkey,390)
    @font.draw("#{@player.schluessel_blau}", 410, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)

  end

end