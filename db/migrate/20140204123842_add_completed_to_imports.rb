class AddCompletedToImports < ActiveRecord::Migration
  def change
    add_column :imports, :completed, :boolean
  end
end
