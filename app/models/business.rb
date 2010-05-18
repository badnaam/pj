# To change this template, choose Tools | Templates
# and open the template in the editor.

class BusinessUser < User
    self.inheritance_column :user_type
end
