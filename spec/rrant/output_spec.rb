require 'spec_helper'
require 'rrant_helper'

describe Rrant::Output do
  context '#in' do
    let(:rant) { RrantHelper.fake_rant(1, false, true) }
    let(:output_obj) { described_class.new(rant, false) }

    it 'returns rant as a hash' do
      expect(output_obj.in).to include(rant)
    end
  end

  context '#out without image' do
    let(:rant) { RrantHelper.fake_rant(1, false, true) }
    let(:output_obj) {
      described_class.new(rant, false)
    }

    it 'puts rant and image to STDOUT' do
      expect(STDOUT).to receive(:puts).with(rant['text'])
      output_obj.out
    end
  end

  context '#out with image' do
    let(:rant) { RrantHelper.fake_rant(1, false, true) }
    let(:output_obj) {
      described_class.new(rant, true)
    }

    it 'puts rant and image to STDOUT' do
      28.times { expect(STDOUT).to receive(:puts) }
      output_obj.out
    end
  end
end
