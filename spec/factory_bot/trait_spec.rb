describe FactoryBot::Trait do
  it "converts the name to a string" do
    trait = FactoryBot::Trait.new(:admin)

    expect(trait.name).to eq "admin"
  end

  it "evaluates the block via DefinitionProxy" do
    trait = FactoryBot::Trait.new(:admin) do
      add_attribute(:role) { "admin" }
    end

    expect(trait.attributes.to_a.length).to be >= 1
  end

  it "does not raise without a block" do
    expect { FactoryBot::Trait.new(:admin) }.not_to raise_error
  end

  it "returns an array containing the trait name" do
    trait = FactoryBot::Trait.new(:admin)

    expect(trait.names).to eq ["admin"]
  end

  it "clones with the same name" do
    trait = FactoryBot::Trait.new(:admin) do
      add_attribute(:role) { "admin" }
    end
    cloned = trait.clone

    expect(cloned.name).to eq trait.name
  end

  it "clones into a distinct object" do
    trait = FactoryBot::Trait.new(:admin)
    cloned = trait.clone

    expect(cloned).not_to equal trait
  end

  it "is equal to a trait with the same name and block" do
    block = proc { add_attribute(:role) { "admin" } }
    trait1 = FactoryBot::Trait.new(:admin, &block)
    trait2 = FactoryBot::Trait.new(:admin, &block)

    expect(trait1).to eq trait2
  end

  it "is not equal to a trait with a different name" do
    block = proc {}
    trait1 = FactoryBot::Trait.new(:admin, &block)
    trait2 = FactoryBot::Trait.new(:member, &block)

    expect(trait1).not_to eq trait2
  end

  it "is not equal to a trait with a different block" do
    trait1 = FactoryBot::Trait.new(:admin) { add_attribute(:a) { 1 } }
    trait2 = FactoryBot::Trait.new(:admin) { add_attribute(:b) { 2 } }

    expect(trait1).not_to eq trait2
  end

  it "delegates add_callback to its definition" do
    trait = FactoryBot::Trait.new(:with_callback)
    expect(trait.definition).to receive(:add_callback).with(anything)
    trait.add_callback(double("callback"))
  end

  it "delegates callbacks to its definition" do
    trait = FactoryBot::Trait.new(:with_callback)

    expect(trait.callbacks).to eq trait.definition.callbacks
  end
end
