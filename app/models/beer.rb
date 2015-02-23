class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  scope :mostRated, -> { all().sort_by{|b| b.average_rating}.reverse().take(5) }

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    self.name + " (" + self.brewery.name + ")"
  end
end
