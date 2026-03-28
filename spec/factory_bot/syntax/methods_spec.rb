describe FactoryBot::Syntax::Methods do
  it "returns the next value in a sequence via generate" do
    FactoryBot.define do
      sequence(:syntax_methods_counter) { |n| n }
    end
    test_object = Object.new.extend(FactoryBot::Syntax::Methods)

    expect(test_object.generate(:syntax_methods_counter)).to be_a Integer
  end

  it "raises KeyError for an unregistered sequence via generate" do
    test_object = Object.new.extend(FactoryBot::Syntax::Methods)

    expect {
      test_object.generate(:nonexistent_sequence_xyz)
    }.to raise_error(KeyError, /Sequence not registered/)
  end

  it "returns an array of sequential values via generate_list" do
    FactoryBot.define do
      sequence(:syntax_methods_list_counter) { |n| "item_#{n}" }
    end
    test_object = Object.new.extend(FactoryBot::Syntax::Methods)
    results = test_object.generate_list(:syntax_methods_list_counter, 3)

    expect(results.length).to eq 3
    expect(results).to all(be_a(String))
  end

  it "raises KeyError for an unregistered sequence via generate_list" do
    test_object = Object.new.extend(FactoryBot::Syntax::Methods)

    expect {
      test_object.generate_list(:nonexistent_list_sequence_xyz, 3)
    }.to raise_error(KeyError, /Sequence not registered/)
  end
end
