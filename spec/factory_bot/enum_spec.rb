describe FactoryBot::Enum do
  it "creates traits from explicit hash values" do
    enum = FactoryBot::Enum.new(:status, {active: 0, inactive: 1})
    traits = enum.build_traits(double("klass"))

    expect(traits.length).to eq 2
    expect(traits.map(&:name)).to match_array %w[active inactive]
  end

  it "creates traits from explicit array values" do
    enum = FactoryBot::Enum.new(:status, %w[active inactive])
    traits = enum.build_traits(double("klass"))

    expect(traits.length).to eq 2
    expect(traits.map(&:name)).to match_array %w[active inactive]
  end

  it "creates traits from class method when no values provided" do
    enum = FactoryBot::Enum.new(:status)
    klass = double("klass")
    allow(klass).to receive(:statuses).and_return(active: 0, inactive: 1)
    traits = enum.build_traits(klass)

    expect(traits.length).to eq 2
    expect(traits.map(&:name)).to match_array %w[active inactive]
  end

  it "returns Trait instances" do
    enum = FactoryBot::Enum.new(:status, {active: 0})
    traits = enum.build_traits(double("klass"))

    expect(traits.first).to be_a FactoryBot::Trait
  end

  it "returns an empty array when there are no enum values" do
    enum = FactoryBot::Enum.new(:status, {})
    traits = enum.build_traits(double("klass"))

    expect(traits).to be_empty
  end
end
