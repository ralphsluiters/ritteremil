require 'json'

class Spielstand
  attr_reader :level

  def initialize

    @data = lade_daten
    spieler_wechsel!(0)
  end

  def spieler_wechsel!(auswahl)
    @aktiver_spieler = auswahl
    @level = @data["spieler"][auswahl]["level"].to_i
  end


  def speichere_daten
    @data["spieler"][@aktiver_spieler]["level"] = @level
    File.open("spielstand/spielstand.json","w") do |f|
      f.write(@data.to_json)
    end
  end

  def spielerliste
    @data["spieler"].map {|item| "#{item["name"]} (Level: #{item["level"]})"}
  end

  def next_level(played_level)
    @level +=1 unless played_level < @level
  end




private

  def lade_daten
    JSON.parse(File.read("spielstand/spielstand.json"))
  end



end