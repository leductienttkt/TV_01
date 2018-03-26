require "rails_helper"

RSpec.describe Employer::TeamsController, type: :controller do
  let(:admin){FactoryGirl.create :user, role: 1}
  let(:company){FactoryGirl.create :company}
  let!(:team){FactoryGirl.create :team, company_id: company.id}

  before :each do
    allow(controller).to receive(:current_user).and_return admin
    sign_in admin
    request.env["HTTP_REFERER"] = "sample_path"
  end

  describe "GET #index" do
    it "populates an array of team" do
      get :index, params: {company_id: company}
      expect(assigns(:teams)).to include team
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "POST #create team" do
    it "create community team successfully" do
      team_params = FactoryGirl.attributes_for :team
      expect do
        post :create, params: {company_id: company, team: team_params}
      end.to change(Team, :count).by 1
      expect(flash[:success]).to be_present
    end
    it "create fail with name nil" do
      team_params = FactoryGirl.attributes_for :team, name: nil
      expect do
        post :create, params: {company_id: company, team: team_params}
      end.to change(Job, :count).by 0
      expect(flash[:danger]).to be_present
    end
  end

  describe "GET #new" do
    it "renders the :new template" do
      get :new, params: {company_id: company.id}
      expect(response).to render_template :new
    end
  end

  describe "PUT #update" do
    it "update successfully" do
      team_params = FactoryGirl.attributes_for :team, name: "something"
      put :update, params: {company_id: company, id: team, team: team_params}
      team.reload
      expect(team.name).to eq "something"
    end
  end

  describe "DELETE #destroy" do
    context "delete successfully" do
      before{delete :destroy, params: {company_id: company, id: team}}
      it{expect{response.to change(Team, :count).by -1}}
    end
  end
end
