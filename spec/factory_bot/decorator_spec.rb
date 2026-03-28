describe FactoryBot::Decorator do
  it "forwards method calls to the component" do
    component = double("component", foo: "bar")
    decorator = FactoryBot::Decorator.new(component)

    expect(decorator.foo).to eq "bar"
  end

  it "forwards method calls with arguments" do
    component = double("component")
    allow(component).to receive(:foo).with(1, 2).and_return("result")
    decorator = FactoryBot::Decorator.new(component)

    expect(decorator.foo(1, 2)).to eq "result"
  end

  it "forwards method calls with blocks" do
    component = Object.new
    def component.foo(&block) = block.call
    decorator = FactoryBot::Decorator.new(component)

    expect(decorator.foo { "yielded" }).to eq "yielded"
  end

  it "delegates send to __send__" do
    component = double("component", foo: "bar")
    decorator = FactoryBot::Decorator.new(component)

    expect(decorator.send(:foo)).to eq "bar"
  end

  it "returns true from respond_to? when the component responds to the method" do
    component = double("component", foo: "bar")
    decorator = FactoryBot::Decorator.new(component)

    expect(decorator.respond_to?(:foo)).to be true
  end

  it "returns false from respond_to? when the component does not respond" do
    component = double("component")
    decorator = FactoryBot::Decorator.new(component)

    expect(decorator.respond_to?(:nonexistent)).to be false
  end

  it "resolves constants from Object" do
    expect(FactoryBot::Decorator::String).to eq ::String
  end
end
