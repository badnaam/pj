class LoyaltyBenefit < ActiveRecord::Base
    belongs_to :merchant
    LEVEL_OPTIONS = {1 => "Basic", 2 => "Silver", 3 => "Gold"}
    #    BONUS_OPTIONS = {1 => "Points", 2 => "Point Multiplier", 3 => "Special Perk"}
    #    BENEFIT_OPTIONS = {1 => "Points", 2 => "Perks"}
    

    
    validates_presence_of :loyalty_level,  :point_conversion_ratio, :community_use
    validates_presence_of :point_bonus_window_start, :point_bonus_window_end, :point_bonus_window_time_start, :point_bonus_window_time_end,
      :unless => Proc.new {|r| r.point_bonus_multiplier.blank? }
    validates_date :point_bonus_window_end, :after => lambda {:point_bonus_window_start}, :on_or_before_message => "End Date should be later than Start Date"
    validates_time :point_bonus_window_time_end, :after => lambda {:point_bonus_window_time_start}, :on_or_before_message => "End Time should be later than Start Time"
    validates_numericality_of :point_conversion_ratio,  :message => "Point conversion ratio has to be a number"
    validates_uniqueness_of :loyalty_level, :scope => :merchant_id, :message => "You already have an benefits for this level"

    #    validates_uniqueness_of :active, :scope => [:merchant_id, :loyalty_level], :if => "active == true", :message => "You alreaedy have an active benefits for this level"
    def self.level_options(merchant_id)
        saved_options = self.merchant_id_equals(merchant_id).collect {|r| r.loyalty_level}
        options = LEVEL_OPTIONS.keys.reject {|x| saved_options.include?(x)}
        options.collect {|x| [x, LEVEL_OPTIONS[x]]}
    end
end
