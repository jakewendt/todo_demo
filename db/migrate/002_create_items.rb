class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.column :user_id,     :integer
      t.column :category_id, :integer
      t.column :priority,    :integer
      t.column :due_date,    :date
      t.column :name,        :string
      t.column :done,        :boolean
      t.column :created_at,  :datetime
      t.column :updated_at,  :datetime
    end
  end

  def self.down
    drop_table :items
  end
end
