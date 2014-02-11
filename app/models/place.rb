class Place < ActiveRecord::Base
  def self.getById(id)
    places = [
      {:lat => -340, :lon => 1513},
      {:lat => 70, :lon => -730},
      {:lat => 238, :lon => 113},
      {:lat => 310, :lon => -1000},
      {:lat => 390, :lon => 1410},
      {:lat => 437, :lon => 399},
      {:lat => 516, :lon => 2},
      {:lat => 611, :lon => 992},
      {:lat => 694, :lon => 884}
    ]
    places[id.to_i - 1]
  end
end
