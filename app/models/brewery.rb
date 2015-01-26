class Brewery < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  # validates_inclusion_of :year, :in => 1042..2015

  validate :year_cannot_be_in_the_future
  validate :year_cannot_be_so_old_pls

  def year_cannot_be_in_the_future
    if year > Time.now.year
      errors.add(:year, "can't be in the future")
    end
  end

  def year_cannot_be_so_old_pls
    if year < 1042
      errors.add(:year, "can't be so far away pls")
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{self.year}"
  end
end
