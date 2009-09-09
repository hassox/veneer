module Veneer
  module Errors
    class VeneerError     < StandardError; end
    
    class NotCompatible   < VeneerError; end
    class NotSaved         < VeneerError; end
  end
end
