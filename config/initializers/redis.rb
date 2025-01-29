# frozen_string_literal: true

redis_url = if Rails.env.test?
              'redis://redis:6379/1'
            else
              'redis://redis:6379/0'
            end

$redis = Redis.new(url: redis_url)
