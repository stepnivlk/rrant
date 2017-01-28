require 'httparty'
require 'open-uri'
require 'rrant/helper'
require 'rrant/error'

module Rrant
  class Remote
    include Helper

    attr_reader :rants

    BASE_URL = 'https://www.devrant.io/api/devrant/rants?app=3'
    MAX_CYCLE = 10
    SLEEP = 0.4

    def initialize(store, skip_images = true)
      raise Error::InvalidStore unless store.is_a?(Store)

      @rants = []
      @store = store
      @skip_images = skip_images
    end

    def save(min_amount = 10)
      @min_amount = min_amount
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
      ->(cycle) { @rants.size < @min_amount && cycle < MAX_CYCLE }
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
      return unless @skip_images

      @rants.each do |rant|
        next if image_blank?(rant)
        fetch_image(rant)
        sleep SLEEP
      end
    end

    def fetch_image(rant)
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
