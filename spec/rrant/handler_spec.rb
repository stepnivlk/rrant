require "spec_helper"
require 'rrant_helper'

describe Rrant::Handler do
  context 'calling configuration methods' do
    let(:handler) { described_class.new }

    after(:all) do
      RrantHelper.delete_root_path
    end

    it 'returns self when receives and' do
      expect(handler.and).to eq(handler)
    end

    it 'sets unseen when receives unseen' do
      handler.unseen(true)
      expect(handler.instance_variable_get(:@unseen)).to eq(true)
    end

    it 'returns self when receives unseen' do
      expect(handler.unseen).to eq(handler)
    end

    it 'sets with_images when receives with_images' do
      handler.with_images(false)
      expect(handler.instance_variable_get(:@show_images)).to eq(false)
    end

    it 'returns self when receives with_images' do
      expect(handler.with_images(true)).to eq(handler)
    end
  end

  context 'calling #rave' do
    let(:handler) { described_class.new }

    after(:all) do
      RrantHelper.delete_root_path
    end

    it 'returns output' do
      expect(handler.rave).to be_instance_of(Rrant::Output)
    end

    it 'passes call to Otput and returns rant hash' do
      expect(handler.rave.in).to include(RrantHelper.fake_placeholder)
    end
  end
end
