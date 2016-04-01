class Dialog

  def initialize(window)
    @width = window.width
    @height = window.height
    @font_big = Gosu::Font.new(60, name: "media/MedievalSharp.ttf")
    @font_small = Gosu::Font.new(20, name: "media/MedievalSharp.ttf")
    @paper_scroll = Gosu::Image.new("media/paper_scroll.gif")
  end

  def show(text, subtext = nil)
    Gosu::draw_rect(0, 0, @width, @height, 0x8f_ffffff, ZOrder::UI, :additive)
    @paper_scroll.draw(60, 180, ZOrder::UI)
    @font_big.draw(text, 170, 240, ZOrder::UI, 1.0, 1.0, 0xff_493D26)
    if subtext
      lines = subtext.split("\n")
      lines.each_index do |i|
        @font_small.draw(lines[i], 170, 300+i*20, ZOrder::UI, 1.0, 1.0, 0xff_493D26)
      end
    end
  end

end