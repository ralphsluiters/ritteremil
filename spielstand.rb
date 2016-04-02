class Spielstand

  def initialize

    @data = lade_daten
  end

  def lade_daten
    JSON.parse(File.read("spielstand/spielstand.json"))
  end

  def spielerliste
  end

end