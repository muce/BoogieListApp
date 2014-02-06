class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :limit
      t.string :until
      t.string :paging_token

      t.timestamps
    end
  end
end
