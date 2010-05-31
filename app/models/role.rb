class Role < ActiveRecord::Base
    #    acts_as_authorization_role
#    has_many :assignments, :dependent => :destroy
    has_many :users

    def get_pos_roles(current_role)
       role_arr = self.find(:all, :select => :name).reject {|a| a.name == current_role}.map {|b| b.name}
    end

    def get_role_names
        role_arr = self.find(:all, :select => :name).map {|b| b.name}
    end
end
