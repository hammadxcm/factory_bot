describe FactoryBot::Evaluation do
  it "delegates object to the attribute assigner" do
    evaluator = double("evaluator")
    attribute_assigner = double("attribute_assigner")
    instance = double("instance")
    allow(attribute_assigner).to receive(:object).and_return(instance)
    observer = double("observer")
    evaluation = FactoryBot::Evaluation.new(evaluator, attribute_assigner, ->(obj) {}, observer)

    expect(evaluation.object).to eq instance
  end

  it "delegates hash to the attribute assigner" do
    evaluator = double("evaluator")
    attribute_assigner = double("attribute_assigner")
    hash_result = {name: "Test"}
    allow(attribute_assigner).to receive(:hash).and_return(hash_result)
    observer = double("observer")
    evaluation = FactoryBot::Evaluation.new(evaluator, attribute_assigner, ->(obj) {}, observer)

    expect(evaluation.hash).to eq hash_result
  end

  it "calls to_create with one argument when arity is not 2" do
    evaluator = double("evaluator")
    attribute_assigner = double("attribute_assigner")
    observer = double("observer")
    instance = double("instance")
    created_with = nil
    to_create = ->(obj) { created_with = obj }
    evaluation = FactoryBot::Evaluation.new(evaluator, attribute_assigner, to_create, observer)

    evaluation.create(instance)

    expect(created_with).to eq instance
  end

  it "calls to_create with instance and evaluator when arity is 2" do
    evaluator = double("evaluator")
    attribute_assigner = double("attribute_assigner")
    observer = double("observer")
    instance = double("instance")
    created_with = nil
    to_create = ->(obj, eval_arg) { created_with = [obj, eval_arg] }
    evaluation = FactoryBot::Evaluation.new(evaluator, attribute_assigner, to_create, observer)

    evaluation.create(instance)

    expect(created_with).to eq [instance, evaluator]
  end

  it "delegates notify to the observer" do
    evaluator = double("evaluator")
    attribute_assigner = double("attribute_assigner")
    observer = double("observer")
    allow(observer).to receive(:update)
    instance = double("instance")
    evaluation = FactoryBot::Evaluation.new(evaluator, attribute_assigner, ->(obj) {}, observer)

    evaluation.notify(:after_create, instance)

    expect(observer).to have_received(:update).with(:after_create, instance)
  end
end
