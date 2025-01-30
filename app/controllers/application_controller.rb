# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def recovery_in_redis(token)
    RedisApp.instance.get(token)
  end

  def save_in_redis(token, data)
    RedisApp.instance.set(token, data)
    RedisApp.instance.expire(token, 3.hours)
  end

  def current_session
    JSON.parse(current_devise_api_token.to_json)
  end
end
