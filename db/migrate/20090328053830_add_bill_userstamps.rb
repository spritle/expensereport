class AddBillUserstamps < ActiveRecord::Migration
  def self.up
    add_column :bills, :created_at, :timestamp
    add_column :bills, :updated_at, :timestamp
  end
  def self.down
    remove_column :bills, :date
  end
end
