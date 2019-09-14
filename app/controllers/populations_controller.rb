class PopulationsController < ApplicationController
  def index
  end

  def show
    @year = params[:year].html_safe
    @population = Population.get(year: @year)
  end
end
