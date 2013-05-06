class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :name
      t.string :location
      t.date :date
      t.integer :start_min
      t.integer :end_min
      t.integer :earliest
      t.integer :latest
      t.integer :length
      t.string :type

      t.timestamps
    end

    add_index :events, [:date, :user_id, :start_min]
  end
end
