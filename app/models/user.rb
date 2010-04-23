#require 'mime/types'

class User < ActiveRecord::Base
    #authlogic
    Max_Profile_Images = 2
    Max_Image_Size = 1.megabyte
    TO_FORMAT = /^[_a-z0-9+.-]+@[_a-z0-9-]+\.[_a-z0-9.-]+$/i
    
    acts_as_authentic do |a|
        a.validates_length_of_password_field_options = {:minimum => 1, :on =>:update, :if => :has_no_credential?}
        a.validates_length_of_login_field_options = {:minimum => 1, :on =>:update, :if => :has_no_credential?}
        a.validates_format_of_login_field_options :with => /[a-zA-Z0-9_]$/, :message =>"Only numbers,
            letters and underscore allowed"
        #        a.ignore_blank_passwords(false)
    end

    validates_presence_of :username
    #    validate :validate_attachments

    has_many :interests, :as => :interestible, :dependent => :destroy
    accepts_nested_attributes_for :interests, :reject_if => proc {|attributes| attributes["interest_name"].blank?}, :allow_destroy => true

    has_many :images, :as => :imageible, :dependent => :destroy
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

    #    has_many :merchant_users, :dependent => :destroy
    has_many :merchants
    
    #Associations
    #    for roles
    has_many :assignments, :dependent => :destroy
    has_many :roles, :through => :assignments

    #Address
    has_one :address, :as => :addressible

    #User's friends
    has_many :friendships, :dependent => :destroy
    has_many :friends,  :through => :friendships

    #Users who have friended this user
    has_many :inverse_friendships, :class_name => "Friendship", :foreign_key =>"friend_id"
    has_many :inverse_friends, :through => :inverse_friendships, :source => "user"

    has_many :comments
    has_many :events

    attr_accessor :role_ids
    attr_accessible  :username, :password, :password_confirmation, :email, :images_attributes, :interests_attributes, :active

    after_destroy :remove_friendships
    after_save :assigndefault

    def imageible_name
        return "users"
    end

    def deliver_activation_instructions!
        reset_perishable_token!
        Notifier.deliver_activation_instructions(self)
    end

    def deliver_activation_confirmation!
        reset_perishable_token!
        Notifier.deliver_activation_confirmation(self)
    end
    

    def deliver_password_reset_instructions!
        reset_perishable_token!
        Notifier.deliver_password_reset_instructions(self)
    end

    def getusername
        self.username
    end
    
    def role_symbols
        arr = (self.roles || []).map {|r| r.name.to_sym}
        return arr
    end
    
    def update_roles
        logger.info "self is " + self.username
        logger.info role_ids.nil?.to_s
        unless self.assignments.nil?
            self.assignments.each do |a|
                a.destroy unless role_ids.include?(a.role_id.to_s)
                role_ids.delete(a.role_id.to_s)
            end
        end unless role_ids.nil?

        role_ids.each do |r|
            self.assignments.create(:role_id => r) unless r.blank?
        end unless role_ids.nil?
        reload
        self.role_ids = nil
    end

    def remove_friendships
        @id = self.id;
        @friendships = Friendship.all(:conditions => "friend_id = #{@id}")
        for friendship in @friendships
            friendship.destroy
        end  unless @friendships.nil?
    end

    def self.search(search)
        if search
            find(:all, :conditions => ["username LIKE ?", "%#{search}%"])
        else
            find(:all)
        end
    end

    def has_no_credential?
        self.crypted_password.blank?
    end

    def deactivate!
        self.active = 0
        #        save
    end

    def activate!
        self.active = 1
        #        save
    end

    def active?
        active
    end

    def businessrole!
        #get role id for business
        rid = Role.first(:conditions => "name = 'business' ").id
        unless self.assignments.nil?
            self.assignments.each do |a|
                a.destroy
            end
        end
        self.assignments.create(:role_id =>rid)
        reload
    end

    def contribrole!
        #get role id for business
        rid = Role.first(:conditions => "name =  'contributor' ").id
        unless self.assignments.nil?
            self.assignments.each do |a|
                a.destroy
            end
        end
        self.assignments.create(:role_id => rid)
        reload
    end

    def siterole!
        #get role id for business
        rid = Role.first(:conditions =>  "name = 'siteuser' ").id
        unless self.assignments.nil?
            self.assignments.each do |a|
                a.destroy
            end
        end
        self.assignments.create(:role_id =>rid)
        reload
    end

    def assigndefault
        if self.assignments.blank?
            rid = Role.first(:conditions =>  "name = 'siteuser' ").id
            self.assignments.create(:role_id =>rid)
            #            reload
        end
    end

    def swf_uploaded_data=(data)
        data.content_type = MIME::Types.type_for(data.original_filename)
        self.uploaded_data = data
    end
    


    def validate_attachments
        errors.add_to_base("Too many images - maximum is #{Max_Images}") if images.length > Max_Images
        images.each {|i| errors.add_to_base("#{i.name} is over #{Max_Image_Size/1.megabyte}MB") if i.image_file_size > Max_Image_Size}
    end

end

