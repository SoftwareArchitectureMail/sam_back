# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
20.times do
SentMail.create(
  sender: 'janoguerab',
  recipient: Faker::Name.first_name,
  cc: Faker::Name.first_name,
  distribution_list: '',
  subject: Faker::Lorem.sentence,
  message_body: Faker::Lorem.paragraph,
  attachment: '',
  sent_date: Faker::Date.between(2.days.ago, 5.days.after),
  draft: Faker::Boolean.boolean,
  urgent:Faker::Boolean.boolean,
  confirmation: Faker::Boolean.boolean
)
end
