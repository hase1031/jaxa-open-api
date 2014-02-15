require 'date'
class Season < ActiveRecord::Base
  # int id
  def self.getPeriod(id)
    SEASON_CHOICES[id]
  end
end
