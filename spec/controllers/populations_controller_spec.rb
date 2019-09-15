require 'rails_helper'

RSpec.describe PopulationsController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { year: "1900" }, xhr: true

      expect(response).to have_http_status(:success)
    end

    it "returns a population for a date" do
      year = 1900
      get :show, params: { year: year, prediction_model: 'exponential' }, xhr: true
      expect(response.content_type).to eq "text/javascript"
      expect(response.body).to match /Population: 76212168/im
    end
  end
end
