if defined?(ActiveRecord::Base)
  if ActiveRecord::VERSION::MAJOR < 3
    require 'veneer/adapters/activerecord/pre_3.0_class_wrapper'
    require 'veneer/adapters/activerecord/pre_3.0_instance_wrapper'
  else
    require 'veneer/adapters/activerecord/class_wrapper'
    require 'veneer/adapters/activerecord/instance_wrapper'
  end
end
