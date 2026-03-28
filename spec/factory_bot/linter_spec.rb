describe FactoryBot::Linter do
  it "does not raise when all factories are valid" do
    define_class("User") { attr_accessor :name }
    FactoryBot.define do
      factory :linter_user, class: "User" do
        name { "Test" }
      end
    end
    factories = FactoryBot.factories.select { |f| f.name == :linter_user }
    linter = FactoryBot::Linter.new(factories, strategy: :build)

    expect { linter.lint! }.not_to raise_error
  end

  it "raises InvalidFactoryError when a factory is invalid" do
    define_class("LinterFailModel") {
      def save!
        raise "validation failed"
      end
    }
    FactoryBot.define do
      factory :linter_fail_model, class: "LinterFailModel"
    end
    factories = FactoryBot.factories.select { |f| f.name == :linter_fail_model }
    linter = FactoryBot::Linter.new(factories, strategy: :create)

    expect { linter.lint! }.to raise_error(FactoryBot::InvalidFactoryError)
  end

  it "includes factory name in error message" do
    define_class("LinterBadModel") {
      def save!
        raise "cannot save"
      end
    }
    FactoryBot.define do
      factory :linter_bad_model, class: "LinterBadModel"
    end
    factories = FactoryBot.factories.select { |f| f.name == :linter_bad_model }
    linter = FactoryBot::Linter.new(factories, strategy: :create)

    expect { linter.lint! }.to raise_error(/linter_bad_model/)
  end
end

describe FactoryBot::Linter::FactoryError do
  it "formats error message with factory name and error details" do
    wrapped_error = RuntimeError.new("something went wrong")
    factory = double("factory", name: :user)
    error = FactoryBot::Linter::FactoryError.new(wrapped_error, factory)

    expect(error.message).to include("user")
    expect(error.message).to include("something went wrong")
    expect(error.message).to include("RuntimeError")
  end

  it "includes backtrace in verbose message" do
    wrapped_error = RuntimeError.new("something went wrong")
    wrapped_error.set_backtrace(["line1.rb:1", "line2.rb:2"])
    factory = double("factory", name: :user)
    error = FactoryBot::Linter::FactoryError.new(wrapped_error, factory)

    expect(error.verbose_message).to include("line1.rb:1")
    expect(error.verbose_message).to include("line2.rb:2")
  end
end

describe FactoryBot::Linter::FactoryTraitError do
  it "includes factory and trait name in location" do
    wrapped_error = RuntimeError.new("trait error")
    factory = double("factory", name: :user)
    error = FactoryBot::Linter::FactoryTraitError.new(wrapped_error, factory, :admin)

    expect(error.message).to include("user+admin")
  end
end
