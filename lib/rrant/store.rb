require 'pstore'
require 'rrant/error'
require 'rrant/helper'

module Rrant
  # Public: Handles local storage using PStore and directory structure
  # initialization. Serializes given rants for proper storage.
  class Store
    include Helper

    attr_reader :root, :images, :store

    # Constructor: Initializes directories and store.
    #
    # path - Integer, directory where we want to store our rants/images
    def initialize(path = nil)
      path ||= Dir.home
      raise Error::InvalidPath unless Dir.exist?(path)

      @root = "#{path}/.rrant"
      @images = "#{@root}/images/"

      initialize_directories
      initialize_store
    end

    # Public: Adds serialized rants as 'entities' and 'ids' to the store.
    def add(rants)
      @store.transaction do
        @store[:ids] += build_ids(rants)
        @store[:entities] += build_entities(rants)
      end
    end

    def empty?
      ids.empty?
    end

    # Public: Gets array of 'entities' or 'ids' from the store.
    %i(ids entities).each do |bucket|
      define_method(bucket) do
        @store.transaction { @store[bucket] }
      end
    end

    # Public: Finds rant with given ID and updates its 'viewed_at' parameter.
    def touch(rant_id)
      @store.transaction do
        @store[:entities] = @store[:entities].map do |rant|
          rant['viewed_at'] = DateTime.now if rant['id'] == rant_id
          rant
        end
      end
    end

    private

    # Private: Creates directory structure if there isn't one.
    def initialize_directories
      Dir.mkdir(@root) unless Dir.exist?(@root)
      Dir.mkdir(@images) unless Dir.exist?(@images)
    end

    # Private: Initializes PStore to '@store' variable.
    # If there are no 'ids' or 'entities' in store, it creates them.
    def initialize_store
      @store = PStore.new("#{@root}/store.pstore")
      !ids && initialize_ids
      !entities && initialize_entities
    end

    def build_ids(rants)
      rants.map { |rant| rant['id'] }
    end

    def build_entities(rants)
      rants.map { |rant| inject_rant(rant) }
    end

    # Private: Adds additional parameters to rant.
    #
    # rant - Hash.
    def inject_rant(rant)
      rant.tap do |injected|
        injected['created_at'] = DateTime.now
        injected['viewed_at'] = injected['viewed_at'] || nil
        injected['image'] = image_for(injected)
      end
    end

    # Private: Adds 'attached_image' parameter to rant pointing to image
    # stored in '@images' directory.
    #
    # rant - Hash.
    def image_for(rant)
      return nil if image_blank?(rant)

      @images + rant['attached_image']['url'].split('/')[-1]
    end

    # Private: sets 'entities' and 'ids' in store to empty array.
    %i(ids entities).each do |bucket|
      define_method("initialize_#{bucket}") do
        @store.transaction { @store[bucket] = [] }
      end
    end
  end
end
