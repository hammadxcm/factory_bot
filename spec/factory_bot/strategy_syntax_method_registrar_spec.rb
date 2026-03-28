describe FactoryBot::StrategySyntaxMethodRegistrar do
  it "defines a singular strategy method" do
    registrar = FactoryBot::StrategySyntaxMethodRegistrar.new(:test_strategy)
    registrar.define_strategy_methods

    expect(FactoryBot::Syntax::Methods.method_defined?(:test_strategy)).to be true
  ensure
    FactoryBot::Syntax::Methods.undef_method(:test_strategy) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy)
    FactoryBot::Syntax::Methods.undef_method(:test_strategy_list) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy_list)
    FactoryBot::Syntax::Methods.undef_method(:test_strategy_pair) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy_pair)
  end

  it "defines a list strategy method" do
    registrar = FactoryBot::StrategySyntaxMethodRegistrar.new(:test_strategy2)
    registrar.define_strategy_methods

    expect(FactoryBot::Syntax::Methods.method_defined?(:test_strategy2_list)).to be true
  ensure
    FactoryBot::Syntax::Methods.undef_method(:test_strategy2) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy2)
    FactoryBot::Syntax::Methods.undef_method(:test_strategy2_list) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy2_list)
    FactoryBot::Syntax::Methods.undef_method(:test_strategy2_pair) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy2_pair)
  end

  it "defines a pair strategy method" do
    registrar = FactoryBot::StrategySyntaxMethodRegistrar.new(:test_strategy3)
    registrar.define_strategy_methods

    expect(FactoryBot::Syntax::Methods.method_defined?(:test_strategy3_pair)).to be true
  ensure
    FactoryBot::Syntax::Methods.undef_method(:test_strategy3) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy3)
    FactoryBot::Syntax::Methods.undef_method(:test_strategy3_list) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy3_list)
    FactoryBot::Syntax::Methods.undef_method(:test_strategy3_pair) if FactoryBot::Syntax::Methods.method_defined?(:test_strategy3_pair)
  end

  it "wraps the block with index when arity is 2" do
    block = ->(instance, index) { [instance, index] }
    wrapped = FactoryBot::StrategySyntaxMethodRegistrar.with_index(block, 5)

    expect(wrapped.call("instance")).to eq ["instance", 5]
  end

  it "returns the original block when arity is not 2" do
    block = ->(instance) { instance }

    expect(FactoryBot::StrategySyntaxMethodRegistrar.with_index(block, 5)).to eq block
  end

  it "returns nil when block is nil" do
    expect(FactoryBot::StrategySyntaxMethodRegistrar.with_index(nil, 5)).to be_nil
  end
end
