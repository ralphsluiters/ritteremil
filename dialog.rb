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
    @paper_scroll.draw(60, 130, ZOrder::UI,1.0,1.5)
    @font_big.draw(text, 170, 210, ZOrder::UI, 1.0, 1.0, 0xff_493D26)
    if subtext
      lines = subtext.split("\n")
      lines.each_index do |i|
        @font_small.draw(lines[i], 170, 270+i*20, ZOrder::UI, 1.0, 1.0, 0xff_493D26)
      end
    end
  end

  def show_list(text,list,selected_index=nil)
    start = 0; shortlist=nil
    if list.size > 8 
      start = [[selected_index-4,list.size-8].min,0].max
      shortlist = list.slice(start,8)
    else
      shortlist = list
      start=0
    end
    show(text,shortlist.join("\n"))
    @font_small.draw(">", 160, 270+(selected_index-start)*20, ZOrder::UI, 1.0, 1.0, 0xff_493D26)
  end

end