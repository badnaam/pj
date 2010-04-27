namespace :pop do

    desc "Fills the user table with dummy data"
    task :populate_users => :environment do
        require 'populator'
        require 'faker'
        User.populate 12 do |user|
            user.username = Populator.words(3..8)
            user.password = "t"
            user.password_confirmation = "t"
            user.email = Faker::Internet.email
            user.active = true
        end
    end

    desc "Fills event table with dummy data"
    task :populate_events => :environment do
        require 'populator'
        require 'faker'
        Event.populate 50 do |event|
            event.title = Populator.words(1..20).titleize
            event.description = Faker::Lorem.paragraph(5)
            event.event_date = Time.now..1.year.from_now
            event.main_contact_name = Populator.words(4..20).titleize
            event.main_contact_number = Faker::PhoneNumber.phone_number()
            event.details = Faker::Lorem.paragraph(2)
            event.user_id = 3..15

            Address.populate 1 do |address|
                address.street1 = Faker::Address.street_address
                address.city = Faker::Address.city
                address.state = Faker::Address.us_state_abbr
                address.zip = Faker::Address.zip_code
                address.addressible_id = event.id
                address.addressible_type = "Event"
            end
        end
    end
end