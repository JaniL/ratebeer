class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :password, length: { minimum: 4}
  validates_format_of :password, :with => /.*(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*/, message: "doesn't contain at least one uppercase character and/or a number."

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if (ratings.empty?)
    tyylit = ratings.group_by { |i| i.beer.style }.keys
    tyylit.max_by{|style| get_average_for_style style}
  end

  def favorite_brewery
    return nil if ratings.empty?

    panimot = ratings.group_by { |i| i.beer.brewery }.keys
    panimot.max_by{|brewery| get_average_for_brewery brewery}

  end

  def get_average_for_brewery(brewery)
    return nil if (ratings.empty?)
    ratings_for_brewery = ratings.select{|x| x.beer.brewery == brewery}
    return nil if (ratings_for_brewery.size == 0)
    ratings_for_brewery.map(&:score).inject{ |sum, el| sum + el }.to_f / ratings_for_brewery.size
    #byebug
  end

  def get_average_for_style style
    return nil if (ratings.empty?)
    ratings_for_style = ratings.select{|x| x.beer.style == style}
    return nil if (ratings_for_style.size == 0)
    ratings_for_style.map(&:score).inject{ |sum, el| sum + el }.to_f / ratings_for_style.size
  end
end
