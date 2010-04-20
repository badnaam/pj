class LoyaltyBenefit < ActiveRecord::Base
    belongs_to :merchant
    LEVEL_OPTIONS = {1 => "Basic", 2 => "Silver", 3 => "Gold"}
    BONUS_OPTIONS = {1 => "Points", 2 => "Point Multiplier", 3 => "Special Perk"}
    BENEFIT_OPTIONS = {1 => "Points", 2 => "Perks"}
    

    
    validates_presence_of :loyalty_level, :active, :benefit_type
#    validates_presence_of :description, :if => "benefit_type == BENEFIT_OPTIONS[2]"
    validates_presence_of :description, :if => Proc.new {|loyalty_benefit| loyalty_benefit.benefit_type == BENEFIT_OPTIONS.keys[1]}
#    validates_presence_of :point_conversion_ratio, :if => "benefit_type == BENEFIT_OPTIONS[1]"
    validates_presence_of :point_conversion_ratio, :if => Proc.new {|loyalty_benefit| loyalty_benefit.benefit_type == BENEFIT_OPTIONS.keys[0]}
    validates_numericality_of :point_conversion_ratio, :allow_blank => true, :message => "Point conversion ratio has to be a number"
    validates_uniqueness_of :loyalty_level, :scope => :merchant_id, :message => "You already have an benefits for this level"
    validates_presence_of :point_bonus, :if => Proc.new {|loyalty_benefit|loyalty_benefit.bonus_type == BONUS_OPTIONS.keys[0]}
    validates_presence_of :point_bonus_multiplier, :if => Proc.new {|loyalty_benefit| loyalty_benefit.bonus_type == BONUS_OPTIONS.keys[1]}
    validates_presence_of :perk_bonus, :if => Proc.new {|loyalty_benefit| loyalty_benefit.bonus_type == BONUS_OPTIONS.keys[2]}
    validates_presence_of :bonus_window_start, :unless => "bonus_type.blank?"
    validates_presence_of :bonus_window_end, :unless => "bonus_type.blank?"

    #    validates_uniqueness_of :active, :scope => [:merchant_id, :loyalty_level], :if => "active == true", :message => "You alreaedy have an active benefits for this level"
    def self.level_options(merchant_id)
        saved_options = self.merchant_id_equals(merchant_id).collect {|r| r.loyalty_level}
        options = LEVEL_OPTIONS.keys.reject {|x| saved_options.include?(x)}
        options.collect {|x| [x, LEVEL_OPTIONS[x]]}
    end
end
