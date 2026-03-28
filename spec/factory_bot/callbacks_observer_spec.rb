describe FactoryBot::CallbacksObserver do
  it "runs callbacks matching the given name" do
    evaluator = double("evaluator")
    callback = double("callback", name: :after_create)
    allow(callback).to receive(:run)
    observer = FactoryBot::CallbacksObserver.new([callback], evaluator)
    instance = double("instance")

    observer.update(:after_create, instance)

    expect(callback).to have_received(:run).with(instance, evaluator)
  end

  it "does not run callbacks that do not match the given name" do
    evaluator = double("evaluator")
    callback = double("callback", name: :after_build)
    allow(callback).to receive(:run)
    observer = FactoryBot::CallbacksObserver.new([callback], evaluator)
    instance = double("instance")

    observer.update(:after_create, instance)

    expect(callback).not_to have_received(:run)
  end

  it "runs multiple callbacks matching the given name" do
    evaluator = double("evaluator")
    callback1 = double("callback1", name: :after_create)
    callback2 = double("callback2", name: :after_create)
    allow(callback1).to receive(:run)
    allow(callback2).to receive(:run)
    observer = FactoryBot::CallbacksObserver.new([callback1, callback2], evaluator)
    instance = double("instance")

    observer.update(:after_create, instance)

    expect(callback1).to have_received(:run).with(instance, evaluator)
    expect(callback2).to have_received(:run).with(instance, evaluator)
  end

  it "does not run the same callback twice for the same instance" do
    evaluator = double("evaluator")
    callback = double("callback", name: :after_create)
    allow(callback).to receive(:run)
    observer = FactoryBot::CallbacksObserver.new([callback], evaluator)
    instance = double("instance")

    observer.update(:after_create, instance)
    observer.update(:after_create, instance)

    expect(callback).to have_received(:run).once
  end

  it "runs the same callback for different instances" do
    evaluator = double("evaluator")
    callback = double("callback", name: :after_create)
    allow(callback).to receive(:run)
    observer = FactoryBot::CallbacksObserver.new([callback], evaluator)
    instance1 = double("instance1")
    instance2 = double("instance2")

    observer.update(:after_create, instance1)
    observer.update(:after_create, instance2)

    expect(callback).to have_received(:run).with(instance1, evaluator)
    expect(callback).to have_received(:run).with(instance2, evaluator)
  end

  it "runs different callbacks for the same instance" do
    evaluator = double("evaluator")
    callback1 = double("callback1", name: :after_create)
    callback2 = double("callback2", name: :after_build)
    allow(callback1).to receive(:run)
    allow(callback2).to receive(:run)
    observer = FactoryBot::CallbacksObserver.new([callback1, callback2], evaluator)
    instance = double("instance")

    observer.update(:after_create, instance)
    observer.update(:after_build, instance)

    expect(callback1).to have_received(:run).with(instance, evaluator)
    expect(callback2).to have_received(:run).with(instance, evaluator)
  end

  it "handles an empty callback list" do
    evaluator = double("evaluator")
    observer = FactoryBot::CallbacksObserver.new([], evaluator)
    instance = double("instance")

    expect { observer.update(:after_create, instance) }.not_to raise_error
  end
end
