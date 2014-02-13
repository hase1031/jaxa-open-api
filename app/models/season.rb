require 'date'
class Season < ActiveRecord::Base
  def self.getPeriod(id)
    SEASON_CHOICES[id.to_i]
  end
end
