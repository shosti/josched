class ChangeEventIndices < ActiveRecord::Migration
  def up
    add_index :events, [:type, :user_id, :date, :start_min], name:
      'index_user_events_by_start'
    add_index(
      :events,
      [:type, :user_id, :date, :earliest_quart, :latest_quart],
      name: 'index_user_events_by_earliest_and_latest')
    remove_index :events, name:
      'index_events_on_date_and_user_id_and_start_min'
  end

  def down
    remove_index :events, name: 'index_user_events_by_start'
    remove_index :events, name: 'index_user_events_by_earliest_and_latest'
    add_index "events", ["date", "user_id", "start_min"], :name => "index_events_on_date_and_user_id_and_start_min"
  end
end
