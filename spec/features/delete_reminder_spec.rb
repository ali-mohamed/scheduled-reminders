require "rails_helper"

feature 'Delete existing reminder' do
  background do
    @user = create(:user)
    @reminder = create(:reminder, user: @user)
  end

  background do
    visit reminder_path(@reminder)
    fill_in 'Email', with: @user.email, match: :first
    fill_in 'Password', with: @user.password, match: :first
    click_button 'Log in'
  end

  scenario 'successfully' do
    expect {
      click_link 'Destroy'
    }.to change(Reminder, :count).by(-1)
    expect(page).to have_text 'Reminder was successfully destroyed.'

    travel_to @reminder.time do
      expect {
        Delayed::Worker.new.work_off
      }.to change(ActionMailer::Base.deliveries, :count).by(0)
    end
  end
end
