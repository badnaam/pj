class Interest < ActiveRecord::Base
    belongs_to :interestible, :polymorphic => true

    after_save :log_it

    def log_it
        logger.info("Interest saved!")
    end
end
