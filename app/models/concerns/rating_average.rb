module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return nil if ratings.empty?
    average = self.ratings.average(:score)

    if average
      average.round(1)
    else
      nil
    end
  end
end