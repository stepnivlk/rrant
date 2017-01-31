require 'rrant/helper'
require 'rrant/error'

module Rrant
  # Public: Contains local storage handling methods, operates on top of
  # store object.
  class Local
    include Helper

    def initialize(store)
      raise Error::InvalidStore unless store.is_a?(Store)

      @store = store
      @unseen = false
    end

    # Public: Returns random rant from the store. Returns placeholder if there
    # are no available rants. Updates rant's 'viewed_at' parameter.
    def random
      return placeholder if @store.empty?
      rant = pick_random
      return placeholder unless rant

      rant.tap { |tapped| @store.touch(tapped['id']) }
    end

    # Public: Sets 'unseen' instance variable and returns self. With 'unseen'
    # set to true, we fetch only rants with 'viewed_at' set to nil.
    def unseen(set)
      @unseen = set
      self
    end

    private

    # Private: Grabs random rant from the store according to 'unseen' instance
    # variable.
    def pick_random
      return @store.entities.sample unless @unseen

      @store.entities.reject { |rant| rant['viewed_at'] }.sample
    end

    def placeholder
      { 'text' => 'No rants available :/',
        'image' => "#{files_path}/devrant.png" }
    end
  end
end
