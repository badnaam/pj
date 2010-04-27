# To change this template, choose Tools | Templates
# and open the template in the editor.

authorization do
    role :admin do
        includes [:guest, :business, :siteuser]
        has_permission_on [:users, :roles, :articles, :home, :events, :loyalty_benefits], :to =>[:index, :show, :new, :create, :update, :destroy, :edit, :deactivate, :activate,
            :assignbusinessrole, :assigncontribrole, :assignsiterole]        
       
    end

    role :guest do
        has_permission_on [:articles, :comments, :home, :events, :businesses,:address, :images, :interests, :loyalty_benefits, :merchants], :to => [:index, :show]
        has_permission_on [:users,:address], :to =>[ :new, :create]
    end

    role :siteuser do
        includes :guest
        has_permission_on [:comments, :events, :places], :to =>[:new, :create]
        has_permission_on [:comments, :events,:places], :to =>[:edit, :update, :destroy] do
            if_attribute :user => is {user}
        end
        has_permission_on [:users], :to =>[:show, :edit, :update] do
            if_attribute :username =>is {user.username}
        end
    end
    
    role :contributor do
        includes :guest
        includes :siteuser
        has_permission_on [:articles,:comments], :to =>[:create, :new]
        has_permission_on [:articles,:comments], :to =>[:edit, :update,:destroy] do
            if_attribute :user => is {user}
        end
    end

    role :business do
        includes :contributor
        has_permission_on :merchants, :to => [:new, :create]
        
        has_permission_on :merchants, :to =>[:edit, :update, :destroy] do
            if_attribute :user_id => is {user.id}
        end

        has_permission_on :loyalty_benefits, :to => [:new,:create] do
            if_permitted_to  :update, :merchant
        end
    end
end
