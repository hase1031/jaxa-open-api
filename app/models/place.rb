class Place < ActiveRecord::Base
  def self.getById(id)
    PLACE_CHOICES[id.to_i]
  end
end
