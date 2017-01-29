require 'httparty'
require 'open-uri'
require 'rrant/helper'
require 'rrant/error'

module Rrant
  # Public: Contains necessary logic to contanct remote API, fetch rants and
  # images. Needs to be initialized with store object, since we add fetched
  # rants to it.
  class Remote
    include Helper

    attr_reader :rants

    BASE_URL  = 'https://www.devrant.io/api/devrant/rants?app=3'
    MAX_CYCLE = 10
    SLEEP     = 0.4

    # Public: Constructor.
    #
    # store - Instance of Rrant::Store.
    # skip_images - Boolean, when set we won't download images.
    def initialize(store, skip_images = true)
      raise Error::InvalidStore unless store.is_a?(Store)

      @rants       = []
      @store       = store
      @skip_images = skip_images
    end

    # Public: Calls rant fetching methods, adds fetched rants to store and
    # puts basic info to STDOUT. Since rants are fetched in batches of 20,
    # we dont want to discard some of them, thus we accept minimum amount
    # and are ok with more rants fetched.
    #
    # min_amount - Integer, fetch at least this amount of rants.
    #
    # Returns an array of rants.
    def save(min_amount)
      @min_amount = min_amount
      log_start
      build_rants
      fetch_images
      @store.add(@rants)
      log_finish

      @rants
    end

    private

    def log_start
      puts '>> Download started!'
    end

    def log_finish
      puts ">> #{@rants.size} Rants downloaded and stored!"
    end

    # Private: Fetches rants from remote API. Filters out rants whic are
    # already stored, waits some time so we won't endanger the API.
    # Then it recursivelly calls itself 'build_allowed?' condition is true.
    #
    # cycle - Integer.
    #
    # Returns self.
    def build_rants(cycle = 0)
      fetch_rants(cycle)
      filter_rants
      sleep SLEEP
      return unless build_allowed?.call(cycle)

      build_rants(cycle + 1)
    end

    # Private: Wrapper method around lambda. Checks whether we already fetched
    # necessary amount of rants, or if we were requesting API to many times.
    def build_allowed?
      ->(cycle) { @rants.size < @min_amount && cycle < MAX_CYCLE }
    end

    # Private: Grabs rant IDs from store and checks them agains '@rants',
    # which is then mutated to reject rants with same IDs as stored ones.
    def filter_rants
      stored_ids = @store.ids

      @rants = @rants.reject do |rant|
        stored_ids.include?(rant['id'])
      end
    end

    # Private: Contacts API and gets array of rants from the response.
    def fetch_rants(skip = 0, sort = :algo)
      response = HTTParty.get(build_url(skip, sort))
      @rants += response['rants']
    end

    # Private: Iterates over '@rants' and calls 'fetch_image' for each of them
    # only when it has some image attached. Sleeps some time after fetch.
    def fetch_images
      return unless @skip_images

      @rants.each do |rant|
        next if image_blank?(rant)
        fetch_image(rant)
        sleep SLEEP
      end
    end

    # Private: Grabs image URL from rant, downloads it and stores it to path
    # defined in '@store.images'.
    def fetch_image(rant)
      url = rant['attached_image']['url']
      download = open(url)
      path = @store.images + url.split('/')[-1]
      IO.copy_stream(download, path)
    end

    # Private: taps into 'BASE_URL' and adds parameters to it.
    #
    # skip - Integer, defines how many rants we want to skip.
    # sort - Symbol, defines rant sorting mechanism.
    #
    # Returns string.
    def build_url(skip, sort)
      BASE_URL.tap do |url|
        skip != 0 && url << "&skip=#{skip * 20}"
        url << "&sort=#{sort}"
      end
    end
  end
end
