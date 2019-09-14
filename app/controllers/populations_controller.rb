class PopulationsController < ApplicationController
  def index
  end

  def show
    @year = params[:year]
    @population = Population.get(year: @year)

    respond_to do |format|
      format.js
    end
  end
end
