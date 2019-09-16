class LogsController < ApplicationController
  def index
    @logs = Log.all
    pops_with_counts = Population.
      joins("LEFT OUTER JOIN logs ON populations.year = logs.query_year").
      select("populations.year, count(logs.query_year) as count").
      group(:population)

    @population_counts = pops_with_counts.map { |pop| [pop.year, pop.count] }
  end
end
