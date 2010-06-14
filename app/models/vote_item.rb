class VoteItem < ActiveRecord::Base
    belongs_to :vote_topic
    acts_as_voteable
end
