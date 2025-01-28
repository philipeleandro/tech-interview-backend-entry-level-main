# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def recovery_in_redis(token)
    $redis.get(token)
  end

  def save_in_redis(token, data)
    $redis.set(token, data)
    $redis.expire(token, 1.hour)
  end

  def current_session
    JSON.parse(current_devise_api_token.to_json)
  end
end
