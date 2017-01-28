require "spec_helper"

describe Rrant do
  let (:store) { double :store }

  it "has a version number" do
    expect(Rrant::VERSION).not_to be nil
  end

  it "creates new store object without options" do
    expect(Rrant).to receive(:and).and_return(:store)
    Rrant.and
  end
end
