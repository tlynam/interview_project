class PopulationsController < ApplicationController
  def index
  end

  def show
    @year = params[:year]

    service = CalculatePopulationService.new(
      query_year: @year,
      prediction_model: params[:prediction_model]
    )

    if service.run
      @population = service.calculated_pop

      respond_to do |format|
        format.js
      end
    else
      validation_errors = service.service_errors[:validation]

      @errors = if validation_errors.present?
                  validation_errors.join(". ")
                else
                  'Internal Error Occurred'
                end

      respond_to do |format|
        format.js
      end
    end
  end
end
