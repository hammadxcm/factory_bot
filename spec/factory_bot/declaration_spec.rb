describe FactoryBot::Declaration do
  it "returns the name given during initialization" do
    declaration = FactoryBot::Declaration.new(:username)

    expect(declaration.name).to eq :username
  end

  it "delegates to_attributes to the build method" do
    declaration = FactoryBot::Declaration.new(:username)

    expect { declaration.to_attributes }.to raise_error(NameError)
  end

  it "defaults ignored to false" do
    declaration = FactoryBot::Declaration.new(:username)

    expect(declaration.send(:ignored)).to be false
  end

  it "allows ignored to be set to true" do
    declaration = FactoryBot::Declaration.new(:username, true)

    expect(declaration.send(:ignored)).to be true
  end
end
