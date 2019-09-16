# frozen_string_literal: true

class CalculatePopulationService
  include ActiveModel::Validations

  POST_DATA_GROWTH_RATE = 0.09
  POPULATION_CAPACITY = 750_000_000.to_f
  PREDICTION_MODELS = %w[exponential logistic].freeze

  attr_accessor :service_errors, :query_year, :calculated_pop,
                :calculation_type, :prediction_model

  validate :query_year_validation
  validates :prediction_model, inclusion: { in: PREDICTION_MODELS }, presence: true

  def initialize(query_year:, prediction_model:)
    self.service_errors = {}
    self.query_year = query_year.to_i
    self.prediction_model = prediction_model
  end

  def run
    return false unless valid_state?

    self.calculated_pop = calc_population
    save_query_to_log

    true
  rescue => e
    self.service_errors[:exception] = e.message

    false
  end

  private

  def query_year_validation
    if query_year > 2500
      errors.add :year, "must be less than 2500"
      false
    elsif query_year < min_data_year
      errors.add :year, "must be greater than #{min_data_year}"
      false
    end
  end

  def valid_state?
    return true if valid?

    self.service_errors[:validation] = errors.full_messages

    false
  end

  def population_data
    @population_data ||= Population.order(year: :asc).pluck(:year, :population)
  end

  def min_data_year
    @min_data_year ||= population_data.first.first
  end

  def max_data_year
    @max_data_year ||= population_data.last.first
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

    case prediction_model
    when 'logistic'
      calc_logistic_pop
    when 'exponential'
      calc_exponential_pop
    else
      raise 'Unsupported growth model'
    end
  end

  # References on how to calculate using logistic model
  # https://www.youtube.com/watch?v=MIOj-W-jY-k
  # https://sites.math.northwestern.edu/~mlerma/courses/math214-2-03f/notes/c2-logist.pdf
  def calc_logistic_pop
    number_of_years = query_year - max_data_year

    denominator_part1 = POPULATION_CAPACITY - max_data_year_pop
    denominator_part2 = Math.exp(-0.09 * number_of_years)
    denominator = max_data_year_pop + (denominator_part1 * denominator_part2)

    result = (POPULATION_CAPACITY * max_data_year_pop) / denominator

    result.to_i
  end

  def calc_exponential_pop
    number_of_years = query_year - max_data_year
    result = max_data_year_pop * (1 + POST_DATA_GROWTH_RATE)**number_of_years
    result.to_i
  end

  def within_dataset_calc
    population_data.each_with_index do |(db_date, current_year_pop), index|
      current_year = db_date
      next_entry = population_data[index + 1]

      if query_year == current_year
        self.calculation_type = 'exact'
        return current_year_pop
      end

      next_entry_year = next_entry.first
      next_entry_pop = next_entry.second

      if (current_year...next_entry_year).cover?(query_year)
        self.calculation_type = 'calculated'

        entries_population_diff = (next_entry_pop - current_year_pop).to_f
        entries_years_diff = (next_entry_year - current_year).to_f
        avg_yearly_diff = entries_population_diff / entries_years_diff

        years_from_query_year = query_year - current_year
        additional_population = years_from_query_year * avg_yearly_diff

        return (current_year_pop + additional_population).to_i
      end
    end
  end

  def save_query_to_log
    Log.create(
      query_year: query_year,
      population: calculated_pop,
      calculation_type: calculation_type,
      prediction_model: prediction_model
    )
  end
end
