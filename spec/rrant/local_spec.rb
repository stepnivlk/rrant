require "spec_helper"
require 'rrant_helper'

describe Rrant::Local do
  context 'correct store given' do
    context 'when configuring its state' do
      after(:all) do
        RrantHelper.delete_root_path
      end

      let(:store) { Rrant::Store.new(RrantHelper.root_path) }
      let(:local) { described_class.new(store) }

      it 'sets unseen when receives unseen' do
        local.unseen(true)
        expect(local.instance_variable_get(:@unseen)).to eq(true)
      end

      it 'returns self when receives unseen' do
        expect(local.unseen(false)).to eq(local)
      end
    end

    context '#random without available rants' do
      after(:all) do
        RrantHelper.delete_root_path
      end

      let(:store) { Rrant::Store.new(RrantHelper.root_path) }
      let(:local) { described_class.new(store) }

      it 'returns placeholder when there are no rants in the store' do
        expect(local.random).to \
          include({ 'text' => 'No rants available :/' })
      end

      it 'returns placeholder when unseen is set and there are no other rants' do
        store.add([RrantHelper.fake_rant(1, true)])
        local.unseen(true)
        expect(local.random).to \
          include(RrantHelper.fake_placeholder)
      end
    end

    context '#random with available rants' do
      after(:all) do
        RrantHelper.delete_root_path
      end

      let(:store) { Rrant::Store.new(RrantHelper.root_path) }
      let(:local) { described_class.new(store) }

      it 'returns random rant when there is at least one available' do
        rant = RrantHelper.fake_rant(2)
        store.add([rant])

        expect(local.random).to \
          include(rant)
      end
    end
  end

  context 'invalid store given' do
    after(:all) do
      RrantHelper.delete_root_path
    end

    it 'raises error when store is not supported class' do
      expect { described_class.new('invalidstore') }.to \
        raise_error(Rrant::Error::InvalidStore)
    end
  end
end
