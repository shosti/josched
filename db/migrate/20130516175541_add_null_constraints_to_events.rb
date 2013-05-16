class AddNullConstraintsToEvents < ActiveRecord::Migration
  def change
    change_column :events, :user_id, :integer, null: false
    change_column :events, :name, :string, null: false
    change_column :events, :date, :date, null: false
    change_column :events, :type, :string, null: false
  end
end
