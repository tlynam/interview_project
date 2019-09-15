# frozen_string_literal: true

class CalculatePopulationService
  include ActiveModel::Validations

  POST_DATA_GROWTH_RATE = 1.09

  attr_accessor :service_errors, :query_year, :calculated_pop, :calculation_type

  validates :query_year, presence: true

  def initialize(query_year:)
    self.service_errors = {}
    self.query_year = query_year.to_i
  end

  def run
    self.calculated_pop = calc_population
    save_query_to_log

    true
  rescue => e
    self.service_errors[:exception] = e.message

    false
  end

  private

  def valid_state?
    return true if valid?

    self.service_errors.merge!(errors.messages)

    false
  end

  def population_data
    @population_data ||= Population.order(year: :asc).pluck(:year, :population)
  end

  def min_data_year
    @min_data_year ||= population_data.first.first.year
  end

  def max_data_year
    @max_data_year ||= population_data.last.first.year
  end

  def max_data_year_pop
    @max_data_year_pop ||= population_data.last.last
  end

  def calc_population
    if query_year > 2500
      0
    elsif query_year < min_data_year
      0
    elsif query_year > max_data_year
      post_data_calc
    elsif (min_data_year..max_data_year).cover?(query_year)
      within_dataset_calc
    else
      raise 'Query year not covered'
    end
  end

  def post_data_calc
    self.calculation_type = 'calculated'
    number_of_years = query_year - max_data_year
    result = max_data_year_pop * (POST_DATA_GROWTH_RATE**number_of_years)
    result.to_i
  end

  def within_dataset_calc
    population_data.each_with_index do |(db_date, current_year_pop), index|
      current_year = db_date.year
      next_entry = population_data[index + 1]

      if query_year == current_year
        self.calculation_type = 'exact'
        return current_year_pop
      end

      next_entry_year = next_entry.first.year
      next_entry_pop = next_entry.second

      if (current_year...next_entry_year).cover?(query_year)
        self.calculation_type = 'calculated'

        entries_population_diff = (next_entry_pop - current_year_pop).to_f
        entries_years_diff = (next_entry_year - current_year).to_f
        avg_yearly_diff = entries_population_diff / entries_years_diff

        years_from_query_year = query_year - current_year
        additional_population = years_from_query_year * avg_yearly_diff

        return current_year_pop + additional_population
      end
    end
  end

  def save_query_to_log
    Log.create(
      year: Date.new(query_year,1,1),
      population: calculated_pop,
      calculation_type: calculation_type
    )
  end
end
