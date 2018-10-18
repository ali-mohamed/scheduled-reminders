require "rails_helper"

feature 'Create new reminder' do
  background do
    @user = create(:user)
  end

  background do
    visit new_reminder_path
    fill_in 'Email', with: @user.email, match: :first
    fill_in 'Password', with: @user.password, match: :first
    click_button 'Log in'
    @reminder = build(:reminder)
  end

  context 'successfully' do
    before(:each) do
      fill_in 'Title', with: @reminder.title
      fill_in 'Description', with: @reminder.description
      select_time @reminder.time, from: 'reminder_time'
    end

    scenario 'shows the reminder page' do
      expect {
        click_button 'Submit'
      }.to change(Reminder, :count).by(1)
      expect(page).to have_text 'Reminder was successfully created.'
      expect(page).to have_text @reminder.title
      expect(page).to have_text @reminder.description
      expect(page).to have_text @reminder.time.beginning_of_minute
    end

    scenario 'sends a reminder to the user' do
      click_button 'Submit'
      travel_to @reminder.time do
        expect {
          Delayed::Worker.new.work_off
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    scenario 'sends a reminder every month' do
      click_button 'Submit'
      travel_to @reminder.time do
        Delayed::Worker.new.work_off
      end

      travel_to @reminder.time + 1.month do
        expect {
          Delayed::Worker.new.work_off
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

  context "unsuccessfully" do
    before(:each) do
      select_time @reminder.time, from: 'reminder_time'
    end

    scenario 'with no title' do
      fill_in 'Description', with: @reminder.description

      expect {
        click_button 'Submit'
      }.to change(Reminder, :count).by(0)
      expect(page).to have_text "Title can't be blank"
    end

    scenario 'with no description' do
      fill_in 'Title', with: @reminder.title

      expect {
        click_button 'Submit'
      }.to change(Reminder, :count).by(0)
      expect(page).to have_text "Description can't be blank"
    end
  end
end
