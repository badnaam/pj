class Event < ActiveRecord::Base
    

    has_many :categorizations, :dependent => :destroy
    has_many :categories, :through => :categorizations
    has_one :address, :as =>:addressible
    belongs_to :user

    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :categorizations, :reject_if => proc {|attrs| attrs[:category_id].blank?}
    attr_accessible :title, :description, :event_date, :details,:main_contact_name, :main_contact_number, :address_attributes, :category_ids

    acts_as_mappable :through => :address
    #validations
    #    Event.reflect_on_all_                                          validations
    #    Event.reflect_on_all_validations
    #    Event.reflect_on_all_validations
    validates_length_of :title, :maximum => 150
    validates_length_of [:description, :details], :maximum => 500
    validates_presence_of :title, :event_date, :description
   
    validates_datetime :event_date, :on_or_after => lambda {Time.now}, :on_or_before_message => "Event date/time must be in the future."

    after_save :update_categorizations
    
    def get_lat_lng
        return [self.address.lat, self.address.lng]
    end

    def self.get_lat_lng_events(events)
        events.collect{|e|e.get_lat_lng}
    end

    def update_categorizations
        unless self.categorizations.nil?
            self.categorizations.each do |a|
                a.destroy unless category_ids.include?(a.category_id.to_s)
                category_ids.delete(a.category_id.to_s)
            end
        end unless category_ids.nil?

        category_ids.each do |r|
            self.categorizations.create(:category_id => r) unless r.blank?
        end unless category_ids.nil?
#        reload
#        self.category_ids = nil
    end

end