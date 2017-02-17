require 'gosu'

module ZOrder
  Background, Game, UI = *0..2
end

require_relative 'sounds'
require_relative 'items'
require_relative 'level'
require_relative 'player'
require_relative 'statusbar'
require_relative 'dialog'
require_relative 'leveledit'
require_relative 'spielstand'




class GameWindow < Gosu::Window
  def initialize(level_nummer)
    super(32*25, 32*20+20)#, fullscreen: true )
    self.caption = "Ritter Emil"
    @settings = {sound_on: true, music_on: true}
    @spielstand = Spielstand.new
    @background_image = Gosu::Image.new("media/boden.jpg", :tileable => true)
    @start_image = Gosu::Image.new("media/startbildschirm.jpg")
    @sounds = Sounds.new(@settings)
    @sounds.play_music
    @items = Items.new(@sounds)
    @level = Level.new(@spielstand.level,@items)
    @player = Player.new(@level,@items)
    @statusleiste = Statusbar.new(@player,@items, @level,@settings)
    @dialog = Dialog.new(self)
    @state_machine = :spiel_start
    @spieler_auswahl_position = 0
  end

  def update
    if @wait_end
      if Gosu::milliseconds > @wait_end || Gosu::button_down?(Gosu::KbSpace) || Gosu::button_down?(Gosu::KbEnter) || Gosu::button_down?(40)
        @state_machine = @next_state
        @wait_end = nil
      end
    else
      case @state_machine
      when :spiel_start
        if Gosu::button_down?(Gosu::KbSpace) || Gosu::button_down?(Gosu::KbEnter) || Gosu::button_down?(40)
          @state_machine = :spieler_auswahl
          sleep 0.5
        end
      when :level_start
        @level = Level.new(@level_auswahl_position+1,@items)
        @player = Player.new(@level,@items)
        @statusleiste = Statusbar.new(@player,@items, @level,@settings)
        wait_time(2,:spielen)
      when :spielen
        @state_machine = :gewonnen if @player.gewonnen
        @state_machine = :verloren if @player.verloren
        if Gosu::button_down?(Gosu::KbP)
          @state_machine = :pause
          sleep 0.5
        else
          if Gosu::button_down?(Gosu::KbEscape) || Gosu::button_down?(Gosu::KbQ)
            @state_machine = :verloren
          end
          if Gosu::button_down? Gosu::KbM
            @settings[:music_on]= !@settings[:music_on]

            sleep 0.2
          end
          if Gosu::button_down? Gosu::KbS
            @settings[:sound_on]= !@settings[:sound_on]
            sleep 0.2
          end
          direction = nil
          if Gosu::button_down? Gosu::KbLeft
            direction = :left
            sleep 0.1
          end
          if Gosu::button_down? Gosu::KbRight
            direction = :right
            sleep 0.1
          end
          if Gosu::button_down? Gosu::KbUp
            direction = :up
            sleep 0.1
          end
          if Gosu::button_down?(Gosu::KbDown)
            direction = :down
            sleep 0.1
          end

          @player.try_move(direction)
          @level.move_items(@player)
          @level.move_enemies(@player)
          @level.move_animations
        end
      when :pause
        if Gosu::button_down? Gosu::KbP
          sleep 0.5
          @state_machine = :spielen
        end
      when :gewonnen
        @spielstand.next_level(@level_auswahl_position+1,@player.score)
        @spielstand.speichere_daten
        @level_auswahl_position +=1 
        wait_time(2,:level_auswahl)
      when :verloren
        wait_time(2,:level_auswahl)
      when :spieler_auswahl
        update_spieler_auswahl
      when :level_auswahl
        update_level_auswahl
      end
    end
  end



  def update_spieler_auswahl
    if Gosu::button_down?(Gosu::KbEscape) || Gosu::button_down?(Gosu::KbQ)
      close
    end
    if Gosu::button_down? Gosu::KbUp
      @spieler_auswahl_position -=1
      @spieler_auswahl_position =6 if @spieler_auswahl_position<0
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbDown
      @spieler_auswahl_position +=1
      @spieler_auswahl_position =0 if @spieler_auswahl_position>6
      sleep 0.2
    end
    if Gosu::button_down?(Gosu::KbSpace) || Gosu::button_down?(Gosu::KbEnter) || Gosu::button_down?(40)
      #spieler laden
      if @spieler_auswahl_position==5
        leveleditwindow = LevelEditWindow.new()
        leveleditwindow.show
        close #own game window
      elsif @spieler_auswahl_position==6
        close
      else
        @spielstand.spieler_wechsel!(@spieler_auswahl_position)
        @level_auswahl_position = @spielstand.level-1
        @state_machine = :level_auswahl
        sleep 0.2
      end
    end
  end


  def update_level_auswahl
    if Gosu::button_down?(Gosu::KbEscape) || Gosu::button_down?(Gosu::KbQ)
      @state_machine = :spieler_auswahl
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbUp
      @level_auswahl_position -=1
      @level_auswahl_position =@spielstand.level-1 if @level_auswahl_position<0
      sleep 0.2
    end
    if Gosu::button_down? Gosu::KbDown
      @level_auswahl_position +=1
      @level_auswahl_position =0 if @level_auswahl_position>@spielstand.level-1
      sleep 0.2
    end
    if Gosu::button_down?(Gosu::KbSpace) || Gosu::button_down?(Gosu::KbEnter) || Gosu::button_down?(40)
      
      @state_machine = :level_start
    end
  end

  def draw
    case @state_machine
    when :spiel_start
      Gosu::draw_rect(0, 0, width, height, 0x8f_ffffff, ZOrder::UI, :additive)
      @start_image.draw(0, 50, ZOrder::UI,0.6,0.6)
    when :level_start
      @dialog.show("Level #{@level.nummer}: #{@level.name}",@level.tipp)

    when :spielen
      @background_image.draw(0, 0, ZOrder::Background)
      @level.draw(@player)
      @statusleiste.draw
    when :pause
      @dialog.show("P A U S E !", "P drücken um weiterzuspielen")
    when :gewonnen
      @dialog.show("Gewonnen!")
    when :verloren
      @dialog.show("Leider verloren!",@player.comment)
    when :spieler_auswahl
      @dialog.show_list("Spielerauswahl",(@spielstand.spielerliste + ["Leveleditor","Beenden"]),@spieler_auswahl_position)
    when :level_auswahl
      @dialog.show_list("Levelauswahl",(1..@spielstand.level).to_a.map{|i| "Level #{i}: #{i<@spielstand.level ? "geschafft" : "aktuell"}"},@level_auswahl_position )
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
