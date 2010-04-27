namespace :pop do
    desc "Fills the database with dummy data"

    task :populate_events => :environment do
        require 'populator'
        require 'faker'

        Event.populate 50 do |event|
            event.title = Populator.words(1..20).titleize
            event.description = Faker::Lorem.paragraph(5)
            event.event_date = Time.now..1.year.from_now
            event.main_contact_name = Populator.words(4..20).titleize
            event.main_contact_number = Faker::PhoneNumber.phone_numer()
            event.details = Faker::Lorem.paragraph(2)
            event.user_id = 3..15

            address.populate do |address|
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