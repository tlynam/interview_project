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

    it "returns last known population that is after latest known" do
      expect(Population.get(year: 2000)).to eq(248709873)
      expect(Population.get(year: 200000)).to eq(248709873)
    end
  end
end
