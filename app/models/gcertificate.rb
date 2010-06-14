class Gcertificate < ActiveRecord::Base
    MINIMUM_SCORE = 100
    MAXIMUM_SCORE = 1000
    GRADES = {5 => 901, 4 => 701, 3 => 501, 2 => 301, 1 => 201}
    
    belongs_to :merchant
    has_many :gcertifications, :dependent => :destroy
    has_many :gcertsteps, :through => :gcertifications

    accepts_nested_attributes_for :gcertifications

    before_save :archive_gcertificate, :unless => :its_new?

    named_scope :recent_grades, :order => "updated_at DESC"
    named_scope :latest, :order => "updated_at DESC", :limit => 1

    scope_procedure :certs_between, lambda { |p| updated_at_gte(p[0]).updated_at_lt(p[1]) } 

    def its_new?
        self.new_record?
    end


    def archive_gcertificate
        existing_record = Gcertificate.find(self.id)
        new_rec = Gcertificate.new(existing_record.attributes)
        new_rec.cert_valid = false
        new_rec.save
    end

    def self.grade_it(v)
        if v >= 901
            return 5
        elsif v == 0 || v < MINIMUM_SCORE
            return 0
        else
            return (GRADES.values << v).sort.find_index(v) + 1
        end
    end
end
