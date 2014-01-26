class ChangeDataTypeForFieldName < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.change :facebook_id, :string
    end
  end
  def self.down
    change_table :posts do |t|
      t.change :facebook_id, :integer
    end
  end
end
