class AddPredictionModelToLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :prediction_model, :string, default: '', null: false
  end
end
