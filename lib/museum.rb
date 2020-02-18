class Museum
  attr_reader :name,
              :exhibits,
              :patrons,
              :patrons_of_exhibits

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @patrons_of_exhibits = Hash.new do |patrons_of_exhibits, key|
      patrons_of_exhibits[key] = []
    end
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def admit(patron)
    @patrons << patron
    exhibits = recommend_exhibits_by_cost(patron)
    exhibits.each do |exhibit|
      if exhibit.cost <= patron.spending_money
        patron.spend(exhibit.cost)
        @patrons_of_exhibits[exhibit] << patron
      end
    end
  end

  def recommend_exhibits(patron)
    @exhibits.find_all do |exhibit|
      patron.interests.include? exhibit.name
    end
  end

  def recommend_exhibits_by_cost(patron)
    recommend_exhibits(patron).sort_by do |exhibit|
      exhibit.cost
    end.reverse
  end

  def patrons_by_exhibit_interest
    exhibit_interest = {}
    @exhibits.each do |exhibit|
      exhibit_interest[exhibit] = []
    end
    @patrons.each do |patron|
      exhibits = recommend_exhibits(patron)
      exhibits.each do |exhibit|
        exhibit_interest[exhibit] << patron
      end
    end
    exhibit_interest
  end

  def ticket_lottery_contestants(exhibit)
    lottery_patrons = patrons_by_exhibit_interest[exhibit]
    lottery_patrons.find_all do |patron|
      patron.spending_money < exhibit.cost &&
      !patrons_of_exhibits[exhibit].include?(patron)
    end
  end

  def draw_lottery_winner(exhibit)
    contestants = ticket_lottery_contestants(exhibit)
    return "No contestants for this lottery" if contestants.empty?
    winner = contestants.sample
    winner.name
  end

  def announce_lottery_winner(exhibit)
    default = "No winners for this lottery"
    no_contestants = "No contestants for this lottery"
    return default if draw_lottery_winner(exhibit) == no_contestants
    "#{draw_lottery_winner(exhibit)} has won the #{exhibit.name} exhibit lottery"
  end


  def revenue
    total = 0
    patrons_of_exhibits.each do |exhibit, patrons|
      total += exhibit.cost * patrons.length
    end
    total
  end
end
