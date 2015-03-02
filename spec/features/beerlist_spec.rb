require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    beers = find('table').all('tr')
    dbBeers = Beer.all().order('name')
    (0..beers.size-2).each do |n|
      expect(beers[n+1].text).to eq(dbBeers[n].name + ' ' + dbBeers[n].style.name + ' ' + dbBeers[n].brewery.name)
    end
  end

  it "shows beers in alphabetical order based on style", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    find('a#style').click
    beers = find('table').all('tr')
    #byebug
    dbBeers = Beer.all().sort_by{ |b| b.style.name }
    (0..beers.size-2).each do |n|
      expect(beers[n+1].text).to eq(dbBeers[n].name + ' ' + dbBeers[n].style.name + ' ' + dbBeers[n].brewery.name)
    end
  end

  it "shows beers in alphabetical order based on brewery", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    find('a#brewery').click
    beers = find('table').all('tr')
    #byebug
    dbBeers = Beer.all().sort_by{ |b| b.brewery.name }
    (0..beers.size-2).each do |n|
      expect(beers[n+1].text).to eq(dbBeers[n].name + ' ' + dbBeers[n].style.name + ' ' + dbBeers[n].brewery.name)
    end
  end
end