require "rails_helper"

RSpec.describe JobsController, type: :controller do
  let(:user){FactoryGirl.create :user, role: 1}
  let!(:job){FactoryGirl.create :job}

  describe "GET #index" do
    before :each do
      get :index
      expect(response).to have_http_status :success
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #show/:id" do
    it "job not found" do
      get :show, params: {id: 999}
      expect(response).to have_http_status(404)
    end

    it "job found" do
      get :show, params: {id: job.id}
      expect(response).to render_template :show
    end
  end
end
