module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?
    average = self.ratings.average(:score)

    if average
      average.round(1)
    else
      0
    end
  end
end