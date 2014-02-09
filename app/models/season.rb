require 'date'

class Season < ActiveRecord::Base
  def self.getPeriod(id)
    seasons = [
      {:from => Date.parse("2013-01-01"), :to => Date.parse("2013-03-31")},
      {:from => Date.parse("2013-04-01"), :to => Date.parse("2013-06-30")},
      {:from => Date.parse("2012-07-01"), :to => Date.parse("2012-09-30")},
      {:from => Date.parse("2012-10-01"), :to => Date.parse("2012-12-31")},
    ]
    seasons[id.to_i - 1]
  end
end
