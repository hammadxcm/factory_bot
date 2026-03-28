describe FactoryBot::Decorator::InvocationTracker do
  it "tracks method names that are called" do
    component = double("component", foo: nil, bar: nil)
    tracker = FactoryBot::Decorator::InvocationTracker.new(component)

    tracker.foo
    tracker.bar

    expect(tracker.__invoked_methods__).to eq [:foo, :bar]
  end

  it "forwards method calls to the component" do
    component = double("component", foo: "result")
    tracker = FactoryBot::Decorator::InvocationTracker.new(component)

    expect(tracker.foo).to eq "result"
  end

  it "forwards arguments to the component" do
    component = double("component")
    allow(component).to receive(:foo).with(1, "two").and_return("result")
    tracker = FactoryBot::Decorator::InvocationTracker.new(component)

    expect(tracker.foo(1, "two")).to eq "result"
  end

  it "returns unique method names" do
    component = double("component", foo: nil)
    tracker = FactoryBot::Decorator::InvocationTracker.new(component)

    tracker.foo
    tracker.foo

    expect(tracker.__invoked_methods__).to eq [:foo]
  end

  it "returns an empty array when no methods have been called" do
    component = double("component")
    tracker = FactoryBot::Decorator::InvocationTracker.new(component)

    expect(tracker.__invoked_methods__).to eq []
  end
end
