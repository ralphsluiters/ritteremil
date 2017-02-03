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
    @data["spieler"].map {|item| item["name"]}
  end

  def next_level
    @level +=1
  end




private

  def lade_daten
    JSON.parse(File.read("spielstand/spielstand.json"))
  end



end