class Style < ActiveRecord::Base
  validates_uniqueness_of :name

  has_many :beers

  def to_s
    self.name
  end

  def average_rating
    ratings = []
    beers.each do |b|
      b.ratings do |e|
        ratings.push(e)
      end
    end
    return 0 if ratings.empty?
    average = self.ratings.average(:score)

    if average
      average.round(1)
    else
      0
    end
  end
end
