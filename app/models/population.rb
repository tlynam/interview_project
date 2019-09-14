class Population < ApplicationRecord
  def self.get(year:)
    query_year = year.to_i

    populations = Population.order(year: :asc).pluck(:year, :population)

    min_year_date = populations.first.first
    max_year_date, max_year_pop = populations.last

    return 0 if query_year < min_year_date.year
    return max_year_pop if query_year > max_year_date.year

    populations.each_with_index do |(db_date, current_year_pop), index|
      current_year = db_date.year
      next_entry = populations[index + 1]

      return current_year_pop if query_year == current_year
      return current_year_pop if next_entry.blank?

      next_entry_year = next_entry.first.year
      next_entry_pop = next_entry.second

      if (current_year...next_entry_year).cover?(query_year)
        entries_population_diff = (next_entry_pop - current_year_pop).to_f
        entries_years_diff = (next_entry_year - current_year).to_f
        avg_yearly_diff = entries_population_diff / entries_years_diff

        years_from_query_year = query_year - current_year
        additional_population = years_from_query_year * avg_yearly_diff

        return current_year_pop + additional_population
      end
    end
  end
end
