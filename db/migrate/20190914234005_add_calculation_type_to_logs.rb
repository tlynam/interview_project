class AddCalculationTypeToLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :calculation_type, :string, default: '', null: false
  end
end
