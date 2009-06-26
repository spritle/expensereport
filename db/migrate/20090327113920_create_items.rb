class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
       t.column :item_code, :Integer
       t.column :description, :String
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
