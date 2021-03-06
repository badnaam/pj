class Event < ActiveRecord::Base
    has_one :address, :as =>:addressible
    belongs_to :user

    accepts_nested_attributes_for :address
    attr_accessible :title, :description, :event_date, :details,:main_contact_name, :main_contact_number, :address_attributes

    acts_as_mappable :through => :address
    #validations
    #    Event.reflect_on_all_validations
    #    Event.reflect_on_all_validations
    #    Event.reflect_on_all_validations
    validates_length_of :title, :maximum => 150
    validates_length_of :description, :maximum => 500
    validates_presence_of :title, :event_date

    def get_lat_lng
        return [self.address.lat, self.address.lng]
    end

    def self.get_lat_lng_events(events)
        events.collect{|e|e.get_lat_lng}
    end
end