class Measurement < ApplicationRecord
  belongs_to :meter

  default_scope { order(id: :asc) }

  validate :amount_not_changed, if: :approved

  def start
    meter.start + (nth_measurement_of_parent * meter.interval)
  end

  def finish
    meter.start + ((nth_measurement_of_parent + 1) * meter.interval)
  end

  private
    def nth_measurement_of_parent
      nth_measurement = 0
      meter.measurements.each do |m|
        break if self == m
        nth_measurement += 1
      end
      
      nth_measurement
    end

    def amount_not_changed
      if amount_changed? && self.persisted?
        errors.add(:amount, "Change of amount not allowed when approved")
      end
    end
end
