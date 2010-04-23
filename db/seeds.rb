# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#Create admin user
r = Role.create(:name => admin)
u = User.create(:username => admin, :password => "t", :password_confirmation => "t", :email => "tin.singh@hotmail.com")
u.assignments.create(:role_id -> r.id)
