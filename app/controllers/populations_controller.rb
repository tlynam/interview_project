class PopulationsController < ApplicationController
  def index
  end

  def show
    @year = params[:year]

    service = CalculatePopulationService.new(query_year: @year)

    if service.run
      @population = service.calculated_pop

      respond_to do |format|
        format.js
      end
    else
      @service_errors = service.service_errors

      respond_to do |format|
        format.js
      end
    end
  end
end
