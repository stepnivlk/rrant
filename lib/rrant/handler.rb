require 'rrant/local'
require 'rrant/remote'
require 'rrant/store'
require 'rrant/output'
require 'rrant/helper'

module Rrant
  # Public: Initializes all the necessary objects and contains
  # configuration methods.
  class Handler
    include Helper

    def initialize
      @store       = Store.new
      @unseen      = false
      @show_images = false
      @bill        = false
    end

    # Public: Finds random rant or bill and initializes output with it.
    #
    # Returns instance of Rrant::Output.
    def rave
      rant = @bill ? bill : local.unseen(@unseen).random
      Output.new(rant, @show_images)
    end

    # Public: Fetches rants from remote API. Returns bill if amount
    # is too high.
    #
    # min_amount - Integer, how many rants we want to fetch.
    #
    # Returns self.
    def dos(min_amount = 10)
      return @bill = true if min_amount > 80

      remote.save(min_amount)
      self
    end

    def and
      self
    end

    def with_images(set = true)
      @show_images = set
      self
    end

    def unseen(set = true)
      @unseen = set
      self
    end

    private

    def remote
      @remote ||= Remote.new(@store)
    end

    def local
      @local ||= Local.new(@store)
    end
  end
end
