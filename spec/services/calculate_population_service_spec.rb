require 'rails_helper'

RSpec.describe CalculatePopulationService do
  describe '#run' do
    it "returns known population from database" do
      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 1900)
      service.run
      expect(service.calculated_pop).to eq(76212168)

      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 1990)
      service.run
      expect(service.calculated_pop).to eq(248709873)
    end

    it "returns linearly projected population based on surrounding known populations" do
      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 1902)
      service.run
      expect(service.calculated_pop).to eq(79415433)

      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 1908)
      service.run
      expect(service.calculated_pop).to eq(89025230)
    end

    it "returns false for years before earliest known population" do
      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 1800)
      service.run
      expect(service.run).to eq(false)
      expect(service.service_errors[:validation]).to eq ["Year must be greater than 1900"]

      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 0)
      service.run
      expect(service.run).to eq(false)
      expect(service.service_errors[:validation]).to eq ["Year must be greater than 1900"]

      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: -1800)
      service.run
      expect(service.run).to eq(false)
      expect(service.service_errors[:validation]).to eq ["Year must be greater than 1900"]
    end

    it "returns exponentially calculated population after latest known year" do
      service = CalculatePopulationService.new(prediction_model: 'exponential', query_year: 2000)
      service.run
      expect(service.calculated_pop).to eq(588786718)
    end

    it "returns logistic calculated population after latest known year" do
      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 2000)
      service.run
      expect(service.calculated_pop).to eq(412208791)
    end

    it "returns false after year 2500" do
      service = CalculatePopulationService.new(prediction_model: 'logistic', query_year: 2501)
      service.run
      expect(service.run).to eq(false)
      expect(service.service_errors[:validation]).to eq ["Year must be less than 2500"]
    end
  end
end
