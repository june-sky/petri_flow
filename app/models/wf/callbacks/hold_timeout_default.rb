# frozen_string_literal: true

module Wf::Callbacks
  class HoldTimeoutDefault < ApplicationJob
    queue_as :default

    def perform(*guests)
      $stdout.puts(guests.inspect)
    end
  end
end
