# frozen_string_literal: true

require 'sidekiq-scheduler'

class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform
    ::Carts::Manager.new.call!
  end
end
