class ChangeDateToInteger < ActiveRecord::Migration[5.2]
  def self.up
    add_column :populations, :year_int, :integer
    Population.reset_column_information

    Population.find_each do |pop|
      pop.year_int = pop.year.year
      pop.save
    end

    remove_column :populations, :year
    rename_column :populations, :year_int, :year
  end

  def self.down
    add_column :populations, :year_date, :date
    Population.reset_column_information

    Population.find_each do |pop|
      pop.year_date = Date.new(pop.year, 1, 1)
      pop.save
    end

    remove_column :populations, :year
    rename_column :populations, :year_date, :year
  end
end
