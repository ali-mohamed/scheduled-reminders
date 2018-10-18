require "rails_helper"

feature 'Show existing reminders' do
  background do
    @user = create(:user)
    @reminders = create_list(:reminder, 2, user: @user)
    @other_reminders = create_list(:reminder, 2)
  end

  background do
    visit reminders_path
    fill_in 'Email', with: @user.email, match: :first
    fill_in 'Password', with: @user.password, match: :first
    click_button "Log in"
  end

  scenario 'shows current user reminders' do
    expect(page).to have_text @reminders.first.title
    expect(page).to have_text @reminders.second.title
  end

  scenario 'does not show other users reminders' do
    expect(page).not_to have_text @other_reminders.first.title
    expect(page).not_to have_text @other_reminders.second.title
  end
end
