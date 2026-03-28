describe FactoryBot::Configuration do
  it "creates a factories registry that responds to register and find" do
    config = FactoryBot::Configuration.new

    expect(config.factories).to respond_to(:register)
    expect(config.factories).to respond_to(:find)
  end

  it "creates a sequences registry that responds to register and find" do
    config = FactoryBot::Configuration.new

    expect(config.sequences).to respond_to(:register)
    expect(config.sequences).to respond_to(:find)
  end

  it "creates a traits registry that responds to register and find" do
    config = FactoryBot::Configuration.new

    expect(config.traits).to respond_to(:register)
    expect(config.traits).to respond_to(:find)
  end

  it "creates a strategies registry" do
    config = FactoryBot::Configuration.new

    expect(config.strategies).to be_a FactoryBot::Registry
  end

  it "creates an empty callback_names set" do
    config = FactoryBot::Configuration.new

    expect(config.callback_names).to be_a Set
    expect(config.callback_names).to be_empty
  end

  it "creates an empty inline_sequences array" do
    config = FactoryBot::Configuration.new

    expect(config.inline_sequences).to eq []
  end

  it "defines a constructor via initialize_with" do
    config = FactoryBot::Configuration.new
    custom_block = -> { "custom" }
    config.initialize_with(&custom_block)

    expect(config.constructor).to eq custom_block
  end

  it "delegates to_create to the definition" do
    config = FactoryBot::Configuration.new

    expect(config).to respond_to(:to_create)
  end

  it "delegates skip_create to the definition" do
    config = FactoryBot::Configuration.new

    expect(config).to respond_to(:skip_create)
  end

  it "delegates callbacks to the definition" do
    config = FactoryBot::Configuration.new

    expect(config.callbacks).to eq []
  end
end
