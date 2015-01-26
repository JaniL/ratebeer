class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15 }

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :password, length: { minimum: 4}
  validates_format_of :password, :with => /[A-Z\d]/, message: "doesn't contain at least one uppercase character and/or a number."
end
