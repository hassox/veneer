module Kernel
  def Veneer(obj)
    case obj
    when Class
      obj::VeneerInterface::ClassWrapper.new(obj)
    else
      obj.class::VeneerInterface::InstanceWrapper.new(obj)
    end
  rescue NameError => e
    raise Veneer::Errors::NotCompatible
  end # Veneer()
end
