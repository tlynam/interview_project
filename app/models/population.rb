class Population < ApplicationRecord
  def self.get(year:)
    year = year.to_i

    populations = Population.order(year: :asc).pluck(:year, :population)

    min_year_date = populations.first.first
    max_year_date, max_year_pop = populations.last

    return 0 if year < min_year_date.year
    return max_year_pop if year > max_year_date.year

    populations.each_with_index do |(db_date, pop), index|
      current_year = db_date.year
      next_entry = populations[index + 1]

      return pop if next_entry.blank?

      next_entry_year = next_entry.first.year

      return pop if (current_year...next_entry_year).cover?(year)
    end
  end
end
