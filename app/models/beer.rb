class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    self.ratings.average(:score).round(1)
  end

  def to_s
    self.name + " (" + self.brewery.name + ")"
  end
end
