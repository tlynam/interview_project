class Population < ApplicationRecord
  GROWTH_RATE = 1.09

  def self.get(year:)
    query_year = year.to_i

    populations = Population.order(year: :asc).pluck(:year, :population)

    min_year = populations.first.first.year
    max_year_date, max_year_pop = populations.last
    max_year = max_year_date.year

    return 0 if query_year < min_year
    return 0 if query_year > 2500

    if query_year > max_year
      return calc_population(
        base_population: max_year_pop,
        base_year: max_year,
        query_year: query_year
      )
    end

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

  def self.calc_population(base_population:, base_year:, query_year:)
    number_of_years = query_year - base_year
    result = base_population * (GROWTH_RATE**number_of_years)
    result.to_i
  end
end
