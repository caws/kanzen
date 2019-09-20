require 'active_record' unless defined? ActiveRecord
require_relative 'kanzen/inspection'
require_relative 'kanzen/version'

module Kanzen
  # These are fields that, for the most part, won't be taken
  # into consideration when calculating the percentage
  # completed for a given model.
  #
  # PS: They are ignored when a custom ignore_list is
  # passed.
  DEFAULT_IGNORE_LIST = [:id, :created_at, :updated_at]

  # This is the default proc used to determine if a
  # given attribute is valid or not.
  # We convert attributes to string and since nils
  # are converted to "", we can compare that to see
  # if a given attribute is different from an empty
  # string literal
  DEFAULT_PROC = Proc.new do |attribute_name, value|
    value.to_s != ""
  end

  # Returns true if the model and its associations are
  # all filled.
  #
  # A proc containing a comparison can also be passed
  # in order to define if a given attribute is valid or
  # not.
  def completed?(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).completed?
  end

  # Returns a percentage value for the amount of
  # missing attributes.
  def percentage_missing(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).percentage_missing
  end

  # Returns a percentage value for the amount of
  # present attributes.
  def percentage_present(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).percentage_present
  end

  # Returns a hash containing a list of present
  # attributes. They are organized in the following
  # the order:
  #
  # your_hash[:model_class] = attribute_name
  def present_attributes(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).present_attributes
  end

  # Returns hash containing a list of missing
  # attributes. They are organized in the following
  # the order:
  #
  # your_hash[:model_class] = attribute_name
  def missing_attributes(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).missing_attributes
  end

  # Returns the number of present attributes
  def number_of_present_attributes(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).number_of_present_attributes
  end

  # Returns the number of missing attributes
  def number_of_missing_attributes(proc: DEFAULT_PROC, ignore_list: DEFAULT_IGNORE_LIST)
    kanzen_calculation(proc, ignore_list).number_of_missing_attributes
  end

  private

  def kanzen_calculation(proc, *ignore_list)
    Kanzen::Inspection.new(self, proc, ignore_list).completion_check
  end
end
