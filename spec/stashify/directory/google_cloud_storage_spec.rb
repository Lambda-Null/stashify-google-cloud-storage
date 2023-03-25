# frozen_string_literal: true

require "stashify/file"

require "stashify/directory/google_cloud_storage"

RSpec.describe Stashify::Directory::GoogleCloudStorage do
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

  it "reads a file" do
    properties.check(10) do |path, contents|
      @bucket.create_file(StringIO.new(contents), path)
      dir = Stashify::Directory::GoogleCloudStorage.new(@bucket, File.dirname(path))
      file = dir.find(File.basename(path))
      expect(file).to eq(Stashify::File.new(name: File.basename(path), contents: contents))
    end
  end

  it "reads a directory" do
    properties.check(10) do |path, contents|
      @bucket.create_file(StringIO.new(contents), File.join(path, "foo"))
      dir = Stashify::Directory::GoogleCloudStorage.new(@bucket, File.dirname(path))
      subdir = dir.find(File.basename(path))
      expect(subdir).to eq(Stashify::Directory::GoogleCloudStorage.new(@bucket, path))
    end
  end
end
