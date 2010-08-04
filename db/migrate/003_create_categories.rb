class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :user_id,    :integer
      t.column :color,      :string
      t.column :name,       :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :categories
  end
end
