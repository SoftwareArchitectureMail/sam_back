class CreateSentMails < ActiveRecord::Migration[5.1]
  def change
    create_table :sent_mails do |t|
      t.string :sender
      t.string :recipient
      t.string :cc
      t.string :distribution_list
      t.string :subject
      t.text :message_body
      t.string :attachment
      t.datetime :sent_date
      t.boolean :draft
      t.boolean :urgent
      t.boolean :confirmation

      t.timestamps
    end
  end
end
