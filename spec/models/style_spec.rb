require 'rails_helper'

RSpec.describe Style, type: :model do
  describe "when saving a style" do
    it "has a name" do

      name = "lowalco"
      style = Style.create name: name

      expect(style.name).to eq(name)


    end
  end
end
