describe FactoryBot::DefinitionHierarchy do
  it "defines a to_create method when the definition has one" do
    definition = double("definition",
      to_create: -> { "custom create" },
      constructor: nil,
      callbacks: [])
    hierarchy_class = Class.new(FactoryBot::DefinitionHierarchy)
    hierarchy_class.build_from_definition(definition)

    expect(hierarchy_class.new.to_create).to eq definition.to_create
  end

  it "defines a constructor method when the definition has one" do
    constructor_block = -> { "custom constructor" }
    definition = double("definition",
      to_create: nil,
      constructor: constructor_block,
      callbacks: [])
    hierarchy_class = Class.new(FactoryBot::DefinitionHierarchy)
    hierarchy_class.build_from_definition(definition)

    expect(hierarchy_class.new.constructor).to eq constructor_block
  end

  it "adds callbacks when the definition has them" do
    callback = double("callback")
    definition = double("definition",
      to_create: nil,
      constructor: nil,
      callbacks: [callback])
    hierarchy_class = Class.new(FactoryBot::DefinitionHierarchy)
    hierarchy_class.build_from_definition(definition)

    expect(hierarchy_class.new.callbacks).to include(callback)
  end

  it "falls back to Internal defaults when the definition has no values" do
    definition = double("definition",
      to_create: nil,
      constructor: nil,
      callbacks: [])
    hierarchy_class = Class.new(FactoryBot::DefinitionHierarchy)
    hierarchy_class.build_from_definition(definition)

    expect(hierarchy_class.new.callbacks).to eq FactoryBot::Internal.callbacks
  end
end
