require 'rails_helper'

describe "Beer" do
  before :each do
    sign_in(username:"Arto", password:"M01Arto")
  end

  describe "when adding a beer with valid name" do
    it "gets saved" do
      #FactoryGirl.create(:beer, name: "Muumi")

      visit new_beer_path
      fill_in('beer[name]', with:"Muumi")

      expect{
        click_button "Create Beer"
      }.to change{Beer.count}.from(0).to(1)
    end
  end


  describe "when adding a beer with unvalid name" do
    it "doesn't get saved" do
      #FactoryGirl.create(:beer, name: "Muumi")

      visit new_beer_path
      #fill_in('beer[name]', with:"")

      click_button "Create Beer"

      expect(Beer.count).to eq(0)
    end
  end
end