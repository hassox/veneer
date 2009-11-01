module Kernel
  def Veneer(obj, opts = {})
    case obj
    when Class
      obj::VeneerInterface::ClassWrapper.new(obj, opts)
    when Veneer::Base::ClassWrapper, Veneer::Base::InstanceWrapper
      obj
    when nil
      nil
    else
      obj.class::VeneerInterface::InstanceWrapper.new(obj, opts)
    end
  rescue NameError => e
    puts e.message
    raise Veneer::Errors::NotCompatible
  end # Veneer()
end
