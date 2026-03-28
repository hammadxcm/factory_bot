describe FactoryBot::Syntax::Default do
  it "registers a factory via FactoryBot.define" do
    define_class("SyntaxDefaultUser") { attr_accessor :name }

    FactoryBot.define do
      factory :syntax_default_user, class: "SyntaxDefaultUser" do
        name { "Test" }
      end
    end

    expect(FactoryBot::Internal.factory_by_name(:syntax_default_user)).to be_a FactoryBot::Factory
  end

  it "registers a sequence via FactoryBot.define" do
    FactoryBot.define do
      sequence(:syntax_default_email) { |n| "user#{n}@example.com" }
    end

    expect(FactoryBot.generate(:syntax_default_email)).to match(/user\d+@example\.com/)
  end

  it "registers a global trait via FactoryBot.define" do
    FactoryBot.define do
      trait :syntax_default_admin do
      end
    end

    expect(FactoryBot::Internal.traits.find(:syntax_default_admin)).to be_a FactoryBot::Trait
  end

  it "modifies an existing factory via FactoryBot.modify" do
    define_class("SyntaxModifyUser") { attr_accessor :name }
    FactoryBot.define do
      factory :syntax_modify_user, class: "SyntaxModifyUser" do
        name { "Original" }
      end
    end

    FactoryBot.modify do
      factory :syntax_modify_user do
        name { "Modified" }
      end
    end

    user = FactoryBot.build(:syntax_modify_user)
    expect(user.name).to eq "Modified"
  end

  it "handles child factories" do
    define_class("SyntaxChildUser") { attr_accessor :name, :role }
    FactoryBot.define do
      factory :syntax_child_user, class: "SyntaxChildUser" do
        name { "Test" }

        factory :syntax_child_admin do
          role { "admin" }
        end
      end
    end

    admin = FactoryBot.build(:syntax_child_admin)
    expect(admin.name).to eq "Test"
    expect(admin.role).to eq "admin"
  end

  it "evaluates blocks in the context of a new DSL instance" do
    define_class("SyntaxRunUser") { attr_accessor :name }
    block = proc {
      factory :syntax_run_user, class: "SyntaxRunUser" do
        name { "from block" }
      end
    }

    FactoryBot::Syntax::Default::DSL.run(block)

    user = FactoryBot.build(:syntax_run_user)
    expect(user.name).to eq "from block"
  end
end
