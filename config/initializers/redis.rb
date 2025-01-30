# frozen_string_literal: true

module RedisApp
  def self.instance
    @instance ||= Redis.new(url: redis_url)
  end

  def self.redis_url
    return 'redis://redis:6379/1' if Rails.env.test?

    'redis://redis:6379/0'
  end
end
