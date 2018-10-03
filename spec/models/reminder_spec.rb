require 'rails_helper'

RSpec.describe Reminder, type: :model do
  subject { build(:reminder) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:time) }

  it 'triggers send_reminder_and_schedule_next on create' do
    expect(subject).to receive(:send_reminder_and_schedule_next)
    subject.save
  end

  it '#send_reminder_and_schedule_next' do
    subject.save

    travel_to subject.time do
      expect {
        Delayed::Worker.new.work_off
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    travel_to subject.time + 1.month do
      expect {
        Delayed::Worker.new.work_off
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
