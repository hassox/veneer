describe "it implements create with valid attributes", :shared => true do
  it "should setup the spec correctly" do
    @klass.should_not be_nil
    @klass.should be_a(Class)
    @valid_attributes.should_not be_nil
    @valid_attributes.should be_a_kind_of(Hash)
  end
  
    it "should create the object from the hash" do
      r = Veneer(@klass).create(@valid_attributes)
      r.should be_an_instance_of(@klass::VeneerInterface::InstanceWrapper)
    end
    
    it "should create the object from the hash with create!" do
      r = Veneer(@klass).create!(@valid_attributes)
      r.should be_an_instance_of(@klass::VeneerInterface::InstanceWrapper)
    end
    
    it "should create a new instance of the object" do
      r = Veneer(@klass).new(@valid_attributes)
      r.should be_an_instance_of(@klass::VeneerInterface::InstanceWrapper)
    end
end

describe "it implements create with invalid attributes", :shared => true do
  it "should setup the spec correctly" do
    @klass.should_not be_nil
    @klass.should be_a(Class)
    @invalid_attributes.should_not be_nil
    @invalid_attributes.should be_a_kind_of(Hash)
  end

  it "should create the object without an exception" do
    lambda do 
      r = Veneer(@klass).create(@invalid_attributes)
      r.should be_an_instance_of(@klass::VeneerInterface::InstanceWrapper)
    end.should_not raise_error
  end

  it "should not raise an exception with new" do
    lambda do
      r = Veneer(@klass).new(@invalid_attributes)
      r.should be_an_instance_of(@klass::VeneerInterface::InstanceWrapper)
    end.should_not raise_error
  end
  
  it "should raise an exception with create!" do
    lambda do
      Veneer(@klass).new(@invalid_attributes)
    end.should_not raise_error(Veneer::Errors::NotSaved)
  end
end



