# frozen_string_literal: true

formatter = proc do |v|
  start_date, end_date = v.split(' - ').map { |d| Time.zone.parse(d) }

  if start_date == end_date
    end_date = end_date.end_of_day
  end

  Range.new(start_date, end_date)
end

Ransack.configure do |config|
  config.add_predicate 'between',
                       arel_predicate: 'between',
                       formatter:,
                       type: :string
end
