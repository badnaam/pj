class Event < ActiveRecord::Base
    CATEGORIES = {1 => "All", 2 => "Charities",  3 => "Family", 4 => "Fashion", 5 => "Festival", 6 => "Film", 7 => "Food", 8 => "Music",  9 => "Nightlife",
         10 => "Performing Arts", 11 => "Lectures", 12 => "Sports", 13 => "Wine",  14 => "Visual Arts"
    }
    has_one :address, :as =>:addressible
    belongs_to :user

    accepts_nested_attributes_for :address
    attr_accessible :title, :description, :event_date, :details,:main_contact_name, :main_contact_number, :address_attributes

    acts_as_mappable :through => :address
    #validations
    #    Event.reflect_on_all_                                          validations
    #    Event.reflect_on_all_validations
    #    Event.reflect_on_all_validations
    validates_length_of :title, :maximum => 150
    validates_length_of [:description, :details], :maximum => 500
    validates_presence_of :title, :event_date, :description
   
    validates_datetime :event_date, :on_or_after => lambda {Time.now}, :on_or_before_message => "Event date/time must be in the future."

#    Event.named_scope :event_today, :conditions => ["event_date = ?", Date.today]
#    Event.named_scope :event_tomorrow, :conditions => ["event_date = ?", Date.tomorrow]
#    Event.named_scope :event_week, :conditions => "event_date >= Date.today.beginning_of_week && event_date <= Date.today.end_of_week"
    
    def get_lat_lng
        return [self.address.lat, self.address.lng]
    end

    def self.get_lat_lng_events(events)
        events.collect{|e|e.get_lat_lng}
    end
end