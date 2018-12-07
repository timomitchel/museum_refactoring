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

  def revenue
    total = 0
    patrons_of_exhibits.each do |exhibit, patrons|
      total += exhibit.cost * patrons.length
    end
    total
  end
end
