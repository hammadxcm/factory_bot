describe FactoryBot::Decorator::NewConstructor do
  it "delegates new to the build class" do
    component = double("component")
    build_class = double("build_class")
    instance = double("instance")
    allow(build_class).to receive(:new).and_return(instance)
    decorator = FactoryBot::Decorator::NewConstructor.new(component, build_class)

    expect(decorator.new).to eq instance
  end

  it "passes arguments to the build class" do
    component = double("component")
    build_class = double("build_class")
    instance = double("instance")
    allow(build_class).to receive(:new).with("arg1", "arg2").and_return(instance)
    decorator = FactoryBot::Decorator::NewConstructor.new(component, build_class)

    expect(decorator.new("arg1", "arg2")).to eq instance
  end

  it "forwards other methods to the component" do
    component = double("component", foo: "bar")
    build_class = double("build_class")
    decorator = FactoryBot::Decorator::NewConstructor.new(component, build_class)

    expect(decorator.foo).to eq "bar"
  end
end
