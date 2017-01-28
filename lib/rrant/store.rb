require 'pstore'
require 'rrant/error'

module Rrant
  class Store
    attr_reader :root, :images, :store

    def initialize(path = nil)
      path = path || Dir.home

      raise Error::InvalidPath unless Dir.exist?(path)

      @root = "#{path}/.rrant"
      @images = "#{@root}/images/"

      initialize_directories
      initialize_store
    end

    def add(rants)
      @store.transaction do
        @store[:ids] += build_ids(rants)
        @store[:entities] += build_entities(rants)
      end
    end

    def empty?
      ids.empty?
    end

    %i(ids entities).each do |bucket|
      define_method(bucket) do
        @store.transaction { @store[bucket] }
      end
    end

    def touch(rant_id)
      @store.transaction do
        @store[:entities] = @store[:entities].map do |rant|
          rant['viewed_at'] = DateTime.now if rant['id'] == rant_id
          rant
        end
      end
    end

    private

    def build_ids(rants)
      rants.map { |rant| rant['id'] }
    end

    def build_entities(rants)
      rants.map { |rant| inject_rant(rant) }
    end

    def inject_rant(rant)
      rant.tap do |injected|
        injected['created_at'] = DateTime.now
        injected['viewed_at'] = nil
        injected['image'] = image_for(injected)
      end
    end

    def image_for(rant)
      return nil if rant['attached_image'] == ''

      rant['attached_image']['url'].split('/')[-1]
    end

    def initialize_store
      @store = PStore.new("#{@root}/store.pstore")
      !ids && initialize_ids
      !entities && initialize_entities
    end

    %i(ids entities).each do |bucket|
      define_method("initialize_#{bucket}") do
        @store.transaction { @store[bucket] = [] }
      end
    end

    def initialize_directories
      Dir.mkdir(@root) unless Dir.exist?(@root)
      Dir.mkdir(@images) unless Dir.exist?(@images)
    end
  end
end
