module Kanzen
  class Result
    attr_accessor :present_attributes,
                  :number_of_present_attributes,
                  :missing_attributes,
                  :number_of_missing_attributes

    def initialize(present_attributes,
                   number_of_present_attributes,
                   missing_attributes,
                   number_of_missing_attributes)
      self.present_attributes = present_attributes
      self.number_of_present_attributes = number_of_present_attributes
      self.missing_attributes = missing_attributes
      self.number_of_missing_attributes = number_of_missing_attributes
    end

    def self.build_result(present_attributes, number_of_present_attributes,
        missing_attributes, number_of_missing_attributes)
      Result.new(present_attributes,
                 number_of_present_attributes,
                 missing_attributes,
                 number_of_missing_attributes)
    end

    # Returns the percentage of missing attributes
    def percentage_missing
      total = number_of_missing_attributes + number_of_present_attributes

      ((number_of_missing_attributes * 100) / total.to_f).round(2)
    end

    # Returns the percentage of present attributes
    def percentage_present
      total = number_of_missing_attributes + number_of_present_attributes

      ((number_of_present_attributes * 100) / total.to_f).round(2)
    end

    # Returns true if the model and its associations are fully filled
    def completed?
      number_of_missing_attributes.zero?
    end
  end
end