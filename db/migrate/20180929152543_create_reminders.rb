class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :description
      t.datetime :time
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
