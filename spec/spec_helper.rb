# frozen_string_literal: true

require "google/cloud/storage"
require "rantly/rspec_extensions"

require "stashify/google_cloud_storage"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module SpecUtils
  def self.temp_cloud_storage
    storage = Google::Cloud::Storage.new(project_id: ENV.fetch("GOOGLE_CLOUD_STORAGE_TEST_PROJECT", nil))
    bucket = storage.create_bucket(SecureRandom.uuid)
    yield(bucket)
  ensure
    if bucket
      bucket&.files&.each(&:delete)
      bucket.delete
    end
  end
end
