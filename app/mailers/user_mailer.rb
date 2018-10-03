class UserMailer < ApplicationMailer
  def reminder
    @reminder = params[:reminder]
    mail(to: @reminder.user.email, subject: "[Reminder :)] #{@reminder.title}")
  end
end
