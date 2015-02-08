require 'rails_helper'

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_and_style(score, style, user)
  beer = FactoryGirl.create(:beer, style: style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

RSpec.describe User, type: :model do

  it "has the username set correctly" do
    user = User.new username:"Arto"

    expect(user.username).to eq("Arto")
  end

  it "is not saved without a password" do
    user = User.create username:"Arto"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated if only one rating" do
      beer = create_beer_with_rating(10,user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average style rating if several rated" do
      create_beer_with_rating_and_style(2,"Gangnam",user)
      create_beer_with_rating_and_style(4,"Gangnam",user)
      create_beer_with_rating_and_style(8,"Ipa",user)
      create_beer_with_rating_and_style(12,"Ipa",user)

      expect(user.favorite_style).to eq("Ipa")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery)
      beer = FactoryGirl.create(:beer, brewery: brewery)

      user.ratings.create beer: beer, score: 49

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with the highest average brewery rating if several rated" do
      brewery1 = FactoryGirl.create(:brewery, name: "rt0")
      brewery2 = FactoryGirl.create(:brewery, name: "0ge")

      beer1 = FactoryGirl.create(:beer, name: "Muumi-olut", brewery: brewery1)
      beer2 = FactoryGirl.create(:beer, name: "Smurffi-olut", brewery: brewery2)

      beer1.ratings.create user: user, score: 49
      beer1.ratings.create user: user, score: 45

      beer2.ratings.create user: user, score: 5
      beer2.ratings.create user: user, score: 7

      expect(user.favorite_brewery).to eq(brewery1)
    end
  end

  describe "with a too short username" do
    let(:user){ User.create username:"Arto", password:"ab", password_confirmation:"ab" }

    it "is not valid" do
      expect(user).not_to be_valid
    end

    it "is not saved" do
      expect(user.persisted?).to eq(false)
    end
  end

  describe "with a username only containing a-z letters" do
    let(:user){ User.create username:"Arto", password:"azazazazazazazaza", password_confirmation:"azazazazazazazaza" }

    it "is not valid" do
      expect(user).not_to be_valid
    end

    it "is not saved" do
      expect(user.persisted?).to eq(false)
    end
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
