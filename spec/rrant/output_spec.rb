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
    let(:output_obj) { described_class.new(rant, false) }

    it 'puts rant and image to STDOUT' do
      footer = "\n\e[37m[\e[0mbill\e[37m][\e[0m640\e[37m][\e[0mhttps://www.devrant.io/rants/1\e[37m]\e[0m"
      expect(STDOUT).to receive(:puts).with(rant['text'])
      expect(STDOUT).to receive(:puts).with(footer)

      output_obj.out
    end
  end
end
