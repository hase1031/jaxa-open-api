class Place < ActiveRecord::Base
  # int id
  def self.getById(id)
    {
      :id => PLACE_CHOICES[id][:place_id],
      :lat => PLACE_CHOICES[id][:lat] * 10,
      :lon => PLACE_CHOICES[id][:lon] * 10,
      :place_name => PLACE_CHOICES[id][:place_name]
    }
  end
end
