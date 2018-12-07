# Museum

## Instructions

* Fork this Repository
* Clone your forked repo to your computer.
* Complete the activity below.
* Push your solution to your forked repo
* Submit a pull request from your repository to this repository
  * Put your name in your PR!

### Iteration 1

Use TDD to create an `Exhibit` and a `Patron` class that respond to the following interaction pattern:

```ruby
pry(main)> require './lib/exhibit'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> exhibit = Exhibit.new("Gems and Minerals", 0)    
# => #<Exhibit:0x00007fcb13bd22d0...>

pry(main)> exhibit.name
# => "Gems and Minerals"

pry(main)> exhibit.cost
# => 0

pry(main)> bob = Patron.new("Bob", 20)    
# => #<Patron:0x00007fcb13b5c7d8...>

pry(main)> bob.name
# => "Bob"

pry(main)> bob.spending_money
# => 20

pry(main)> bob.interests
# => []

pry(main)> bob.add_interest("Dead Sea Scrolls")    

pry(main)> bob.add_interest("Gems and Minerals")    

pry(main)> bob.interests
# => ["Dead Sea Scrolls", "Gems and Minerals"]
```

## Iteration 2

Use TDD to create a `Museum` class that responds to the following interaction pattern. For the `recommend_exhibits` method, the `Museum` should recommend exhibits that match a `Patron`'s interests.

```ruby
pry(main)> require './lib/museum'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> require './lib/exhibit'
# => true

pry(main)> dmns = Museum.new("Denver Museum of Nature and Science")    
# => #<Museum:0x00007fb400a6b0b0...>

pry(main)> dmns.name
# => "Denver Museum of Nature and Science"

pry(main)> dmns.exhibits
# => []

pry(main)> gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
# => #<Exhibit:0x00007fb400bbcdd8...>

pry(main)> dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)    
# => #<Exhibit:0x00007fb400b851f8...>

pry(main)> imax = Exhibit.new("IMAX", 15)    
# => #<Exhibit:0x00007fb400acc590...>

pry(main)> dmns.add_exhibit(gems_and_minerals)    

pry(main)> dmns.add_exhibit(dead_sea_scrolls)    

pry(main)> dmns.add_exhibit(imax)

pry(main)> dmns.exhibits
# => [#<Exhibit:0x00007fb400bbcdd8...>, #<Exhibit:0x00007fb400b851f8...>]

pry(main)> bob = Patron.new("Bob", 20)    
# => #<Patron:0x00007fb400a51cc8...>

pry(main)> bob.add_interest("Dead Sea Scrolls")    

pry(main)> bob.add_interest("Gems and Minerals")    

pry(main)> sally = Patron.new("Sally", 20)
# => #<Patron:0x00007fb400036338...>

pry(main)> sally.add_interest("IMAX")    

pry(main)> dmns.recommend_exhibits(bob)
# => [#<Exhibit:0x00007fb400bbcdd8...>, #<Exhibit:0x00007fb400b851f8...>]

pry(main)> dmns.recommend_exhibits(sally)
# => [#<Exhibit:0x00007fb400acc590...>]
```

## Iteration 3

Use TDD to update your `Museum` class so that it responds to the following interaction pattern.

For `patrons_by_exhibit_interest`, this method takes no arguments and returns a Hash where each key is an Exhibit. The value associated with that Exhibit is an Array of all the Patrons that have an interest in that exhibit.

```ruby
pry(main)> require './lib/museum'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> require './lib/exhibit'
# => true

pry(main)> dmns = Museum.new("Denver Museum of Nature and Science")    
# => #<Museum:0x00007fb20205d690...>

pry(main)> gems_and_minerals = Exhibit.new("Gems and Minerals", 0)    
# => #<Exhibit:0x00007fb202238618...>

pry(main)> dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)    
# => #<Exhibit:0x00007fb202248748...>

pry(main)> imax = Exhibit.new("IMAX", 15)    
# => #<Exhibit:0x00007fb20225f8d0...>

pry(main)> dmns.add_exhibit(gems_and_minerals)    

pry(main)> dmns.add_exhibit(dead_sea_scrolls)    

pry(main)> dmns.add_exhibit(imax)    

pry(main)> dmns.patrons
# => []

pry(main)> bob = Patron.new("Bob", 20)
# => #<Patron:0x00007fb2011455b8...>

pry(main)> bob.add_interest("Dead Sea Scrolls")    

pry(main)> bob.add_interest("Gems and Minerals")    

pry(main)> sally = Patron.new("Sally", 20)    
# => #<Patron:0x00007fb20227f8b0...>

pry(main)> sally.add_interest("Dead Sea Scrolls")    

pry(main)> dmns.admit(bob)

pry(main)> dmns.admit(sally)    

pry(main)> dmns.patrons
# => [#<Patron:0x00007fb2011455b8...>, #<Patron:0x00007fb20227f8b0...>]

pry(main)> dmns.patrons_by_exhibit_interest
# =>
# {
#   #<Exhibit:0x00007fb202238618...> => [#<Patron:0x00007fb2011455b8...>],
#   #<Exhibit:0x00007fb202248748...> => [#<Patron:0x00007fb2011455b8...>, #<Patron:0x00007fb20227f8b0...>],
#   #<Exhibit:0x00007fb20225f8d0...> => []
# }
```

