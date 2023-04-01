# frozen_string_literal: true

require "google/cloud/storage"
require "securerandom"
require "stashify/contract/file_contract"

require "stashify/file/google/cloud/storage"

RSpec.describe Stashify::File::Google::Cloud::Storage, gcloud: true do
  around(:each) do |s|
    SpecUtils.temp_cloud_storage do |bucket|
      @bucket = bucket
      s.run
    end
  end

  include_context "file setup", 2

  before(:each) do
    @bucket.create_file(StringIO.new(contents), path)
  end

  subject(:file) do
    Stashify::File::Google::Cloud::Storage.new(bucket: @bucket, path: path)
  end

  it_behaves_like "a file"
end
