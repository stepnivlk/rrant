require 'httparty'
require 'open-uri'

module Rrant
  class Remote
    attr_reader :rants

    BASE_URL = 'https://www.devrant.io/api/devrant/rants?app=3'
    MAX_CYCLE = 10
    SLEEP = 0.4

    def initialize(store)
      @rants = []
      @store = store
    end

    def save(amount = 10)
      @amount = amount
      build_rants
      fetch_images
      @store.add(@rants)
    end

    private

    def build_rants(cycle = 0)
      fetch_rants(cycle)
      filter_rants
      sleep SLEEP
      return unless build_allowed?.call(cycle)

      build_rants(cycle + 1)
    end

    def build_allowed?
      ->(cycle) { @rants.size < @amount && cycle < MAX_CYCLE }
    end

    def filter_rants
      stored_ids = @store.ids

      @rants = @rants.reject do |rant|
        stored_ids.include?(rant['id'])
      end
    end

    def fetch_rants(skip = 0, sort = :algo)
      response = HTTParty.get(build_url(skip, sort))
      @rants += response['rants']
    end

    def fetch_images
      @rants.each do |rant|
        fetch_image(rant)
        sleep SLEEP
      end
    end

    def fetch_image(rant)
      return if rant['attached_image'] == ''

      url = rant['attached_image']['url']
      download = open(url)
      path = @store.images + url.split('/')[-1]
      IO.copy_stream(download, path)
    end

    def build_url(skip, sort)
      BASE_URL.tap do |url|
        skip != 0 && url << "&skip=#{skip * 20}"
        url << "&sort=#{sort}"
      end
    end
  end
end
