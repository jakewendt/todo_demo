class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name,            :string
      t.column :realname,        :string
      t.column :email,           :string
      t.column :info,            :text
      t.column :hashed_password, :string
      t.column :created_at,      :datetime
      t.column :updated_at,      :datetime
    end
    admin = User.create({
      :name => 'admin',
      :realname => 'admin',
      :email => 'admin',
      :info => 'admin',
      :password => 'admin',
      :password_confirmation => 'admin'
    })
  end

  def self.down
    drop_table :users
  end
end
