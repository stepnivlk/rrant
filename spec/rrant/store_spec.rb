require "spec_helper"
require 'rrant_helper'
require 'rrant/error'

describe Rrant::Store do
  context 'correct path given' do
    let(:root_path) { "#{RrantHelper::root_path}/.rrant" }
    let(:store) { described_class.new(RrantHelper::root_path) }

    after(:all) do
      RrantHelper::delete_root_path
    end

    it "creates directory structure with store file" do
      store
      expect(Dir.exist?(root_path)).to eq(true)
      expect(Dir.exist?(root_path + '/images')).to eq(true)
      expect(File.exist?(root_path + '/store.pstore')).to eq(true)
    end

    it 'populate its readers' do
      expect(store.root).to eq(root_path)
      expect(store.images).to eq(root_path + '/images/')
      expect(store.store).to be_instance_of(PStore)
    end

    it 'initializes store with empty state' do
      expect(store.ids).to eq([])
      expect(store.entities).to eq([])
    end
  end

  context 'invalid path given' do
    it 'raises exception' do
      expect { described_class.new('invalidpath') }.to \
        raise_error(Rrant::Error::InvalidPath)
    end
  end
end
