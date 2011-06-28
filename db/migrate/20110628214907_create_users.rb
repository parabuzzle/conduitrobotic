class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string, :null=>false
      t.column :password, :string
      t.column :temp_token, :string
      t.column :is_admin, :boolean, :null=>false, :default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
