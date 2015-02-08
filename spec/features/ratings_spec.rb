require 'rails_helper'

#include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Arto", password:"M01Arto")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when listing ratings" do
    it "includes amount of ratings" do
      b1 = FactoryGirl.create(:beer, name: "Brooklyn")
      b2 = FactoryGirl.create(:beer, name: "Muumi")

      b1.ratings.create score: 20
      b2.ratings.create score: 10


      visit ratings_path

      expect(page).to have_content "Brooklyn"
      expect(page).to have_content "Muumi"
      expect(page).to have_content "Number of ratings: #{Rating.count}"
    end
  end

  describe "when listing user's ratings" do
    it "lists user's ratings" do
      user.ratings.create beer: beer1, score: 2
      user.ratings.create beer: beer2, score: 40

      visit user_path user

      expect(page).to have_content beer1.name
      expect(page).to have_content beer2.name

    end

    it "doesn't list other users/orphan ratings" do
      Rating.create beer: beer1, score: 5

      visit user_path user

      expect(page).not_to have_content beer1.name
    end
  end
end