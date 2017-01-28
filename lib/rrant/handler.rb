require 'rrant/local'
require 'rrant/remote'
require 'rrant/store'
require 'rrant/output'

module Rrant
  class Handler
    def initialize(options = nil)
      @options = options || Hash.new(false)
      @store = Store.new
      @show_images = true
    end

    def rave
      rant = local.unseen(@unseen).random
      Output.new(rant, @show_images)
    end

    def dos
      Thread.new { remote.save }
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
