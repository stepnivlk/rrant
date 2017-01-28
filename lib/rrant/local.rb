require 'rrant/helper'

module Rrant
  class Local
    include Helper

    def initialize(store)
      @unseen = false
      @store = store
    end

    def random
      return placeholder if @store.empty?
      rant = pick_random
      return placeholder unless rant

      rant.tap { |r| @store.touch(r['id']) }
    end

    def unseen(set)
      @unseen = set
      self
    end

    private

    def pick_random
      return @store.entities.sample unless @unseen

      @store.entities.reject { |rant| !rant['viewed_at'].nil? }.sample
    end

    def placeholder
      { 'text' => 'No rants available :/',
        'image' => "#{files_path}/devrant.png" }
    end
  end
end
