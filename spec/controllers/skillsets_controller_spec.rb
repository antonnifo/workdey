require "rails_helper"

RSpec.describe SkillsetsController, type: :controller do
  user_attr = { user_type: "taskee", has_taken_quiz: true }

  let(:user) { create(:user, user_attr) }

  before(:each) do
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    before(:each) { get :index }

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    it "return a status code of 200" do
      expect(response.status).to eq(200)
    end

    it "assigns current_user skillset to @skillset" do
      skillsets = user.skillsets
      expect(assigns(:skillsets)).to eq(skillsets)
    end
  end

  describe "POST #create" do
    before(:each) do
      @skillset = create(:skillset)
      user.skillsets << @skillset
    end

    context "when the skillset exists" do
      it "should find a skillset" do
        post :create, skillset: { name: @skillset.name }, format: :js
        expect(assigns(:skillset).id).to eq(@skillset.id)
      end
    end

    context "when the skillset does not exist" do
      it "should create a skillset" do
        expect do
          post :create, skillset: { name: Faker::Name.name }, format: :js
        end.to change(Skillset, :count).by(1)
      end
    end
  end

  describe "DELETE #destroy" do
    it "should delete a skillset" do
      skillset = create(:skillset)
      user.skillsets << skillset
      expect do
        delete :destroy, skillset_id: skillset.id, format: :js
      end.to change(user.skillsets, :count).by(-1)
    end
  end
end
