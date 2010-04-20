class AddRoleDescriptionToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :role_description, :string, {:null =>false, :default=> "Default role description", :limit => 50}
  end

  def self.down
    remove_column :roles, :role_description
  end
end
