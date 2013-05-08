class RenameEarliestLatest < ActiveRecord::Migration
  def change
    rename_column :events, :earliest, :earliest_quart
    rename_column :events, :latest, :latest_quart
  end
end
