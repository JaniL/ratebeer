module RatingAverage
  def average_rating
    self.ratings.average(:score).round(1)
  end
end