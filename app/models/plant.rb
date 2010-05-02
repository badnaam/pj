class Plant < ActiveRecord::Base
    has_many :variations
    has_many :varieties, :through => :variations

    accepts_nested_attri    butes_for :variations, :reject_if => proc {|attr| attr[variety_id].blank?}
end
