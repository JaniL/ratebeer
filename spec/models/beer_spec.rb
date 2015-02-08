require 'rails_helper'

RSpec.describe Beer, type: :model do

  describe "with a valid name and style set" do
    let(:beer){ Beer.create name:"Brooklyn Ale", style:"Pale Ale" }

    it "is valid" do
      expect(beer).to be_valid
    end

    it "is saved" do
      expect(beer.persisted?).to eq(true)
    end
  end

  describe "with no name set" do
    let(:beer){ Beer.create style:"Pale Ale" }

    it "is not valid" do
      expect(beer).not_to be_valid
    end

    it "is not saved" do
      expect(beer.persisted?).to eq(false)
    end
  end

  describe "with no style set" do
    let(:beer){ Beer.create name:"Brooklyn Ale" }

    it "is not valid" do
      expect(beer).not_to be_valid
    end

    it "is not saved" do
      expect(beer.persisted?).to eq(false)
    end
  end
end
