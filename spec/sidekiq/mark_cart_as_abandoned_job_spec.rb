# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  before { Sidekiq::Testing.fake! }

  describe '#perform' do
    it 'enqueues the job' do
      expect do
        MarkCartAsAbandonedJob.perform_async
      end.to change { Sidekiq::Queues['default'].size }.by(1)
    end

    it 'executes the job' do
      expect_any_instance_of(Carts::Manager).to receive(:call!)

      MarkCartAsAbandonedJob.new.perform
    end
  end
end
