module Rrant
  class Store
    attr_reader :root, :images, :store

    def initialize(path = nil)
      @root = "#{path || Dir.home}/.rrant"
      @images = "#{@root}/images/"

      initialize_directories
      initialize_store
    end

    def add(rants)
      @store.transaction do
        @store[:ids] = @store[:ids] + build_ids(rants)
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

    def build_ids(rants)
      rants.map { |rant| rant['id'] }
    end

    def build_entities(rants)
    end

    def initialize_store
      @store = PStore.new("#{@root}/store.pstore")
      !ids && initialize_ids
      !entities && initialize_entities
    end

    def initialize_ids
      @store.transaction { @store[:ids] = [] }
    end

    def initialize_entities
      @store.transaction { @store[:entities] = [] }
    end

    def initialize_directories
      Dir.mkdir(@root) unless Dir.exist?(@root)
      Dir.mkdir(@images) unless Dir.exist?(@images)
    end
  end
end
