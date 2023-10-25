class ReadysetCache < ActiveSupport::Cache::Store
  def self.supports_cache_versioning?
    true
  end

  def initialize(options = {}, &blk)
    puts "options are #{options} and rails env is #{Rails.env}"
  end

  def fetch(name, options = nil, &block)
    ActiveRecord::Base.connected_to(role: :caching) do
      if block_given?
        yield
      end
    end
  end
end
