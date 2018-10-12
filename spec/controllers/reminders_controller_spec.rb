require 'rails_helper'

RSpec.describe RemindersController, type: :controller do
  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  # This should return the minimal set of attributes required to create a valid
  # Reminder. As you add validations to Reminder, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    attributes_for(:reminder)
  }

  let(:invalid_attributes) {
    attributes_for(:reminder, title: nil)
  }

  describe "GET #index" do
    it "returns a success response" do
      create(:reminder, user: @user)
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      reminder = create(:reminder, user: @user)
      get :show, params: {id: reminder.id}
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Reminder" do
        expect {
          post :create, params: {reminder: valid_attributes}
        }.to change(Reminder, :count).by(1)
      end

      it "redirects to the created reminder" do
        post :create, params: {reminder: valid_attributes}
        expect(response).to redirect_to(Reminder.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {reminder: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested reminder" do
      reminder = create(:reminder, user: @user)
      expect {
        delete :destroy, params: {id: reminder.id}
      }.to change(Reminder, :count).by(-1)
    end

    it "redirects to the reminders list" do
      reminder = create(:reminder, user: @user)
      delete :destroy, params: {id: reminder.id}
      expect(response).to redirect_to(reminders_url)
    end
  end

end
