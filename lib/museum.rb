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

  def add_patron(patron)
    @patrons << patron
  end

  def admit(patron)
    add_patron(patron)
    recommend_exhibits_by_cost(patron).each do |exhibit|
      attend_an_exhibit(exhibit, patron) if can_afford_exhibit?(exhibit, patron)
    end
  end

  def can_afford_exhibit?(exhibit, patron)
    exhibit.cost <= patron.spending_money
  end

  def attend_an_exhibit(exhibit, patron)
    patron.spend(exhibit.cost)
    @patrons_of_exhibits[exhibit] << patron
  end

  def recommend_exhibits(patron)
    @exhibits.find_all do |exhibit|
      patron.interests.include? exhibit.name
    end
  end

  def recommend_exhibits_by_cost(patron)
    recommend_exhibits(patron).sort_by do |exhibit|
      exhibit.cost <=> exhibit.cost
    end
  end

  def add_default_values_to_interested_patrons
    interested_patrons = {}
    exhibits.each { |exhibit| interested_patrons[exhibit] = [] }
    interested_patrons
  end

  def patrons_by_exhibit_interest
    interested_patrons = add_default_values_to_interested_patrons
    patrons.each do |patron|
      interests = recommend_exhibits(patron)
      interests.each {|exhibit| interested_patrons[exhibit] << patron}
    end
    interested_patrons
  end

  def ticket_lottery_contestants(exhibit)
    patrons_by_exhibit_interest[exhibit].find_all do |patron|
      !can_afford_exhibit?(exhibit, patron)
    end
  end

  def draw_lottery_winner(exhibit)
    contestants = ticket_lottery_contestants(exhibit)
    return nil if contestants.empty?
    contestants.sample.name
  end

  def announce_lottery_winner(exhibit)
    lottery_winner = draw_lottery_winner(exhibit)
    return "No winners for this lottery" if lottery_winner.nil?
    "#{lottery_winner} has won the #{exhibit.name} exhibit lottery"
  end


  def revenue
    patrons_of_exhibits.reduce(0) do |result, exhibit_and_patrons|
      result += exhibit_and_patrons[0].cost * exhibit_and_patrons[1].length
      result
    end
  end
end
