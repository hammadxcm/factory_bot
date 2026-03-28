describe FactoryBot::Evaluator do
  it "accepts a build strategy and overrides" do
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null, name: "Test")

    expect(evaluator.__override_names__).to eq [:name]
  end

  it "defines singleton methods for each override" do
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null, name: "Test")

    expect(evaluator.name).to eq "Test"
  end

  it "caches the result of override evaluation" do
    count = 0
    override_value = proc { count += 1 }
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null)
    evaluator.singleton_class.define_attribute(:counter) { override_value.call }

    evaluator.counter
    evaluator.counter

    expect(count).to eq 1
  end

  it "caches nil values" do
    count = 0
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null)
    evaluator.singleton_class.define_attribute(:nilattr) {
      count += 1
      nil
    }

    2.times { evaluator.nilattr }

    expect(count).to eq 1
  end

  it "returns the override keys" do
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null, name: "Test", age: 30)

    expect(evaluator.__override_names__).to match_array [:name, :age]
  end

  it "returns an empty array when there are no overrides" do
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null)

    expect(evaluator.__override_names__).to eq []
  end

  it "defaults instance to nil" do
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null)

    expect(evaluator.instance).to be_nil
  end

  it "allows instance to be set and retrieved" do
    evaluator = FactoryBot::Evaluator.new(FactoryBot::Strategy::Null)
    instance = double("instance")
    evaluator.instance = instance

    expect(evaluator.instance).to eq instance
  end

  it "returns an AttributeList from attribute_list" do
    klass = Class.new(FactoryBot::Evaluator)
    klass.attribute_lists = []

    expect(klass.attribute_list).to be_a FactoryBot::AttributeList
  end

  it "defines a method on the class with define_attribute" do
    klass = Class.new(FactoryBot::Evaluator)
    klass.define_attribute(:test_attr) { "value" }
    evaluator = klass.new(FactoryBot::Strategy::Null)

    expect(evaluator.test_attr).to eq "value"
  end

  it "replaces existing methods without error" do
    klass = Class.new(FactoryBot::Evaluator)
    klass.define_attribute(:test_attr) { "first" }
    klass.define_attribute(:test_attr) { "second" }
    evaluator = klass.new(FactoryBot::Strategy::Null)

    expect(evaluator.test_attr).to eq "second"
  end
end
