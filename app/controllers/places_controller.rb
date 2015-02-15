class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_city] = params[:city].downcase
      render :index, notice: "No locations in #{params[:city]}"
    end
  end

  def show
    @bar = BeermappingApi.fetch_bar(session[:last_city],params[:id])
    @coordinates = BeermappingApi.get_coordinates(@bar.street + ' ' + @bar.zip + ' ' + @bar.city) unless @bar == nil
  end
end
