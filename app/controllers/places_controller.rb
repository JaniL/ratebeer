class PlacesController < ApplicationController
  def index
  end

  def search
    #city = "helsinki"
    url = "http://stark-oasis-9187.herokuapp.com/api/#{ERB::Util.url_encode(params[:city])}"

    response = HTTParty.get url
    places_from_api = response.parsed_response["bmp_locations"]["location"]

    if places_from_api.is_a?(Hash) and places_from_api['id'].nil?
      redirect_to places_path, :notice => "No places in #{params[:city]}"
    else
      places_from_api = [places_from_api] if places_from_api.is_a?(Hash)
      @places = places_from_api.inject([]) do | set, location|
        set << Place.new(location)
      end
      render :index
    end
  end
end
