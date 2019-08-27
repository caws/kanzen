require 'active_record' unless defined? ActiveRecord
require_relative 'kanzen/inspection'
require_relative 'kanzen/version'

module Kanzen
  # Returns true if the model and its associations are
  # all filled.
  #
  # A proc containing a comparison can also be passed
  # in order to define if a given attribute is valid or
  # not.
  def completed?(proc: nil, ignore_list: nil)
    if proc
      return custom_kanzen_calculation(proc, ignore_list)
                 .completed?
    end

    kanzen_calculation(ignore_list).completed?
  end

  # Returns a percentage value for the amount of
  # missing attributes.
  def percentage_missing(proc: nil, ignore_list: nil)
    if proc
      return custom_kanzen_calculation(proc, ignore_list)
                 .percentage_missing
    end

    kanzen_calculation(ignore_list).percentage_missing
  end

  # Returns a percentage value for the amount of
  # present attributes.
  def percentage_present(proc: nil, ignore_list: nil)
    if proc
      return custom_kanzen_calculation(proc, ignore_list)
                 .percentage_present
    end

    kanzen_calculation(ignore_list).percentage_present
  end

  # Returns a hash containing a list of present
  # attributes. They are organized in the following
  # the order:
  #
  # your_hash[:model_class] = attribute_name
  def present_attributes(proc: nil, ignore_list: nil)
    if proc
      return custom_kanzen_calculation(proc, ignore_list)
                 .present_attributes
    end

    kanzen_calculation(ignore_list).present_attributes
  end

  # Returns hash containing a list of missing
  # attributes. They are organized in the following
  # the order:
  #
  # your_hash[:model_class] = attribute_name
  def missing_attributes(proc: nil, ignore_list: nil)
    if proc
      return custom_kanzen_calculation(proc, ignore_list)
                 .missing_attributes
    end

    kanzen_calculation(ignore_list).missing_attributes
  end

  private

  def kanzen_calculation(*ignore_list)
    Kanzen::Inspection.new(self, nil, ignore_list).completion_check
  end

  def custom_kanzen_calculation(proc, *ignore_list)
    Kanzen::Inspection.new(self, proc, ignore_list).completion_check
  end
end
