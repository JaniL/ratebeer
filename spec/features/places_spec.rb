require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [ Place.new( name:"Oljenkorsi", id: 1 ) ]
                             )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  describe "when multiple beer places found" do
    it "everything is listed" do


      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                   [ Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Olotila", id: 2 ),
                                     Place.new( name:"BK107", id: 3 )]
                               )

      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"

      expect(page).to have_content "Oljenkorsi"
      expect(page).to have_content "Olotila"
      expect(page).to have_content "BK107"
    end
  end

  describe "when no places are found" do
    it "informs about it" do
      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"

      expect(page).to have_content "No locations in kumpula"
    end
  end
end