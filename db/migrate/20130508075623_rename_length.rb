class RenameLength < ActiveRecord::Migration
  def change
    rename_column :events, :length, :length_quart
  end
end
