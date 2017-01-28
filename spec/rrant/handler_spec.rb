require "spec_helper"

describe Rrant::Handler do
  let(:store) { described_class.new }

  it 'returns self when receives and' do
    expect(store.and).to eq(store)
  end

  it 'sets unseen when receives unseen' do
    store.unseen
    expect(store.instance_variable_get(:@unseen)).to eq(true)
  end

  it 'returns self when receives unseen' do
    expect(store.unseen).to eq(store)
  end
end
