# frozen_string_literal: true

require 'sidekiq-scheduler'

class DeleteTransactionsJob < ApplicationJob
  queue_as :default

  def perform
    Authorized.expired.destroy_all
  end
end
