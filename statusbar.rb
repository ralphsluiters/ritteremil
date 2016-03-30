
class Statusbar

  def initialize(player, items, level, settings)
    @font = Gosu::Font.new(20, name: "media/MedievalSharp.ttf")
    @items = items
    @player = player
    @level = level
    @settings = settings
  end

  def draw
    @font.draw("Level: #{@level.nummer}", 10, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:schatz,100)
    @font.draw("#{@player.score}", 120, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:glove,165)
    @font.draw("#{@player.handschuhe}", 185, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:axt,210)
    @font.draw("#{@player.waffen}", 230, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:schild,255)
    @font.draw("#{@player.schilde}", 275, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)
    @items.draw_statusbar(:bkey,300)
    @font.draw("#{@player.schluessel_blau}", 320, 1, ZOrder::UI, 1.0, 1.0, 0xff_000000)

    @items.draw_statusbar(:helm,345) if @player.helm

    @items.draw_statusbar(:music,700)
    @items.draw_statusbar(:kein,700) unless @settings[:music_on]
    @items.draw_statusbar(:sound,720)
    @items.draw_statusbar(:kein,720) unless @settings[:sound_on]

  end

end