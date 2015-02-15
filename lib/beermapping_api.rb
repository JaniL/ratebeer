class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in:2.hours) { fetch_places_in(city) }
  end

  def self.fetch_bar(city, id)
    bars = places_in(city)
    bars.each { |bar| return bar if bar.id == id.to_s }
  end

  def self.get_coordinates(address)
    Rails.cache.fetch(address, expires_in:48.hours) { fetch_coordinates(address) }
  end

  private

  def self.fetch_coordinates(address)
    coordinates = Geocoder.search(address)
    return nil if coordinates == nil or coordinates[0].data["geometry"]["location"] == nil
    coordinates[0].data["geometry"]["location"]
  end

  def self.fetch_places_in(city)
    url = "http://stark-oasis-9187.herokuapp.com/api/#{ERB::Util.url_encode(city)}"

    response = HTTParty.get url
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end
end