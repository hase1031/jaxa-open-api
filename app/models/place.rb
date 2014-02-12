class Place < ActiveRecord::Base
  def self.getById(id)
    {
      :id => PLACE_CHOICES[id.to_i][:place_id],
      :lat => PLACE_CHOICES[id.to_i][:lat] * 10,
      :lon => PLACE_CHOICES[id.to_i][:lon] * 10,
      :place_name => PLACE_CHOICES[id.to_i][:place_name]
    }
  end
end
