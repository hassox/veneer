module Kernel
  def Veneer(obj, opts = {})
    case obj
    when Class
      obj::VeneerInterface::ClassWrapper.new(obj, opts)
    else
      obj.class::VeneerInterface::InstanceWrapper.new(obj, opts)
    end
  rescue NameError => e
    raise Veneer::Errors::NotCompatible
  end # Veneer()
end
