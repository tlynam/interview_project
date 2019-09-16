class ChangeLogYearToInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :logs, :year
    add_column :logs, :query_year, :integer
  end
end
