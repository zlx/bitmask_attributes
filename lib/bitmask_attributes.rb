require 'bitmask_attributes/definition'
require 'bitmask_attributes/value_proxy'

module BitmaskAttributes
  extend ActiveSupport::Concern

  module ClassMethods
    def bitmask(attribute, options={}, &extension)
      unless options[:as] && options[:as].kind_of?(Array)
        raise ArgumentError, "Must provide an Array :as option"
      end

      bitmask_definitions[attribute] = Definition.new(attribute, options[:as].to_a,options[:null].nil? || options[:null], options[:zero_value], &extension)
      bitmask_definitions[attribute].install_on(self)
      @local = !descends_from_active_record?
    end

    def bitmask_definitions
      base_class.base_class_bitmask_definitions
    end

    def bitmasks
      base_class.base_class_bitmasks
    end

    protected

    def base_class_bitmask_definitions
      @bitmasks ||= {}
    end

    def base_class_bitmasks
      @bitmask_definitions ||= {}
    end
  end
end

ActiveRecord::Base.send :include, BitmaskAttributes