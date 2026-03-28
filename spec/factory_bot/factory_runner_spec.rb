describe FactoryBot::FactoryRunner do
  it "looks up and runs the factory" do
    factory = double("factory", compile: nil, run: "result")
    allow(factory).to receive(:with_traits).and_return(factory)
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    runner = FactoryBot::FactoryRunner.new(:user, :build, [])

    runner.run

    expect(factory).to have_received(:compile)
    expect(factory).to have_received(:run).with(:build, {})
  end

  it "applies traits when present" do
    factory = double("factory", compile: nil, run: "result")
    factory_with_traits = double("factory_with_traits", run: "result")
    allow(factory).to receive(:with_traits).with([:admin]).and_return(factory_with_traits)
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    runner = FactoryBot::FactoryRunner.new(:user, :build, [:admin])

    runner.run

    expect(factory).to have_received(:with_traits).with([:admin])
    expect(factory_with_traits).to have_received(:run).with(:build, {})
  end

  it "does not call with_traits when no traits are given" do
    factory = double("factory", compile: nil, run: "result")
    allow(factory).to receive(:with_traits)
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    runner = FactoryBot::FactoryRunner.new(:user, :build, [])

    runner.run

    expect(factory).not_to have_received(:with_traits)
  end

  it "passes overrides to the factory" do
    factory = double("factory", compile: nil, run: "result")
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    runner = FactoryBot::FactoryRunner.new(:user, :build, [{name: "Test"}])

    runner.run

    expect(factory).to have_received(:run).with(:build, {name: "Test"})
  end

  it "fires before_run_factory instrumentation event" do
    factory = double("factory", compile: nil, run: "result")
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    events = []
    subscription = ActiveSupport::Notifications.subscribe("factory_bot.before_run_factory") do |*args|
      events << args
    end
    runner = FactoryBot::FactoryRunner.new(:user, :build, [])

    runner.run

    expect(events.length).to eq 1
  ensure
    ActiveSupport::Notifications.unsubscribe(subscription)
  end

  it "fires run_factory instrumentation event" do
    factory = double("factory", compile: nil, run: "result")
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    events = []
    subscription = ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |*args|
      events << args
    end
    runner = FactoryBot::FactoryRunner.new(:user, :build, [])

    runner.run

    expect(events.length).to eq 1
  ensure
    ActiveSupport::Notifications.unsubscribe(subscription)
  end

  it "accepts a different runner strategy" do
    factory = double("factory", compile: nil, run: "result")
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    runner = FactoryBot::FactoryRunner.new(:user, :build, [])

    runner.run(:create)

    expect(factory).to have_received(:run).with(:create, {})
  end

  it "yields the block to the factory" do
    block_called = false
    factory = double("factory", compile: nil)
    allow(factory).to receive(:run) { |*, &block| block&.call }
    allow(FactoryBot::Internal).to receive(:factory_by_name).with(:user).and_return(factory)
    runner = FactoryBot::FactoryRunner.new(:user, :build, [])

    runner.run { block_called = true }

    expect(block_called).to be true
  end
end
