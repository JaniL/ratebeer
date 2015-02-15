class Style < ActiveRecord::Base
  validates_uniqueness_of :name

  has_many :beers

  def to_s
    self.name
  end
end