## Iteration 4

Use TDD to update your `Museum` class to add the following functionality:

* When a `Patron` is admitted to the `Museum`, they attend `Exhibits`. The `Exhibits` that a `Patron` attends follows these rules:
  * A Patron will only attend `Exhibits` they are interested in
  * A Patron will attend an `Exhibit` with a higher cost before an `Exhibit` with a lower cost.
  * If a `Patron` does not have enough `spending_money` to cover the cost of the `Exhbit`, they will not attend the `Exhibit`.
  * When the Patron attends an `Exhibit`, the cost of the `Exhibit` should be subtracted from their `spending_money` and added to the `Museum` revenue.
* A `Museum` should have a `patrons_of_exhibits` method that returns a Hash where the keys are the exhibits and the values are Arrays containing all the `Patrons` that attended that `Exhibit`.
* A `Museum` should have a method `revenue` that returns an Integer representing the revenue collected from `Patrons` attending `Exhibits`.

The `Museum` class should respond to the following interaction pattern:

```ruby
pry(main)> require './lib/museum'
# => true

pry(main)> require './lib/patron'
# => true

pry(main)> require './lib/exhibit'
# => true

pry(main)> dmns = Museum.new("Denver Museum of Nature and Science")
# => #<Museum:0x00007f90182546f8...>

pry(main)> gems_and_minerals = Exhibit.new("Gems and Minerals", 0)    
# => #<Exhibit:0x00007f9018a51248...>

pry(main)> imax = Exhibit.new("IMAX", 15)    
# => #<Exhibit:0x00007f9018a596c8...>

pry(main)> dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)    
# => #<Exhibit:0x00007f9019879be0...>

pry(main)> dmns.add_exhibit(gems_and_minerals)    

pry(main)> dmns.add_exhibit(imax)    

pry(main)> dmns.add_exhibit(dead_sea_scrolls)    

# This Patron is interested in two exhibits but none in their price range, so they attend none
pry(main)> tj = Patron.new("TJ", 7)    
# => #<Patron:0x00007f901825d9d8...>

pry(main)> tj.add_interest("IMAX")    

pry(main)> tj.add_interest("Dead Sea Scrolls")    

pry(main)> dmns.admit(tj)    

pry(main)> tj.spending_money
# => 7

# This Patron is interested in two exhibits and only Dead Sea Scrolls
# is in their price range price, so they attend Dead Sea Scrolls
pry(main)> bob = Patron.new("Bob", 10)    
# => #<Patron:0x00007f9018048be8...>

pry(main)> bob.add_interest("Dead Sea Scrolls")    

pry(main)> bob.add_interest("IMAX")    

pry(main)> dmns.admit(bob)    

pry(main)> bob.spending_money
# => 0

# This Patron is interested in two exhibits and both are in their price range.
# They attend the more expensive one first (IMAX), but don't have enough money to attend
# the second one    
pry(main)> sally = Patron.new("Sally", 20)    
# => #<Patron:0x00007f901823c8a0...>

pry(main)> sally.add_interest("IMAX")    

pry(main)> sally.add_interest("Dead Sea Scrolls")    

pry(main)> dmns.admit(sally)

pry(main)> sally.spending_money
# => 5

# This Patron is interested in two exhibits and both are in their price range.
# They have enough spending money to afford both, so they attend both.
pry(main)> morgan = Patron.new("Morgan", 15)    
# => #<Patron:0x00007f90180e0948...>

pry(main)> morgan.add_interest("Gems and Minerals")    

pry(main)> morgan.add_interest("Dead Sea Scrolls")    

pry(main)> dmns.admit(morgan)  

pry(main)> morgan.spending_money
# => 5

pry(main)> dmns.patrons_of_exhibits
# =>
# {
#   #<Exhibit:0x00007f9019879be0...> => [#<Patron:0x00007f9018048be8...>, <Patron:0x00007f90180e0948...>],
#   #<Exhibit:0x00007f9018a596c8...> => [#<Patron:0x00007f901823c8a0...>],
#   #<Exhibit:0x00007f9018a51248...> => [#<Patron:0x00007f90180e0948...>]
# }

pry(main)> dmns.revenue
# => 35
```
