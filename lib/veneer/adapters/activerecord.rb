if defined?(ActiveRecord::Base)
  require 'veneer/adapters/activerecord/types'
  require 'veneer/adapters/activerecord/property'

  if ActiveRecord::VERSION::MAJOR < 3
    require 'veneer/adapters/activerecord/pre_3.0_class_wrapper'
    require 'veneer/adapters/activerecord/pre_3.0_instance_wrapper'
  else
    require 'veneer/adapters/activerecord/class_wrapper'
    require 'veneer/adapters/activerecord/instance_wrapper'
  end
end
