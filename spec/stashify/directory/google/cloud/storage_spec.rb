# frozen_string_literal: true

require "stashify/file"
require "stashify/contract/directory_contract"

require "stashify/directory/google/cloud/storage"

RSpec.describe Stashify::Directory::Google::Cloud::Storage, gcloud: true do
  around(:each) do |s|
    SpecUtils.temp_cloud_storage do |bucket|
      @bucket = bucket
      s.run
    end
  end

  include_context "directory setup", 10

  before(:each) do
    @bucket.create_file(StringIO.new(contents), File.join(path, file_name))
  end

  subject(:directory) do
    Stashify::Directory::Google::Cloud::Storage.new(
      bucket: @bucket,
      path: path,
    )
  end

  it_behaves_like "a directory"
end
