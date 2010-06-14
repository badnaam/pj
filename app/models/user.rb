#require 'mime/types'

class User < ActiveRecord::Base
    #authlogic
    Max_Profile_Images = 2
    USER_TYPE = {"u" => 1, "b" => 2, "c" => 3}
    Max_Image_Size = 1.megabyte
    #    TO_FORMAT = /^[_a-z0-9+.-]+@[_a-z0-9-]+\.[_a-z0-9.-]+$/i

    #    USER_TYPE = {1 => "User", 2 => "BusinessUser", 3 => "Contributor"}
    acts_as_authentic do |a|
        a.validates_length_of_password_field_options = { :within => 1..8, :on =>:update, :if => :has_no_credential?}
        a.validates_length_of_login_field_options = { :within => 1..8, :on =>:update, :if => :has_no_credential?}
        #        a.validates_format_of_login_field_options :with => /[a-zA-Z0-9_]$/, :message =>"Only numbers,
        #            letters and underscore allowed"
        #        a.ignore_blank_passwords(false)
    end
    
    acts_as_voter
    ajaxful_rater
    validates_presence_of :email
    validates_presence_of :first_name, :last_name, :phone, :if => Proc.new {|r| r.ut == USER_TYPE["b"] || r.ut == USER_TYPE["c"]}
    has_many :ets
    has_many :searches
    has_many :articles
    
    has_many :images, :as => :imageible, :dependent => :destroy
    accepts_nested_attributes_for :images, :reject_if => proc {|attributes| attributes["image"].blank?}, :allow_destroy => true

    has_many :owned_merchants, :foreign_key => :owner_id, :class_name => 'Merchant'

    has_many :merchant_memberships, :dependent => :destroy
    has_many :merchants, :through => :merchant_memberships
    
    #Associations
    #    for roles
    #    has_many :assignments, :dependent => :destroy
    belongs_to :role

    #Address
    has_one :address, :as => :addressible
    accepts_nested_attributes_for :address, :reject_if => proc {|attributes| attributes["address"].blank?}, :allow_destroy => true

    #Users who have friended this user
    has_many :inverse_friendships, :class_name => "Friendship", :foreign_key =>"friend_id"
    has_many :inverse_friends, :through => :inverse_friendships, :source => "user"

    has_many :comments
    has_many :events

    attr_accessor :role_ids
    attr_accessible  :username, :password, :password_confirmation, :email, :ut, :first_name, :last_name, :phone

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
        arr = Array.new
        arr << self.role.name.to_sym
        #        arr = (self.role || []).map {|r| r.name.to_sym}
        return arr
    end
    
    #    def update_roles
    #        logger.info "self is " + self.username
    #        logger.info role_ids.nil?.to_s
    #        unless self.assignments.nil?
    #            self.assignments.each do |a|
    #                a.destroy unless role_ids.include?(a.role_id.to_s)
    #                role_ids.delete(a.role_id.to_s)
    #            end
    #        end unless role_ids.nil?
    #
    #        role_ids.each do |r|
    #            self.assignments.create(:role_id => r) unless r.blank?
    #        end unless role_ids.nil?
    #        reload
    #        self.role_ids = nil
    #    end

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
        #        rid = Role.first(:conditions => "name = 'business' ").id
        #        unless self.assignments.nil?
        #            self.assignments.each do |a|
        #                a.destroy
        #            end
        #        end
        #        self.assignments.create(:role_id =>rid)
        #        reload
        self.role_id = Role.find_by_name('business').id
    end

    def contribrole!
        self.role_id = Role.find_by_name('contributor').id
        #get role id for business
        #        rid = Role.first(:conditions => "name =  'contributor' ").id
        #        unless self.assignments.nil?
        #            self.assignments.each do |a|
        #                a.destroy
        #            end
        #        end
        #        self.assignments.create(:role_id => rid)
        #        reload
    end

    def siterole!
        self.role_id = Role.find_by_name('siteuser').id
        #        #get role id for business
        #        rid = Role.first(:conditions =>  "name = 'siteuser' ").id
        #        unless self.assignments.nil?
        #            self.assignments.each do |a|
        #                a.destroy
        #            end
        #        end
        #        self.assignments.create(:role_id =>rid)
        #        reload
    end

    def assigndefault
        if self.role_id.nil?
            rid = Role.first(:conditions =>  "name = 'siteuser' ").id
            self.role_id = rid
            #            self.assignments.create(:role_id =>rid)
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

