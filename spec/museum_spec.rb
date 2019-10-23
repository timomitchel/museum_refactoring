require 'rspec'
require 'pry'
require 'simplecov'
SimpleCov.start
require './lib/exhibit'
require './lib/patron'
require './lib/museum'

RSpec.configure do |config|
  config.default_formatter = 'doc'
end

RSpec.describe 'museum spec' do
  before :each do
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 0)
    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @imax = Exhibit.new("IMAX", 15)
    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
    @dmns = Museum.new("Denver Museum of Nature and Science")
  end

  describe 'Iteration 1' do
    it '1. Exhibit ::new' do
      expect(Exhibit).to respond_to(:new).with(2).argument
      expect(@dead_sea_scrolls).to be_an_instance_of(Exhibit)
    end

    it '2. Exhibit #name' do
      expect(@dead_sea_scrolls).to respond_to(:name).with(0).argument
      expect(@dead_sea_scrolls.name).to eq('Dead Sea Scrolls')
    end

    it '3. Exhibit #cost' do
      expect(@dead_sea_scrolls).to respond_to(:cost).with(0).argument
      expect(@dead_sea_scrolls.cost).to eq(0)
    end

    it '4. Patron ::new' do
      expect(Patron).to respond_to(:new).with(2).argument
      expect(@bob).to be_an_instance_of(Patron)
    end

    it '5. Patron #name' do
      expect(@bob).to respond_to(:name).with(0).argument
      expect(@bob.name).to eq('Bob')
    end

    it '6. Patron #spending_money' do
      expect(@bob).to respond_to(:spending_money).with(0).argument
      expect(@bob.spending_money).to eq(20)
    end

    it '7. Patron #interests' do
      expect(@bob).to respond_to(:interests).with(0).argument
      expect(@bob.interests).to eq([])
    end

    it '8. Patron #add_interest' do
      expect(@bob).to respond_to(:add_interest).with(1).argument
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Gems and Minerals")
      expect(@bob.interests).to eq(["Dead Sea Scrolls", "Gems and Minerals"])
    end
  end

  describe 'Iteration 2' do
    before :each do
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Gems and Minerals")
      @sally.add_interest("IMAX")
    end

    it '1. Museum ::new' do
      expect(Museum).to respond_to(:new).with(1).argument
      expect(@dmns).to be_an_instance_of(Museum)
    end

    it '2. Museum #name' do
      expect(@dmns).to respond_to(:name).with(0).argument
      expect(@dmns.name).to eq('Denver Museum of Nature and Science')
    end

    it '3. Museum #exhibits' do
      expect(@dmns).to respond_to(:exhibits).with(0).argument
      expect(@dmns.exhibits).to eq([])
    end

    it '4. Museum #add_exhibit' do
      expect(@dmns).to respond_to(:add_exhibit).with(1).argument
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@gems_and_minerals)
      expect(@dmns.exhibits).to eq([@dead_sea_scrolls, @gems_and_minerals])
    end

    it '5. Museum #recommend_exhibits' do
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      expect(@dmns).to respond_to(:recommend_exhibits).with(1).argument
      expect(@dmns.recommend_exhibits(@bob)).to eq([@dead_sea_scrolls, @gems_and_minerals])
      expect(@dmns.recommend_exhibits(@sally)).to eq([@imax])
    end
  end

  describe 'Iteration 3' do
    before :each do
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("Gems and Minerals")
      @sally.add_interest("Dead Sea Scrolls")
    end

    it '1. Museum #patrons' do
      expect(@dmns).to respond_to(:patrons).with(0).argument
      expect(@dmns.patrons).to eq([])
    end

    it '2. Museum #admit' do
      expect(@dmns).to respond_to(:admit).with(1).argument
      @dmns.admit(@bob)
      @dmns.admit(@sally)
      expect(@dmns.patrons).to eq([@bob, @sally])
    end

    it '3. Museum #patrons_by_exhibit_interest' do
      @dmns.admit(@bob)
      @dmns.admit(@sally)
      expected = {
        @dead_sea_scrolls => [@bob, @sally],
        @gems_and_minerals => [@bob],
        @imax => [],
      }
      expect(@dmns).to respond_to(:patrons_by_exhibit_interest).with(0).argument
      expect(@dmns.patrons_by_exhibit_interest).to eq(expected)
    end
  end

  describe 'Iteration 4' do
    before :each do
      @dmns = Museum.new("Denver Museum of Nature and Science")
      @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
      @imax = Exhibit.new("IMAX", 15)
      @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      @dmns.add_exhibit(@dead_sea_scrolls)

      # Interested in two exhibits but none in price range
      @tj = Patron.new("TJ", 7)
      @tj.add_interest("IMAX")
      @tj.add_interest("Dead Sea Scrolls")
      @dmns.admit(@tj)

      # Interested in two exhibits and only one is in price range
      @bob = Patron.new("Bob", 10)
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("IMAX")
      @dmns.admit(@bob)

      # Interested in two exhibits and both are in price range, but can only afford one
      @sally = Patron.new("Sally", 20)
      @sally.add_interest("IMAX")
      @sally.add_interest("Dead Sea Scrolls")
      @dmns.admit(@sally)

      # Interested in two exhibits and both are in price range, and can afford both
      @morgan = Patron.new("Morgan", 15)
      @morgan.add_interest("Gems and Minerals")
      @morgan.add_interest("Dead Sea Scrolls")
      @dmns.admit(@morgan)
    end

    it '1. Museum #patrons_of_exhibits' do
      expected = {
        @gems_and_minerals => [@morgan],
        @dead_sea_scrolls => [@bob, @morgan],
        @imax => [@sally]
      }
      expect(@dmns).to respond_to(:patrons_of_exhibits).with(0).argument
      expect(@dmns.patrons_of_exhibits).to eq(expected)
    end

    it '2. Museum #admit reduces spending money' do
      expect(@tj.spending_money).to eq(7)
      expect(@bob.spending_money).to eq(0)
      expect(@sally.spending_money).to eq(5)
      expect(@morgan.spending_money).to eq(5)
    end

    it '3. Museum #revenue' do
      expect(@dmns).to respond_to(:revenue).with(0).argument
      expect(@dmns.revenue).to eq(35)
    end
  end
end
