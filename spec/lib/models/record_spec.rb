require "spec_helper"
require "models/record"

class TestRecord < Record
  attributes %I[
    test
    testing
  ]
end

RSpec.describe TestRecord do
  it "assigns permitted attributes" do
    record = described_class.new(test: "123")
    expect(record.test).to eq("123")
    expect(record.testing).to eq(nil)
    expect(record.respond_to?(:nonattribute)).to eq(false)

    record = described_class.new(test: "123", testing: "567")
    expect(record.test).to eq("123")
    expect(record.testing).to eq("567")

    record = described_class.new(test: "123", nonattribute: "567")
    expect(record.test).to eq("123")
    expect(record.respond_to?(:nonattribute)).to eq(false)
  end
end
