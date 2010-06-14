class VoteTopic < ActiveRecord::Base
    belongs_to :merchant
    has_many :vote_items, :dependent => :destroy

    validates_presence_of :header, :topic
    validate :min_vote_items, :if => :its_new?
    before_save :deactivate_current_vote, :if => :its_new?
    accepts_nested_attributes_for :vote_items, :limit => 5, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:option].blank? }

    acts_as_mappable :through => :merchant
     
    def min_vote_items
        if self.vote_items.length < 2
            errors.add_to_base("Please specify at least two vote options")
            return false
        end
    end
    
    def its_new?
        self.new_record?
    end

    def deactivate_current_vote
        @existing_vote_topic = VoteTopic.find_by_active_and_merchant_id(true, self.merchant_id)
        if !@existing_vote_topic.nil?
            if !@existing_vote_topic.update_attribute(:active, false)
                return false
            else
                self.active = true
            end
        else
            self.active = true
        end
    end

end
