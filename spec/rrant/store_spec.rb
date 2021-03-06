require "spec_helper"
require 'rrant_helper'

describe Rrant::Store do
  context 'correct path given' do
    let(:root_path) { RrantHelper.root_path }
    let(:store) { described_class.new(RrantHelper.root_path) }
    let(:rrant_path) { root_path + '/.rrant' }
    let(:store_path) { root_path + '/.rrant/store.pstore' }
    let(:images_path) { root_path + '/.rrant/images/' }

    after(:all) do
      RrantHelper.delete_root_path
    end

    it "creates directory structure with store file" do
      store
      expect(Dir.exist?(rrant_path)).to eq(true)
      expect(Dir.exist?(images_path)).to eq(true)
      expect(File.exist?(store_path)).to eq(true)
    end

    it 'populate its readers' do
      expect(store.root).to eq(rrant_path)
      expect(store.images).to eq(images_path)
      expect(store.store).to be_instance_of(PStore)
    end

    it 'initializes store with empty state' do
      expect(store.ids).to eq([])
      expect(store.entities).to eq([])
    end

    it '#add rants to the store with additional data' do
      store.add([RrantHelper.fake_rant(1)])
      expect(store.empty?).to eq(false)
      expect(store.ids).to include(1)

      first = store.entities[0]
      keys = %w(created_at viewed_at image)

      expect(first).to include(RrantHelper.fake_rant(1))
      expect(first.keys).to include(*keys)
      expect(first['created_at']).to be_instance_of(DateTime)
    end

    it '#touch rant with given ID by setting viewed_at' do
      store.add([RrantHelper.fake_rant(2)])
      store.touch(2)

      rant = store.entities.detect { |r| r['id'] == 2 }
      expect(rant['viewed_at']).to_not be_nil
      expect(rant['viewed_at']).to be_instance_of(DateTime)
    end
  end

  context 'invalid path given' do
    it 'raises exception' do
      expect { described_class.new('invalidpath') }.to \
        raise_error(Rrant::Error::InvalidPath)
    end
  end
end
