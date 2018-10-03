class Reminder < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :description, :time, :user

  after_create :send_reminder_and_schedule_next


  def send_reminder_and_schedule_next
    UserMailer.with(reminder: self).reminder.deliver_now

    months_since_first_delivered = ((Time.current - time) / 1.month).round
    next_delivery_time = time + (months_since_first_delivered + 1).month
    delay(run_at: next_delivery_time).send_reminder_and_schedule_next
  end
  handle_asynchronously :send_reminder_and_schedule_next, run_at: proc { |r| r.time }
end
