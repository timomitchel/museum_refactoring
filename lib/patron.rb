class Patron
  attr_reader :name,
              :interests,
              :spending_money

  def initialize(name, spending_money)
    @name = name
    @spending_money = spending_money
    @interests = []
  end

  def add_interest(interest)
    @interests << interest
  end

  def spend(amount)
    @spending_money -= amount
  end
end
