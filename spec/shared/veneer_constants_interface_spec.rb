describe "it has the required Veneer constants", :shared => true do
  it "should have a correctly setup spec" do
    @klass.should be_a(Class)
    @instance.should be_an_instance_of(@klass)
  end
  
  it "should have a VeneerInterface constant" do
    lambda do
      @klass::VeneerInterface
    end.should_not raise_error(NameError)
  end

  it "should have a VeneerInterface::ClassWrapper" do
    lambda do
      @klass::VeneerInterface::ClassWrapper
    end.should_not raise_error(NameError)
  end
  
  it "should inherit from Veneer::Base::ClassWrapper" do
      @klass::VeneerInterface::ClassWrapper.ancestors.should include(::Veneer::Base::ClassWrapper)
  end

  it "should create a VeneerInterface::ClassWrapper from the class" do
    Veneer(@klass).should be_an_instance_of(@klass::VeneerInterface::ClassWrapper)
  end
  
    
  it "should create a VeneerInterface::InstanceWrapper from the instance" do
    Veneer(@instance).should be_an_instance_of(@klass::VeneerInterface::InstanceWrapper)
  end
end
