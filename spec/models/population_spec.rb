require 'rails_helper'

RSpec.describe Population, type: :model do
  describe '.get' do
    it "returns known population from database" do
      expect(Population.get(year: 1900)).to eq(76212168)
      expect(Population.get(year: 1990)).to eq(248709873)
    end

    it "returns linearly projected population based on surrounding known populations" do
      expect(Population.get(year: 1902)).to eq(79415433.6)
      expect(Population.get(year: 1908)).to eq(89025230.4)
    end

    it "returns zero for years before earliest known population" do
      expect(Population.get(year: 1800)).to eq(0)
      expect(Population.get(year: 0)).to eq(0)
      expect(Population.get(year: -1000)).to eq(0)
    end

    it "returns exponentially calculated population after latest known year" do
      expect(Population.get(year: 2000)).to eq(588786718)
    end

    it "returns 0 after year 2500" do
      expect(Population.get(year: 2501)).to eq(0)
    end
  end

  describe ".calc_population" do
    it "returns population based on 9% exponential growth after last known year" do
      result = Population.calc_population(
        base_population: 248709873,
        base_year: 1990,
        query_year: 2100
      )

      expect(result).to eq 3255425786221
    end
  end
end
