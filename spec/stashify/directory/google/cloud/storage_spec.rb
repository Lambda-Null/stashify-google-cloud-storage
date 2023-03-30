# frozen_string_literal: true

require "stashify/file"

require "stashify/directory/google/cloud/storage"

RSpec.describe Stashify::Directory::Google::Cloud::Storage, gcloud: true do
  around(:each) do |s|
    SpecUtils.temp_cloud_storage do |bucket|
      @bucket = bucket
      s.run
    end
  end

  let(:property_count) { 10 }

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
    properties.check(property_count) do |path, contents|
      @bucket.create_file(StringIO.new(contents), path)
      dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: File.dirname(path))
      file = dir.find(File.basename(path))
      expect(file).to eq(Stashify::File.new(name: File.basename(path), contents: contents))
    end
  end

  it "reads a directory" do
    properties.check(property_count) do |path, contents|
      @bucket.create_file(StringIO.new(contents), File.join(path, "foo"))
      dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: File.dirname(path))
      subdir = dir.find(File.basename(path))
      expect(subdir).to eq(Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: path))
    end
  end

  it "writes a file" do
    properties.check(property_count) do |path, contents|
      dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: File.dirname(path))
      dir.write(Stashify::File.new(name: File.basename(path), contents: contents))
      expect(@bucket.file(path).download.string).to eq(contents)
    end
  end

  it "writes a directory" do
    properties.check(property_count) do |path, contents|
      source_dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: File.dirname(path))
      file = Stashify::File.new(name: File.basename(path), contents: contents)
      source_dir.write(file)
      SpecUtils.temp_cloud_storage do |bucket|
        target_dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: bucket, path: "")
        target_dir.write(source_dir)
        expect(target_dir.find(source_dir.name).find(File.basename(path))).to eq(file)
      end
    end
  end

  it "deletes a file" do
    properties.check(property_count) do |path, contents|
      @bucket.create_file(StringIO.new(contents), path)
      Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket,
                                                      path: File.dirname(path),).delete(File.basename(path))
      expect(@bucket.file(path)).to be_nil
    end
  end

  it "deletes a directory" do
    properties.check(property_count) do |path, contents|
      dir = Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: File.dirname(path))
      subdir = Stashify::Directory::Google::Cloud::Storage.new(bucket: @bucket, path: path)
      subdir.write(Stashify::File.new(name: "foo", contents: contents))
      dir.delete(subdir.name)
      expect(dir.find(subdir.name)).to be_nil
    end
  end
end
