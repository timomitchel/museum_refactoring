require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/museum'
require './lib/patron'
require './lib/exhibit'

class MuseumTest < Minitest::Test

  def setup
    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
    @tj = Patron.new("TJ", 7)
    @gabe = Patron.new("Gabe", 10)
    @morgan = Patron.new("Morgan", 15)
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("Dead Sea Scrolls")
    @sally.add_interest("IMAX")
    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")
    @gabe.add_interest("Dead Sea Scrolls")
    @gabe.add_interest("IMAX")
    @morgan.add_interest("Gems and Minerals")
    @morgan.add_interest("Dead Sea Scrolls")
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_starts_with_no_exhibits
    denver_art = Museum.new("Denver Art Museum")
    assert_equal [], denver_art.exhibits
  end

  def test_it_can_add_exhibits
    assert_equal [@gems_and_minerals, @imax, @dead_sea_scrolls], @dmns.exhibits
  end

  def test_it_can_return_a_list_of_exhibits_a_patron_should_attend
    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@bob)
  end

  def test_it_starts_with_no_patrons
    denver_art = Museum.new("Denver Art Museum")
    assert_equal [], denver_art.patrons
  end

  def test_it_can_admit_patrons
    @dmns.admit(@bob)
    @dmns.admit(@sally)
    assert_equal [@bob, @sally], @dmns.patrons
  end

  def test_it_can_return_patrons_by_exhibit_interest
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = {
      @gems_and_minerals => [@bob],
      @dead_sea_scrolls => [@bob, @sally],
      @imax => [@sally]
    }
    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_it_can_find_lottery_contestants
    @dmns.admit(@tj)
    @dmns.admit(@gabe)
    @dmns.admit(@sally)
    @dmns.admit(@morgan)
    assert_equal [@tj, @gabe], @dmns.ticket_lottery_contestants(@imax)
    assert_equal [], @dmns.ticket_lottery_contestants(@gems_and_minerals)
  end

  def test_it_can_draw_lottery_winner
    @dmns.admit(@tj)
    @dmns.admit(@gabe)
    @dmns.admit(@sally)
    @dmns.admit(@morgan)

    assert_includes ["Gabe", "TJ"], @dmns.draw_lottery_winner(@imax)
    assert_equal "No contestants for this lottery", @dmns.draw_lottery_winner(@gems_and_minerals)
    assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(@gems_and_minerals)
  end

  def test_it_can_announce_lottery_winner
    @dmns.admit(@tj)
    @dmns.admit(@gabe)
    @dmns.admit(@sally)
    @dmns.admit(@morgan)

    @dmns.stubs(:draw_lottery_winner).returns("TJ")
    assert_equal "TJ has won the IMAX exhibit lottery", @dmns.announce_lottery_winner(@imax)
  end

  def test_it_can_sort_exhibits_by_cost_that_match_a_patrons_interests
    @dmns.admit(@tj)

    assert_equal [@imax, @dead_sea_scrolls], @dmns.recommend_exhibits_by_cost(@tj)
  end

  def test_it_can_admit_patrons_using_spending_money

    # Interested in two exhibits but none in price range
    @dmns.admit(@tj)

    # Interested in two exhibits and only one is in price range
    @dmns.admit(@gabe)

    # Interested in two exhibits and both are in price range, but can only afford one
    @dmns.admit(@sally)

    # Interested in two exhibits and both are in price range, and can afford both
    @dmns.admit(@morgan)

    expected = {
      @gems_and_minerals => [@morgan],
      @imax => [@sally],
      @dead_sea_scrolls => [@gabe, @morgan]
    }
    assert_equal expected, @dmns.patrons_of_exhibits
  end

  def test_patron_spending_money_is_reduced_after_being_admitted

    # Interested in two exhibits but none in price range
    @dmns.admit(@tj)
    assert_equal 7, @tj.spending_money

    # Interested in two exhibits and only one is in price range
    @dmns.admit(@gabe)
    assert_equal 0, @gabe.spending_money

    # Interested in two exhibits and both are in price range, but can only afford one
    @dmns.admit(@sally)
    assert_equal 5, @sally.spending_money

    # Interested in two exhibits and both are in price range, and can afford both
    @dmns.admit(@morgan)
    assert_equal 5, @morgan.spending_money
  end

  def test_it_can_calculate_revenue
    # Interested in two exhibits but none in price range
    @dmns.admit(@tj)

    # Interested in two exhibits and only one is in price range
    @dmns.admit(@gabe)

    # Interested in two exhibits and both are in price range, but can only afford one
    @dmns.admit(@sally)

    # Interested in two exhibits and both are in price range, and can afford both
    @dmns.admit(@morgan)

    assert_equal 35, @dmns.revenue
  end
end
