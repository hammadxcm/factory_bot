describe FactoryBot::AttributeAssigner do
  it "builds an instance and assigns attributes" do
    build_class = define_class("User") { attr_accessor :name }
    attribute = double("name",
      name: :name, ignored: false, association?: false,
      alias_for?: false, to_proc: -> { "Test" })
    definer = FactoryBot::EvaluatorClassDefiner.new([attribute], FactoryBot::Evaluator)
    evaluator = definer.evaluator_class.new(FactoryBot::Strategy::Null)
    assigner = FactoryBot::AttributeAssigner.new(evaluator, build_class) { new }

    result = assigner.object

    expect(result).to be_a build_class
    expect(result.name).to eq "Test"
  end

  it "does not assign ignored (transient) attributes to the instance" do
    build_class = define_class("User") { attr_accessor :name }
    ignored_attr = double("admin",
      name: :admin, ignored: true, association?: false,
      alias_for?: false, to_proc: -> { true })
    regular_attr = double("name",
      name: :name, ignored: false, association?: false,
      alias_for?: false, to_proc: -> { "Test" })
    definer = FactoryBot::EvaluatorClassDefiner.new([ignored_attr, regular_attr], FactoryBot::Evaluator)
    evaluator = definer.evaluator_class.new(FactoryBot::Strategy::Null)
    assigner = FactoryBot::AttributeAssigner.new(evaluator, build_class) { new }

    result = assigner.object

    expect(result.name).to eq "Test"
  end

  it "sets the evaluator instance to the built object" do
    build_class = define_class("User")
    definer = FactoryBot::EvaluatorClassDefiner.new([], FactoryBot::Evaluator)
    evaluator = definer.evaluator_class.new(FactoryBot::Strategy::Null)
    assigner = FactoryBot::AttributeAssigner.new(evaluator, build_class) { new }

    assigner.object

    expect(evaluator.instance).to be_a build_class
  end

  it "returns a hash of attribute values" do
    build_class = define_class("User") { attr_accessor :name }
    attribute = double("name",
      name: :name, ignored: false, association?: false,
      alias_for?: false, to_proc: -> { "Test" })
    definer = FactoryBot::EvaluatorClassDefiner.new([attribute], FactoryBot::Evaluator)
    evaluator = definer.evaluator_class.new(FactoryBot::Strategy::Null)
    assigner = FactoryBot::AttributeAssigner.new(evaluator, build_class) { new }

    result = assigner.hash

    expect(result).to be_a Hash
    expect(result[:name]).to eq "Test"
  end

  it "excludes association attributes from the hash" do
    build_class = define_class("User") { attr_accessor :name }
    regular_attr = double("name",
      name: :name, ignored: false, association?: false,
      alias_for?: false, to_proc: -> { "Test" })
    assoc_attr = double("account",
      name: :account, ignored: false, association?: true,
      alias_for?: false, to_proc: -> {})
    definer = FactoryBot::EvaluatorClassDefiner.new([regular_attr, assoc_attr], FactoryBot::Evaluator)
    evaluator = definer.evaluator_class.new(FactoryBot::Strategy::Null)
    assigner = FactoryBot::AttributeAssigner.new(evaluator, build_class) { new }

    result = assigner.hash

    expect(result).to have_key(:name)
    expect(result).not_to have_key(:account)
  end

  it "sets the evaluator instance after building the hash" do
    build_class = define_class("User")
    definer = FactoryBot::EvaluatorClassDefiner.new([], FactoryBot::Evaluator)
    evaluator = definer.evaluator_class.new(FactoryBot::Strategy::Null)
    assigner = FactoryBot::AttributeAssigner.new(evaluator, build_class) { new }

    assigner.hash

    expect(evaluator.instance).not_to be_nil
  end
end
