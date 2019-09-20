require_relative 'result'

module Kanzen
  class Inspection
    attr_accessor :model,
                  :present_attributes,
                  :number_of_present_attributes,
                  :missing_attributes,
                  :number_of_missing_attributes,
                  :ignore_list,
                  :proc

    def initialize(model, proc, *ignore_list)
      self.model = model
      self.ignore_list = ignore_list.flatten!
      self.present_attributes = ({})
      self.number_of_present_attributes = 0
      self.missing_attributes = ({})
      self.number_of_missing_attributes = 0
      self.proc = proc
    end

    def completion_check
      check_all_attributes(model)

      Kanzen::Result.build_result(self.present_attributes, self.number_of_present_attributes,
                                  self.missing_attributes, self.number_of_missing_attributes)
    end

    private

    def attribute_present_in_ignore_list?(attribute)
      ignore_list.include? attribute.to_sym
    end

    def add_to_present_attributes(another_model, attribute)
      if present_attributes[another_model.class.name.underscore].nil?
        present_attributes[another_model.class.name.underscore] = []
      end

      present_attributes[another_model.class.name.underscore] << attribute
    end

    def increase_present_attributes(another_model, attribute)
      return nil if attribute_present_in_ignore_list?(attribute)

      self.number_of_present_attributes = 0 if self.number_of_present_attributes.nil?
      self.number_of_present_attributes = self.number_of_present_attributes + 1

      add_to_present_attributes(another_model, attribute)
    end

    def add_to_missing_attributes(another_model, attribute)
      if missing_attributes[another_model.class.name.underscore].nil?
        missing_attributes[another_model.class.name.underscore] = []
      end

      missing_attributes[another_model.class.name.underscore] << attribute
    end

    def increase_missing_attributes(another_model, attribute)
      return nil if attribute_present_in_ignore_list?(attribute)

      self.number_of_missing_attributes = 0 if self.number_of_missing_attributes.nil?
      self.number_of_missing_attributes = self.number_of_missing_attributes + 1

      add_to_missing_attributes(another_model, attribute)
    end

    def is_attribute_valid?(another_model, attribute)
      # The proc must return TRUE if a given attribute
      # is VALID and FLASE if it IS INVALID
      attribute_value = another_model.send(attribute)

      proc.call(attribute, attribute_value)
    end

    # Check attributes
    # Check has_one associations
    # Check has_many associations
    def check_all_attributes(another_model)
      check_attributes(another_model)
      check_has_one_relationships(another_model)
      check_has_many_relationships(another_model)
    end

    def check_attributes(another_model)
      # Check attributes
      return nil if another_model.nil?

      another_model.attributes.keys.each do |attribute|
        if another_model.has_attribute? attribute
          # Increase the present attributes if the attribute IS VALID
          #
          # Otherwise, increase the missing attributes
          if is_attribute_valid?(another_model, attribute)
            increase_present_attributes(another_model, attribute)
          else
            increase_missing_attributes(another_model, attribute)
          end
        end
      end
    end

    # Check has_one
    def check_has_one_relationships(another_model)
      return nil if another_model.nil?

      check_associations(another_model, :has_one)
    end

    # Check has_many
    def check_has_many_relationships(another_model)
      return nil if another_model.nil?

      check_associations(another_model, :has_many)
    end


    def check_associations(another_model, symbol)
      return nil if another_model.nil?

      another_model.class.reflect_on_all_associations(symbol).each do |reflect|
        # If the association is present, enter
        if another_model.respond_to? reflect.name
          # In case of has_many relationship,
          # the response to respond_to? reflect.name
          # is an array > 0
          if another_model.send(reflect.name).respond_to?('each')
            another_model.send(reflect.name).each do |value|
              check_all_attributes value
            end
          else
            # If it's not able to respond_to each,
            # it means it is a simple thing
            check_all_attributes another_model.send(reflect.name)
          end
        end
      end
    end
  end
end