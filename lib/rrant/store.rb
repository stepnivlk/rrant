module Rrant
  class Store
    attr_reader :root, :images, :store

    def initialize(path = nil)
      @root = "#{path || Dir.home}/.rrant"
      @images = "#{@root}/images/"

      bootstrap_directories
      bootstrap_store
    end

    def add(rants)
      @store.transaction do
        @store[:ids] = @store[:ids] + rants.map { |rant| rant['id'] }
        @store[:entities] = @store[:entities] + rants
      end
    end

    def ids
      @store.transaction { @store[:ids] }
    end

    def entities
      @store.transaction { @store[:entities] }
    end

    private

    def bootstrap_store
      @store = PStore.new("#{@root}/store.pstore")
      !ids && bootstrap_ids
      !entities && bootstrap_entities
    end

    def bootstrap_ids
      @store.transaction { @store[:ids] = [] }
    end

    def bootstrap_entities
      @store.transaction { @store[:entities] = [] }
    end

    def bootstrap_directories
      Dir.mkdir(@root) unless Dir.exists?(@root)
      Dir.mkdir(@images) unless Dir.exists?(@images)
    end
  end
end
