# frozen_string_literal: true

require "google/cloud/storage"

require "securerandom"

require "stashify/file/google_cloud_storage"

RSpec.describe Stashify::File::GoogleCloudStorage do
  around(:each) do |s|
    SpecUtils.temp_cloud_storage do |bucket|
      @bucket = bucket
      s.run
    end
  end

  let(:properties) do
    property_of do
      path = array(5) do
        dir = string
        guard dir !~ %r{/}
        dir
      end
      [File.join(path), string]
    end
  end

  it "takes a bucket and a path for the constructor" do
    properties.check(10) do |path, contents|
      @bucket.create_file(StringIO.new(contents), path)
      file = Stashify::File::GoogleCloudStorage.new(@bucket, path)
      expect(file.name).to eq(File.basename(path))
      expect(file.contents).to eq(contents)
    end
  end
end
