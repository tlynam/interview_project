class AddLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.date :year, null: false
      t.integer :population, null: false

      t.timestamps
    end
  end
end
