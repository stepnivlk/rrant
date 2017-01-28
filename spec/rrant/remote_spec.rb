require "spec_helper"
require 'rrant_helper'

describe Rrant::Remote do
  context 'correct store given, without images' do
    let(:store) { Rrant::Store.new(RrantHelper.root_path) }
    let(:remote) { described_class.new(store, false) }

    after(:all) do
      RrantHelper.delete_root_path
    end

    it 'initializes own state' do
      expect(remote.rants).to eq([])
    end

    it '#save remote rants and adds them to the store' do
      VCR.use_cassette('no_image_rants') do
        remote.save(40)
      end

      expect(remote.rants.size).to be >= 40
      expect(store.ids.size).to eq(remote.rants.size)
      expect(store.entities.size).to eq(remote.rants.size)
    end
  end

  context 'correct store given, with images' do
    let(:store) { Rrant::Store.new(RrantHelper.root_path) }
    let(:remote) { described_class.new(store) }

    after(:all) do
      RrantHelper.delete_root_path
    end

    it '#save remote rants and adds them to the store' do
      VCR.use_cassette('image_rants') do
        remote.save
      end

      expect(remote.rants.size).to be >= 10
      expect(store.ids.size).to eq(remote.rants.size)
      expect(store.entities.size).to eq(remote.rants.size)
    end
  end

  context 'invalid store given' do
    it 'raises error when store is not supported class' do
      expect { described_class.new('invalidstore') }.to \
        raise_error(Rrant::Error::InvalidStore)
    end
  end
end
